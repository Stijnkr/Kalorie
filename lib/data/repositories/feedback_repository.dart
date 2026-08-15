import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/bootstrap.dart';
import '../../core/constants.dart';

enum FeedbackKind { idea, problem, other }

class FeedbackException implements Exception {
  const FeedbackException();
}

class FeedbackRepository {
  FeedbackRepository();

  Future<void> send({
    required FeedbackKind kind,
    required String message,
  }) async {
    if (!KalorieBootstrap.cloudReady) {
      throw const FeedbackException();
    }
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw const FeedbackException();
    try {
      await client.from('feedback').insert({
        'user_id': userId,
        'kind': kind.name,
        'message': message.trim(),
        'app_version': AppInfo.version,
        'platform': Platform.operatingSystem,
      });
    } catch (_) {
      throw const FeedbackException();
    }
  }
}
