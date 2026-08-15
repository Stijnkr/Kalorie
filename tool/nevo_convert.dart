// Converts a NEVO-online CSV export to the compact JSON Kalorie ships.
//
// Usage:
//   dart run tool/nevo_convert.dart path/to/nevo.csv assets/nevo/nevo_2025_9_0.min.json
//
// Accepts semicolon- or comma-separated files. Looks for NEVO-code, name,
// ENERCC (kcal), PROT, CHO, FAT. Nutrient values are copied unchanged.

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
      'Usage: dart run tool/nevo_convert.dart <input.csv> <output.json>',
    );
    exit(64);
  }

  final input = File(args[0]);
  final output = File(args[1]);
  if (!input.existsSync()) {
    stderr.writeln('Input not found: ${args[0]}');
    exit(66);
  }

  final text = input.readAsStringSync();
  final lines = const LineSplitter().convert(text);
  if (lines.isEmpty) {
    stderr.writeln('Empty CSV');
    exit(65);
  }

  final delimiter = lines.first.contains(';') ? ';' : ',';
  final headers = _split(lines.first, delimiter)
      .map((h) => h.trim().toLowerCase())
      .toList();

  int col(List<String> names) {
    for (final name in names) {
      final i = headers.indexWhere((h) => h.contains(name));
      if (i >= 0) return i;
    }
    return -1;
  }

  final codeI = col(['nevo-code', 'nevo_code', 'nevocode', 'code']);
  final nameI = col([
    'voedingsmiddelnaam',
    'productnaam',
    'foodname',
    'food name',
    'name',
  ]);
  final groupI = col(['productgroep', 'foodgroup', 'group']);
  final kcalI = col(['enercc (kcal)', 'enercc_kcal', 'kcal', 'enercc']);
  final protI = col(['prot', 'protein', 'eiwit']);
  final choI = col(['cho', 'carbohydrate', 'koolhydraat']);
  final fatI = col(['fat', 'vet']);

  if (codeI < 0 || nameI < 0 || kcalI < 0) {
    stderr.writeln('Could not detect required columns. Headers: $headers');
    exit(65);
  }

  final items = <Map<String, Object?>>[];
  for (var i = 1; i < lines.length; i++) {
    if (lines[i].trim().isEmpty) continue;
    final cols = _split(lines[i], delimiter);
    String at(int index) =>
        index >= 0 && index < cols.length ? cols[index].trim() : '';

    final name = at(nameI);
    final kcal = _num(at(kcalI));
    if (name.isEmpty || kcal == null) continue;

    items.add({
      'code': at(codeI),
      'name': name,
      'group': groupI >= 0 ? at(groupI) : null,
      'kcal': kcal,
      'protein': _num(at(protI)) ?? 0,
      'carbs': _num(at(choI)) ?? 0,
      'fat': _num(at(fatI)) ?? 0,
    });
  }

  final payload = {
    'version': '2025/9.0',
    'source': 'NEVO online, version 2025/9.0. RIVM, Bilthoven.',
    'items': items,
  };

  output.parent.createSync(recursive: true);
  output.writeAsStringSync(jsonEncode(payload));
  stdout.writeln('Wrote ${items.length} foods to ${output.path}');
}

List<String> _split(String line, String delimiter) {
  return line.split(delimiter).map((c) => c.replaceAll('"', '')).toList();
}

num? _num(String raw) {
  if (raw.isEmpty || raw == '-' || raw.toLowerCase() == 'na') return null;
  return num.tryParse(raw.replaceAll(',', '.'));
}
