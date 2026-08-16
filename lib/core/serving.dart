class HouseholdPortion {
  const HouseholdPortion({
    required this.label,
    required this.grams,
    this.count = 1,
    this.liquid = false,
  });

  /// Korte naam zonder aantal: `glas`, `snee`, `ei`.
  final String label;

  /// Gram (of ml) voor [count] eenheden.
  final double grams;
  final double count;
  final bool liquid;

  String get unit => liquid ? 'ml' : 'g';

  String get chipLabel => ServingMath.countLabel(count, label);

  String get chipDetail => '$chipLabel (${grams.round()} $unit)';
}

/// Nederlandse huishoudmaten (Voedingscentrum / NEVO-gebruik).
/// Alleen generieke maten — geen `ei`, dat is te specifiek om willekeurige
/// 50 g als "1 ei" te lezen.
const dutchPortions = <HouseholdPortion>[
  HouseholdPortion(label: 'theelepel', grams: 5, liquid: true),
  HouseholdPortion(label: 'eetlepel', grams: 15, liquid: true),
  HouseholdPortion(label: 'handje', grams: 25),
  HouseholdPortion(label: 'snee', grams: 35),
  HouseholdPortion(label: 'stuk', grams: 80),
  HouseholdPortion(label: 'kop', grams: 125, liquid: true),
  HouseholdPortion(label: 'bakje', grams: 150),
  HouseholdPortion(label: 'glas', grams: 200, liquid: true),
  HouseholdPortion(label: 'kom', grams: 250),
  HouseholdPortion(label: 'blikje', grams: 330, liquid: true),
  HouseholdPortion(label: 'bord', grams: 350),
];

/// Alias voor schermen die alleen label + gram nodig hebben.
const servingPresets = <({String label, double grams})>[
  (label: '1 theelepel', grams: 5),
  (label: '1 eetlepel', grams: 15),
  (label: '1 plak', grams: 20),
  (label: '1 handje', grams: 25),
  (label: '1 snee', grams: 35),
  (label: '1 ei', grams: 50),
  (label: '1 omelet', grams: 120),
  (label: '1 opscheplepel', grams: 50),
  (label: '1 stuk', grams: 80),
  (label: '1 kop', grams: 125),
  (label: '1 bakje', grams: 150),
  (label: '1 schaaltje', grams: 150),
  (label: '1 glas', grams: 200),
  (label: '1 kom', grams: 250),
  (label: '1 blikje', grams: 330),
  (label: '1 bord', grams: 350),
];

enum _PortionFamily {
  egg,
  bread,
  cheese,
  liquid,
  spread,
  nuts,
  dairy,
  fruit,
  veg,
  meat,
  snack,
  soup,
  meal,
  grain,
  spice,
  other,
}

enum _EggForm { whole, yolk, white, powder, omelet }

class ServingMath {
  static double gramsFromPortions(double portions, double servingG) =>
      portions * servingG;

  static double portionsFromGrams(double grams, double servingG) {
    if (servingG <= 0) return 0;
    return grams / servingG;
  }

  static String formatCount(double value) {
    final half = (value * 2).round() / 2;
    if ((value - half).abs() < 0.05) {
      if (half == half.roundToDouble()) return '${half.round()}';
      return half.toStringAsFixed(1).replaceAll('.', ',');
    }
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }

  static String describe({
    required double grams,
    double? servingG,
    String? servingLabel,
    String? name,
    String? category,
    bool liquid = false,
  }) {
    final unit = liquid ? 'ml' : 'g';
    final rounded = grams.round();
    final portion = matchPortion(
      grams: grams,
      servingG: servingG,
      servingLabel: servingLabel,
      name: name,
      category: category,
      liquid: liquid,
    );
    if (portion != null) {
      return '${portion.text} ($rounded $unit)';
    }
    return '$rounded $unit';
  }

  /// Compacte weergave voor recents, bijv. `1 glas` of `40 g`.
  static String describeShort({
    required double grams,
    double? servingG,
    String? servingLabel,
    String? name,
    String? category,
    bool liquid = false,
  }) {
    final portion = matchPortion(
      grams: grams,
      servingG: servingG,
      servingLabel: servingLabel,
      name: name,
      category: category,
      liquid: liquid,
    );
    if (portion != null) return portion.text;
    return '${grams.round()} ${liquid ? 'ml' : 'g'}';
  }

  static ({String text, double count})? matchPortion({
    required double grams,
    double? servingG,
    String? servingLabel,
    String? name,
    String? category,
    bool liquid = false,
  }) {
    if (name != null || category != null) {
      for (final chip in suggestionsFor(
        name: name,
        category: category,
        servingG: servingG,
        servingLabel: servingLabel,
      )) {
        if ((chip.grams - grams).abs() < 1) {
          return (text: chip.chipLabel, count: chip.count);
        }
      }
    }
    if (servingG != null && servingG > 0) {
      final portions = grams / servingG;
      final snapped = (portions * 2).round() / 2;
      if ((portions - snapped).abs() < 0.08) {
        return (
          text: countLabel(snapped, servingLabel ?? 'portie'),
          count: snapped,
        );
      }
    }
    if (liquid) {
      final houses = dutchPortions.where((p) => p.liquid).toList()
        ..sort((a, b) => b.grams.compareTo(a.grams));
      for (final house in houses) {
        final portions = grams / house.grams;
        final snapped = portions.roundToDouble();
        if (snapped != 1 && snapped != 2) continue;
        if ((portions - snapped).abs() < 0.08) {
          return (text: countLabel(snapped, house.label), count: snapped);
        }
      }
    }
    return null;
  }

  /// `1 snee`, `2 sneetjes` — nooit `2 × 1 snee`.
  /// Cataloguslabel `1/2 stuk`: 1× = ½ stuk, 2× = 1 stuk.
  static String countLabel(double count, String rawLabel) {
    var label = rawLabel.trim();
    final halfUnit = label.startsWith('1/2 ');
    if (halfUnit) {
      label = label.substring(4).trim();
    } else if (label.startsWith('1 ')) {
      label = label.substring(2).trim();
    }
    if (label.isEmpty) label = 'portie';
    if (halfUnit) {
      if (count == 1) return '½ $label';
      if (count == 2) return '1 $label';
      if (count == 0.5) return '¼ $label';
      return countLabel(count / 2, label);
    }
    if (count == 0.5) return '½ $label';
    if (count == 1) return '1 $label';
    return '${formatCount(count)} ${_pluralOf(label)}';
  }

  static double defaultGrams({
    double? lastAmountG,
    double? servingG,
    bool liquid = false,
    String? name,
    String? category,
    String? servingLabel,
  }) {
    if (lastAmountG != null && lastAmountG > 0) return lastAmountG;
    if (name != null || category != null || servingLabel != null) {
      final first = suggestionsFor(
        name: name,
        category: category,
        servingG: servingG,
        servingLabel: servingLabel,
      );
      if (first.isNotEmpty) return first.first.grams;
    }
    if (servingG != null && servingG > 0) return servingG;
    return liquid ? 200 : 100;
  }

  static bool looksLiquid({
    String? name,
    String? category,
    String? servingLabel,
  }) {
    final hay = '${name ?? ''} ${category ?? ''} ${servingLabel ?? ''}'
        .toLowerCase();
    if (_hasWord(hay, const [
      'melk',
      'karnemelk',
      'sap',
      'juice',
      'water',
      'koffie',
      'thee',
      'cola',
      'frisdrank',
      'limonade',
      'bier',
      'wijn',
      'drink',
      'smoothie',
      'milkshake',
      'yoghurtdrink',
      'ranja',
      'ijsthee',
      'energydrink',
    ])) {
      return true;
    }
    if (hay.contains('ice tea') || hay.contains('energy drink')) return true;
    return _hasWord(hay, const ['glas', 'kop', 'blikje', 'fles']);
  }

  /// Porties die bij dit product horen. Eerst 1/2/3 van de echte eenheid
  /// (ei, snee, plak), daarna hooguit een paar passende huishoudmaten.
  /// Geen keukenla van snee/glas/kom bij een ei.
  static List<HouseholdPortion> suggestionsFor({
    String? name,
    String? category,
    double? servingG,
    String? servingLabel,
  }) {
    final liquid = looksLiquid(
      name: name,
      category: category,
      servingLabel: servingLabel,
    );
    final hay = '${name ?? ''} ${category ?? ''} ${servingLabel ?? ''}'
        .toLowerCase();
    final family = _familyOf(hay, liquid, servingLabel);
    final unit = _unitFor(
      hay: hay,
      family: family,
      servingG: servingG,
      servingLabel: servingLabel,
      liquid: liquid,
    );

    final picked = <HouseholdPortion>[];

    void add(HouseholdPortion portion) {
      if (portion.grams <= 0) return;
      if (picked.any((p) => (p.grams - portion.grams).abs() < 1)) return;
      picked.add(portion);
    }

    if ((servingLabel ?? '').trim().startsWith('1/2 ')) {
      final whole = unit.grams * 2;
      add(
        HouseholdPortion(
          label: unit.label,
          grams: whole * 0.5,
          count: 0.5,
          liquid: unit.liquid,
        ),
      );
      add(
        HouseholdPortion(
          label: unit.label,
          grams: whole,
          count: 1,
          liquid: unit.liquid,
        ),
      );
    } else {
      for (final count in _countsFor(unit.label, unit.grams, family)) {
        add(
          HouseholdPortion(
            label: unit.label,
            grams: unit.grams * count,
            count: count,
            liquid: unit.liquid,
          ),
        );
      }
    }

    for (final extra in _extrasFor(family, hay)) {
      if (extra.label == unit.label) continue;
      add(extra);
    }

    if (picked.length > 6) return picked.sublist(0, 6);
    return picked;
  }

  static _PortionFamily _familyOf(
    String hay,
    bool liquid,
    String? servingLabel,
  ) {
    final unit = _unitName(servingLabel)?.toLowerCase();
    if (const {'ei', 'eieren', 'dooier', 'eiwit', 'omelet'}
        .contains(unit)) {
      return _PortionFamily.egg;
    }
    if (_isEgg(hay)) return _PortionFamily.egg;
    if (_hasWord(hay, const ['soep', 'bouillon'])) {
      return _PortionFamily.soup;
    }
    if (_hasWord(hay, const ['reep', 'eiwitreep', 'candybar'])) {
      return _PortionFamily.snack;
    }
    if (liquid) return _PortionFamily.liquid;
    if (_hasWord(hay, const [
      'brood',
      'toast',
      'cracker',
      'beschuit',
      'croissant',
      'stokbrood',
      'pita',
      'ciabatta',
      'knackebrod',
    ])) {
      return _PortionFamily.bread;
    }
    if (_hasWord(hay, const ['kaas', 'smeerkaas', 'huttenkase'])) {
      return _PortionFamily.cheese;
    }
    if (_hasWord(hay, const [
      'olie',
      'saus',
      'jam',
      'honing',
      'pindakaas',
      'halvanaise',
      'mayonaise',
      'stroop',
      'pesto',
      'ketchup',
    ])) {
      return _PortionFamily.spread;
    }
    if (_hasWord(hay, const [
      'noot',
      'noten',
      'pinda',
      'chips',
      'popcorn',
      'zoutje',
      'zoutjes',
      'pitten',
      'zaden',
    ])) {
      return _PortionFamily.nuts;
    }
    if (_hasWord(hay, const [
          'yoghurt',
          'kwark',
          'vla',
          'pap',
          'skyr',
        ]) ||
        hay.contains('melkproducten')) {
      return _PortionFamily.dairy;
    }
    if (_hasWord(hay, const [
      'appel',
      'banaan',
      'peer',
      'kiwi',
      'sinaasappel',
      'mandarijn',
      'druif',
      'aardbei',
      'meloen',
      'watermeloen',
      'fruit',
    ])) {
      return _PortionFamily.fruit;
    }
    if (_hasWord(hay, const [
      'groente',
      'tomaat',
      'komkommer',
      'paprika',
      'sla',
      'spinazie',
      'broccoli',
    ])) {
      return _PortionFamily.veg;
    }
    if (_hasWord(hay, const [
      'soep',
      'bouillon',
    ])) {
      return _PortionFamily.soup;
    }
    if (_hasWord(hay, const [
      'vlees',
      'kip',
      'vis',
      'gehakt',
      'filet',
      'biefstuk',
    ])) {
      return _PortionFamily.meat;
    }
    if (_hasWord(hay, const [
      'koek',
      'koekje',
      'reep',
      'snoep',
      'chocolade',
      'nugget',
      'kroket',
      'frikandel',
    ])) {
      return _PortionFamily.snack;
    }
    if (_hasWord(hay, const [
      'pasta',
      'rijst',
      'couscous',
      'quinoa',
      'muesli',
      'havermout',
      'noodles',
    ])) {
      return _PortionFamily.grain;
    }
    if (_hasWord(hay, const [
      'kruiden',
      'specerijen',
      'sambal',
      'peper',
      'zout',
    ])) {
      return _PortionFamily.spice;
    }
    if (_hasWord(hay, const [
      'pizza',
      'stamppot',
      'nasi',
      'bami',
      'maaltijd',
      'schotel',
    ])) {
      return _PortionFamily.meal;
    }
    return _PortionFamily.other;
  }

  /// Heel ei, geen eiwitreep, eiersalade of "bami z ei".
  static bool _isEgg(String hay) {
    if (hay.contains('eiwitreep') ||
        hay.contains('eierkoek') ||
        hay.contains('eiwitpoeder')) {
      return false;
    }
    if (_hasWord(hay, const [
      'salade',
      'bami',
      'nasi',
      'stamppot',
      'curry',
      'schotel',
    ])) {
      return false;
    }
    if (hay.contains('eieren') ||
        hay.contains('eitje') ||
        hay.contains('eidooier') ||
        hay.contains('eipoeder') ||
        hay.contains('kippenei') ||
        hay.contains('spiegelei') ||
        hay.contains('roerei') ||
        hay.contains('omelet') ||
        hay.contains('scharrelei')) {
      return true;
    }
    if (_hasWord(hay, const ['ei', 'eier', 'egg', 'eggs'])) return true;
    if (RegExp(r'^ei(?:\s|-|$)').hasMatch(hay.trim())) return true;
    if (RegExp(r'(?:^|[^a-zà-ÿ])ei kip').hasMatch(hay)) return true;
    if (RegExp(r'(?:^|[^a-zà-ÿ])eiwit(?:[^a-zà-ÿ]|$)').hasMatch(hay)) {
      return true;
    }
    return false;
  }

  static _EggForm _eggForm(String hay) {
    if (hay.contains('omelet') || hay.contains('roerei')) {
      return _EggForm.omelet;
    }
    if (hay.contains('eipoeder') ||
        (hay.contains('poeder') && _hasWord(hay, const ['ei', 'eieren']))) {
      return _EggForm.powder;
    }
    if (hay.contains('dooier') || hay.contains('yolk')) return _EggForm.yolk;
    if (RegExp(r'(?:^|[^a-zà-ÿ])eiwit(?:[^a-zà-ÿ]|$)').hasMatch(hay) ||
        hay.contains('egg white')) {
      return _EggForm.white;
    }
    return _EggForm.whole;
  }

  static ({String label, double grams, bool liquid}) _unitFor({
    required String hay,
    required _PortionFamily family,
    double? servingG,
    String? servingLabel,
    required bool liquid,
  }) {
    var label = _unitName(servingLabel)?.toLowerCase();
    final hasServing = servingG != null && servingG > 0;

    if (family == _PortionFamily.egg) {
      final form = _eggForm(hay);
      final inferred = switch (form) {
        _EggForm.whole => (label: 'ei', grams: 50.0),
        _EggForm.yolk => (label: 'dooier', grams: 17.0),
        _EggForm.white => (label: 'eiwit', grams: 33.0),
        _EggForm.powder => (label: 'eetlepel', grams: 10.0),
        _EggForm.omelet => (label: 'omelet', grams: 120.0),
      };
      if (!hasServing) {
        return (label: inferred.label, grams: inferred.grams, liquid: false);
      }
      final generic = label == null ||
          label == 'portie' ||
          label == 'stuk';
      final staleMeal = form == _EggForm.omelet &&
          generic &&
          servingG >= 200;
      return (
        label: generic ? inferred.label : label,
        grams: staleMeal ? inferred.grams : servingG,
        liquid: false,
      );
    }

    if (hasServing) {
      return (
        label: label ?? 'portie',
        grams: servingG,
        liquid: liquid || _liquidUnits.contains(label),
      );
    }

    return switch (family) {
      _PortionFamily.liquid => (label: 'glas', grams: 200.0, liquid: true),
      _PortionFamily.bread => (label: 'snee', grams: 35.0, liquid: false),
      _PortionFamily.cheese => (label: 'plak', grams: 20.0, liquid: false),
      _PortionFamily.spread => (label: 'eetlepel', grams: 15.0, liquid: false),
      _PortionFamily.nuts => (label: 'handje', grams: 25.0, liquid: false),
      _PortionFamily.dairy => (label: 'schaaltje', grams: 150.0, liquid: false),
      _PortionFamily.fruit => (label: 'stuk', grams: 120.0, liquid: false),
      _PortionFamily.veg => (label: 'opscheplepel', grams: 50.0, liquid: false),
      _PortionFamily.meat => (label: 'portie', grams: 100.0, liquid: false),
      _PortionFamily.soup => (label: 'kom', grams: 250.0, liquid: false),
      _PortionFamily.snack => (label: 'stuk', grams: 25.0, liquid: false),
      _PortionFamily.grain => (label: 'opscheplepel', grams: 50.0, liquid: false),
      _PortionFamily.spice => (label: 'theelepel', grams: 2.0, liquid: false),
      _PortionFamily.meal => (label: 'portie', grams: 250.0, liquid: false),
      _PortionFamily.other => (
          label: 'portie',
          grams: liquid ? 200.0 : 100.0,
          liquid: liquid,
        ),
      _PortionFamily.egg => (label: 'ei', grams: 50.0, liquid: false),
    };
  }

  static List<double> _countsFor(
    String label,
    double unitGrams,
    _PortionFamily family,
  ) {
    final eggPiece = family == _PortionFamily.egg &&
        const {'ei', 'eieren', 'dooier', 'eiwit'}.contains(label);
    if (eggPiece) return const [1, 2, 3];

    final countable = _countableUnits.contains(label);
    if (!countable) {
      if (unitGrams >= 80) return const [1, 0.5];
      return const [1];
    }

    final counts = <double>[1];
    if (unitGrams >= 80) counts.add(0.5);
    if (unitGrams * 2 <= 450) counts.add(2);
    if (unitGrams <= 60 && unitGrams * 3 <= 200) counts.add(3);
    return counts;
  }

  static List<HouseholdPortion> _extrasFor(
    _PortionFamily family,
    String hay,
  ) {
    return switch (family) {
      _PortionFamily.egg => _isPlainOmelet(hay)
          ? const [
              HouseholdPortion(label: 'ei', grams: 50),
              HouseholdPortion(label: 'ei', grams: 100, count: 2),
            ]
          : const [],
      _PortionFamily.liquid => const [
          HouseholdPortion(label: 'kop', grams: 125, liquid: true),
          HouseholdPortion(label: 'glas', grams: 200, liquid: true),
          HouseholdPortion(label: 'eetlepel', grams: 15, liquid: true),
        ],
      _PortionFamily.bread => const [
          HouseholdPortion(label: 'snee', grams: 35),
        ],
      _PortionFamily.cheese => const [
          HouseholdPortion(label: 'plak', grams: 20),
          HouseholdPortion(label: 'eetlepel', grams: 15),
        ],
      _PortionFamily.spread => const [
          HouseholdPortion(label: 'eetlepel', grams: 15),
          HouseholdPortion(label: 'theelepel', grams: 5),
        ],
      _PortionFamily.nuts => const [
          HouseholdPortion(label: 'handje', grams: 25),
          HouseholdPortion(label: 'eetlepel', grams: 10),
        ],
      _PortionFamily.dairy => const [
          HouseholdPortion(label: 'schaaltje', grams: 150),
          HouseholdPortion(label: 'eetlepel', grams: 15),
        ],
      _PortionFamily.fruit => _hasWord(hay, const [
          'bes',
          'bessen',
          'aardbei',
          'aardbeien',
          'druif',
          'druiven',
          'kers',
          'kersen',
          'framboos',
          'frambozen',
        ])
          ? const [HouseholdPortion(label: 'schaaltje', grams: 100)]
          : const [],
      _PortionFamily.veg => const [
          HouseholdPortion(label: 'opscheplepel', grams: 50),
        ],
      _PortionFamily.soup => const [
          HouseholdPortion(label: 'kom', grams: 250),
        ],
      _PortionFamily.grain => const [
          HouseholdPortion(label: 'opscheplepel', grams: 50),
          HouseholdPortion(label: 'eetlepel', grams: 15),
        ],
      _PortionFamily.spice => const [
          HouseholdPortion(label: 'theelepel', grams: 2),
          HouseholdPortion(label: 'eetlepel', grams: 5),
        ],
      _PortionFamily.snack => const [],
      _PortionFamily.meat ||
      _PortionFamily.meal ||
      _PortionFamily.other =>
        const [],
    };
  }

  static bool _isPlainOmelet(String hay) {
    if (!hay.contains('omelet') && !hay.contains('roerei')) return false;
    return !_hasWord(hay, const [
      'ham',
      'kaas',
      'spek',
      'aardappel',
      'groente',
      'tortilla',
    ]);
  }

  static String? _unitName(String? raw) {
    var label = (raw ?? '').trim();
    if (label.isEmpty) return null;
    if (label.startsWith('1/2 ')) return label.substring(4).trim();
    if (label.startsWith('1 ')) return label.substring(2).trim();
    return label;
  }

  static String _pluralOf(String label) => _plurals[label] ?? label;

  static bool _hasWord(String hay, List<String> words) {
    for (final word in words) {
      if (RegExp(
        '(?:^|[^a-zà-ÿ])${RegExp.escape(word)}(?:[^a-zà-ÿ]|\$)',
      ).hasMatch(hay)) {
        return true;
      }
    }
    return false;
  }
}

const _plurals = {
  'ei': 'eieren',
  'glas': 'glazen',
  'plak': 'plakken',
  'portie': 'porties',
  'stuk': 'stuks',
  'kop': 'koppen',
  'kom': 'kommen',
  'eetlepel': 'eetlepels',
  'theelepel': 'theelepels',
  'opscheplepel': 'opscheplepels',
  'handje': 'handjes',
  'bakje': 'bakjes',
  'schaaltje': 'schaaltjes',
  'bord': 'borden',
  'blikje': 'blikjes',
  'blik': 'blikken',
  'fles': 'flessen',
  'reep': 'repen',
  'bolletje': 'bolletjes',
  'punt': 'punten',
  'snee': 'sneetjes',
  'filet': 'filets',
  'omelet': 'omeletten',
  'pizza': "pizza's",
  'potje': 'potjes',
  'stokje': 'stokjes',
  'glaasje': 'glaasjes',
  'scheut': 'scheuten',
  'blokje': 'blokjes',
  'trosje': 'trosjes',
  'dooier': 'dooiers',
  'eiwit': 'eiwitten',
};

const _countableUnits = {
  'ei',
  'eieren',
  'snee',
  'stuk',
  'plak',
  'eetlepel',
  'theelepel',
  'handje',
  'reep',
  'bolletje',
  'punt',
  'filet',
  'stokje',
  'blikje',
  'blik',
  'potje',
  'pizza',
  'omelet',
  'glas',
  'kop',
  'kom',
  'bakje',
  'schaaltje',
  'opscheplepel',
  'fles',
  'glaasje',
  'scheut',
  'blokje',
  'trosje',
  'dooier',
  'eiwit',
  'beschuit',
  'cracker',
};

const _liquidUnits = {
  'glas',
  'kop',
  'blikje',
  'fles',
  'glaasje',
  'kom',
  'eetlepel',
  'theelepel',
  'scheut',
};
