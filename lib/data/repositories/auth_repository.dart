import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/bootstrap.dart';

/// Redirect die iOS en Android terugstuurt naar de app na een herstelmail.
/// Het schema staat in Info.plist en AndroidManifest.
const kAuthRedirect = 'app.kalorie://login-callback';

/// Wat er misging, in taal die je aan de gebruiker kunt tonen.
enum AuthFailure {
  invalidCredentials,
  emailTaken,
  weakPassword,
  leakedPassword,
  invalidEmail,
  needsConfirmation,
  rateLimited,
  network,
  unavailable,
  unknown,
}

class KalorieAuthException implements Exception {
  const KalorieAuthException(this.failure, [this.raw]);

  final AuthFailure failure;
  final String? raw;

  @override
  String toString() => 'KalorieAuthException($failure, $raw)';
}

class AuthRepository {
  AuthRepository();

  bool get isAvailable => KalorieBootstrap.cloudReady;

  GoTrueClient get _auth => Supabase.instance.client.auth;

  Session? get session => isAvailable ? _auth.currentSession : null;

  User? get user => isAvailable ? _auth.currentUser : null;

  bool get isSignedIn => session != null;

  Stream<AuthState> get changes =>
      isAvailable ? _auth.onAuthStateChange : const Stream.empty();

  /// `true` als er meteen een sessie is, `false` als de bevestigingsmail
  /// nog openstaat.
  Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await _requireCloud();
    try {
      final response = await _auth.signUp(
        email: email.trim(),
        password: password,
        emailRedirectTo: kAuthRedirect,
        data: {
          if (displayName != null && displayName.trim().isNotEmpty)
            'display_name': displayName.trim(),
        },
      );
      return response.session != null;
    } on AuthWeakPasswordException catch (e) {
      throw KalorieAuthException(_mapWeak(e), e.message);
    } on AuthApiException catch (e) {
      throw KalorieAuthException(_mapApi(e), e.message);
    } on AuthRetryableFetchException catch (e) {
      throw KalorieAuthException(AuthFailure.network, e.message);
    } on KalorieAuthException {
      rethrow;
    } on AuthException catch (e) {
      throw KalorieAuthException(_mapMessage(e.message, e.code), e.message);
    } catch (e) {
      throw KalorieAuthException(AuthFailure.unknown, '$e');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _requireCloud();
    try {
      await _auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthWeakPasswordException catch (e) {
      throw KalorieAuthException(_mapWeak(e), e.message);
    } on AuthApiException catch (e) {
      throw KalorieAuthException(_mapApi(e), e.message);
    } on AuthRetryableFetchException catch (e) {
      throw KalorieAuthException(AuthFailure.network, e.message);
    } on AuthException catch (e) {
      throw KalorieAuthException(_mapMessage(e.message, e.code), e.message);
    } catch (e) {
      throw KalorieAuthException(AuthFailure.unknown, '$e');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _requireCloud();
    try {
      await _auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: kAuthRedirect,
      );
    } on AuthApiException catch (e) {
      throw KalorieAuthException(_mapApi(e), e.message);
    } on AuthRetryableFetchException catch (e) {
      throw KalorieAuthException(AuthFailure.network, e.message);
    } catch (e) {
      throw KalorieAuthException(AuthFailure.unknown, '$e');
    }
  }

  Future<void> updatePassword(String password) async {
    await _requireCloud();
    try {
      await _auth.updateUser(UserAttributes(password: password));
    } on AuthWeakPasswordException catch (e) {
      throw KalorieAuthException(_mapWeak(e), e.message);
    } on AuthApiException catch (e) {
      throw KalorieAuthException(_mapApi(e), e.message);
    } on AuthException catch (e) {
      throw KalorieAuthException(_mapMessage(e.message, e.code), e.message);
    } catch (e) {
      throw KalorieAuthException(AuthFailure.unknown, '$e');
    }
  }

  Future<void> updateDisplayName(String name) async {
    if (!isAvailable || !isSignedIn) return;
    await _auth.updateUser(UserAttributes(data: {'display_name': name.trim()}));
    await Supabase.instance.client
        .from('profiles')
        .update({'display_name': name.trim()}).eq('id', user!.id);
  }

  Future<void> signOut() async {
    if (!isAvailable) return;
    await _auth.signOut();
  }

  /// Wist het account en, via `on delete cascade`, alles wat eraan hangt.
  Future<void> deleteAccount() async {
    await _requireCloud();
    try {
      await Supabase.instance.client.rpc<void>('delete_account');
    } on PostgrestException catch (e) {
      throw KalorieAuthException(AuthFailure.unknown, e.message);
    } catch (e) {
      if (e is KalorieAuthException) rethrow;
      throw KalorieAuthException(AuthFailure.unknown, '$e');
    }
    try {
      await _auth.signOut();
    } catch (_) {
      // Sessie is vaak al dood nadat de user is gewist.
    }
  }

  Future<void> _requireCloud() async {
    if (isAvailable) return;
    await KalorieBootstrap.ensureCloud();
    if (!isAvailable) {
      throw const KalorieAuthException(AuthFailure.unavailable);
    }
  }

  static AuthFailure _mapWeak(AuthWeakPasswordException e) {
    final reasons = e.reasons.map((r) => r.toLowerCase()).join(' ');
    if (reasons.contains('pwned') ||
        reasons.contains('leaked') ||
        e.message.toLowerCase().contains('pwned') ||
        e.message.toLowerCase().contains('leaked')) {
      return AuthFailure.leakedPassword;
    }
    return AuthFailure.weakPassword;
  }

  static AuthFailure _mapApi(AuthApiException e) =>
      _mapMessage(e.message, e.code);

  static AuthFailure _mapMessage(String message, [String? code]) {
    final c = (code ?? '').toLowerCase();
    final m = message.toLowerCase();
    if (c == 'over_email_send_rate_limit' ||
        m.contains('rate limit') ||
        m.contains('too many requests')) {
      return AuthFailure.rateLimited;
    }
    if (c == 'invalid_credentials' ||
        m.contains('invalid login credentials')) {
      return AuthFailure.invalidCredentials;
    }
    if (c == 'user_already_exists' ||
        m.contains('already registered') ||
        m.contains('already been registered')) {
      return AuthFailure.emailTaken;
    }
    if (c == 'weak_password' ||
        m.contains('password should be') ||
        m.contains('leaked') ||
        m.contains('pwned')) {
      return m.contains('leaked') || m.contains('pwned')
          ? AuthFailure.leakedPassword
          : AuthFailure.weakPassword;
    }
    if (c == 'validation_failed' || m.contains('invalid email')) {
      return AuthFailure.invalidEmail;
    }
    if (c == 'email_not_confirmed' || m.contains('not confirmed')) {
      return AuthFailure.needsConfirmation;
    }
    return AuthFailure.unknown;
  }
}
