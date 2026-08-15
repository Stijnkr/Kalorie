import 'package:isar_community/isar.dart';

import '../repositories/catalog_repository.dart';
import '../repositories/food_repository.dart';

/// Loads the bundled NEVO snapshot into Isar. Prefer [CatalogRepository].
class NevoImporter {
  static const assetPath = CatalogRepository.snapshotAsset;
  static const version = '2025/9.0+catalog.1';

  static Future<void> importIfNeeded(Isar isar) {
    return CatalogRepository(
      isar,
      FoodRepository(isar),
    ).importSnapshotIfNeeded();
  }
}
