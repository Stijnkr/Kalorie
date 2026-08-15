import 'dart:convert';

enum NutrientGroup { energy, macro, carb, fat, mineral, vitamin, other }

class NutrientDef {
  const NutrientDef({
    required this.code,
    required this.nameNl,
    required this.unit,
    required this.group,
    required this.decimals,
    required this.isCore,
    required this.sortOrder,
  });

  final String code;
  final String nameNl;
  final String unit;
  final NutrientGroup group;
  final int decimals;
  final bool isCore;
  final int sortOrder;

  factory NutrientDef.fromJson(Map<String, dynamic> json) {
    return NutrientDef(
      code: json['code'] as String,
      nameNl: json['name_nl'] as String,
      unit: json['unit'] as String,
      group: NutrientGroup.values.firstWhere(
        (g) => g.name == json['group'],
        orElse: () => NutrientGroup.other,
      ),
      decimals: json['decimals'] as int? ?? 1,
      isCore: json['is_core'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

abstract final class NutrientCodes {
  static const enercc = 'ENERCC';
  static const prot = 'PROT';
  static const cho = 'CHO';
  static const fat = 'FAT';
  static const fibt = 'FIBT';
  static const sugar = 'SUGAR';
  static const fasat = 'FASAT';
  static const alc = 'ALC';
  static const na = 'NA';
  static const vitc = 'VITC';
  static const fe = 'FE';
  static const ca = 'CA';

  static const core = <String>{
    enercc,
    prot,
    cho,
    fat,
    fibt,
    sugar,
    fasat,
    alc,
    na,
  };
}

double sodiumMgToSaltG(double naMg) => naMg * 2.5 / 1000;

String? encodeNutrients(Map<String, double>? map) {
  if (map == null || map.isEmpty) return null;
  return jsonEncode(map);
}

Map<String, double> decodeNutrients(String? raw) {
  if (raw == null || raw.isEmpty) return const {};
  final decoded = jsonDecode(raw);
  if (decoded is! Map) return const {};
  return decoded.map(
    (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
  );
}
