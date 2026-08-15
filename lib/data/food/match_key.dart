/// Name / brand / barcode normalisation. Keep in sync with tool/food_db/normalize.py.
abstract final class MatchKey {
  static final _punct = RegExp(r'''[®™©'’".,;:/+&()\[\]{}!?\\-]+''');
  static final _size = RegExp(
    r'\b\d+(?:[.,]\d+)?\s*(?:mg|g|kg|ml|cl|l|stuks?|st)\b',
    caseSensitive: false,
  );
  static final _ws = RegExp(r'\s+');
  static const _stop = {
    'de',
    'het',
    'een',
    'en',
    'van',
    'met',
    'voor',
    'vers',
  };
  static final _nonDigit = RegExp(r'\D+');

  static String unaccent(String text) {
    const from = 'àáâãäåèéêëìíîïòóôõöùúûüýÿçñ';
    const to = 'aaaaaaeeeeiiiiooooouuuuyycn';
    final buf = StringBuffer();
    for (final rune in text.toLowerCase().runes) {
      final ch = String.fromCharCode(rune);
      final i = from.indexOf(ch);
      buf.write(i >= 0 ? to[i] : ch);
    }
    return buf.toString();
  }

  static String normalizeSearch(String text) {
    var s = unaccent(text.trim());
    s = s.replaceAll(_punct, ' ');
    return s.replaceAll(_ws, ' ').trim();
  }

  static String normalizeMatch(String text) {
    var s = normalizeSearch(text);
    s = s.replaceAll(_size, ' ');
    s = s.replaceAll(_ws, ' ').trim();
    final tokens = s
        .split(' ')
        .where((t) => t.isNotEmpty && !_stop.contains(t))
        .toList();
    return tokens.join(' ');
  }

  static String matchKey(String? brand, String name) {
    final n = normalizeMatch(name);
    final b = normalizeMatch(brand ?? '');
    if (b.isEmpty) return n;
    return '$b|$n';
  }

  static String? normalizeBarcode(String? code) {
    if (code == null || code.isEmpty) return null;
    var digits = code.replaceAll(_nonDigit, '');
    if (digits.length == 12) digits = '0$digits';
    if (digits.length >= 8 && digits.length <= 14) return digits;
    return null;
  }
}
