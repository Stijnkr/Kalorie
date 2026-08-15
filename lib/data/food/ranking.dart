import 'dart:math' as math;

import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import 'match_key.dart';

/// Device recents/favorites first, then text match, source, catalog scores.
int compareFoodSearch(Food a, Food b, String query) {
  final q = MatchKey.normalizeSearch(query);
  final aUsed = a.lastUsedAt;
  final bUsed = b.lastUsedAt;
  if (aUsed != null && bUsed == null) return -1;
  if (aUsed == null && bUsed != null) return 1;
  if (aUsed != null && bUsed != null) {
    final byTime = bUsed.compareTo(aUsed);
    if (byTime != 0) return byTime;
  }
  if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;

  final aText = textMatch(a, q);
  final bText = textMatch(b, q);
  final byText = bText.compareTo(aText);
  if (byText != 0) return byText;

  final source = _sourceRank(a.source) - _sourceRank(b.source);
  if (source != 0) return source;

  final byCatalog = catalogScore(b, q).compareTo(catalogScore(a, q));
  if (byCatalog != 0) return byCatalog;
  // Korte naam = minder bijzinnen = het basisproduct ("Melk volle" boven
  // "Melk chocolade- automaat"). Zelfde tiebreak als de search-RPC.
  final byLength = a.name.length.compareTo(b.name.length);
  if (byLength != 0) return byLength;
  return a.name.toLowerCase().compareTo(b.name.toLowerCase());
}

double catalogScore(Food food, String query) {
  final q = MatchKey.normalizeSearch(query);
  final genericBoost =
      q.length <= 12 && food.kind == FoodKind.generic ? 1.0 : 0.0;
  return 0.40 * textMatch(food, q) +
      0.25 * _logNorm(food.popularity) +
      0.15 * (food.qualityScore / 100) +
      0.12 * (food.nlRelevance / 100) +
      0.08 * genericBoost;
}

/// Zelfde tiers als `search_products` in supabase/migrations/006 — cloud en
/// lokaal horen dezelfde volgorde te geven.
double textMatch(Food food, String q) {
  if (q.isEmpty) return 0;
  final name = food.nameNormalized;
  if (name == q) return 1;
  // Heel woord vooraan ("ei kippen-" op "ei") gaat voor een prefix midden in
  // een woord ("eipoeder"), anders wint het eerste het alfabet.
  if (name.startsWith('$q ')) return 0.95;
  if (name.contains(' $q ') || name.endsWith(' $q')) return 0.8;
  if (name.startsWith(q)) return 0.6;
  if (name.split(' ').any((t) => t.startsWith(q))) return 0.5;
  if (name.contains(q)) return 0.4;
  // NEVO-namen staan omgekeerd ("Kwark magere"), dus ook los-woord matchen.
  final queryTokens = q.split(' ').where((t) => t.isNotEmpty).toList();
  if (queryTokens.length > 1) {
    final nameTokens = name.split(' ');
    final hits = queryTokens
        .where((t) => nameTokens.any((n) => n.startsWith(t)))
        .length;
    if (hits == queryTokens.length) return 0.6;
    if (hits > 0) return 0.3 * hits / queryTokens.length;
  }
  final brand = food.brand?.toLowerCase() ?? '';
  if (brand.contains(q)) return 0.3;
  return 0;
}

double _logNorm(int popularity) {
  if (popularity <= 0) return 0;
  return math.log(1 + popularity) / math.log(10001);
}

int _sourceRank(FoodSource source) => switch (source) {
      FoodSource.custom => 0,
      FoodSource.nevo => 1,
      FoodSource.off => 2,
    };
