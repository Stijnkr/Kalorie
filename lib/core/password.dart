/// Wachtwoordregel: lengte eerst, geen schijnbare complexiteitseisen.
/// NIST SP 800-63B: liever lang dan "hoofdletter + cijfer + teken".
abstract final class PasswordRules {
  static const minLength = 10;

  static bool isStrong(String password, {String? email}) {
    if (password.length < minLength) return false;
    if (password.trim().length < minLength) return false;
    if (password.split('').toSet().length < 3) return false;
    final mail = email?.trim().toLowerCase();
    if (mail != null && mail.isNotEmpty && password.toLowerCase() == mail) {
      return false;
    }
    return true;
  }
}
