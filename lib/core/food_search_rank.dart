import '../data/local/collections/enums.dart';
import '../data/local/collections/food.dart';

int compareFoodSearch(Food a, Food b, String query) {
  final q = query.trim().toLowerCase();
  final aUsed = a.lastUsedAt;
  final bUsed = b.lastUsedAt;
  if (aUsed != null && bUsed == null) return -1;
  if (aUsed == null && bUsed != null) return 1;
  if (aUsed != null && bUsed != null) {
    final byTime = bUsed.compareTo(aUsed);
    if (byTime != 0) return byTime;
  }
  if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
  final aStart = a.nameNormalized.startsWith(q);
  final bStart = b.nameNormalized.startsWith(q);
  if (aStart != bStart) return aStart ? -1 : 1;
  final source = _sourceRank(a.source) - _sourceRank(b.source);
  if (source != 0) return source;
  return a.name.toLowerCase().compareTo(b.name.toLowerCase());
}

int _sourceRank(FoodSource source) => switch (source) {
      FoodSource.custom => 0,
      FoodSource.nevo => 1,
      FoodSource.off => 2,
    };
