import 'package:openfoodfacts/openfoodfacts.dart';

import '../../core/constants.dart';
import 'rate_limiter.dart';

void configureOffClient() {
  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: OffConfig.appName,
    version: OffConfig.appVersion,
    system: 'Flutter',
    comment: OffConfig.userAgent,
  );
  OpenFoodAPIConfiguration.globalLanguages = [OpenFoodFactsLanguage.DUTCH];
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.NETHERLANDS;
}

class OffRemoteDataSource {
  OffRemoteDataSource({
    RateLimiter? searchLimiter,
    RateLimiter? productLimiter,
  }) : _searchLimiter = searchLimiter ?? RateLimiter(maxPerMinute: 10),
       _productLimiter = productLimiter ?? RateLimiter(maxPerMinute: 15);

  final RateLimiter _searchLimiter;
  final RateLimiter _productLimiter;

  static const _fields = [
    ProductField.BARCODE,
    ProductField.NAME,
    ProductField.BRANDS,
    ProductField.NUTRIMENTS,
    ProductField.SERVING_SIZE,
    ProductField.SERVING_QUANTITY,
  ];

  Future<Product?> getByBarcode(String barcode) async {
    if (!_productLimiter.tryAcquire()) {
      throw RateLimitedException();
    }
    final config = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.DUTCH,
      country: OpenFoodFactsCountry.NETHERLANDS,
      fields: _fields,
      version: ProductQueryVersion.v3,
    );
    final result = await OpenFoodAPIClient.getProductV3(config);
    if (result.status == ProductResultV3.statusSuccess) {
      return result.product;
    }
    return null;
  }

  Future<List<Product>> search(String terms) async {
    if (!_searchLimiter.tryAcquire()) {
      throw RateLimitedException();
    }
    final config = ProductSearchQueryConfiguration(
      language: OpenFoodFactsLanguage.DUTCH,
      country: OpenFoodFactsCountry.NETHERLANDS,
      fields: _fields,
      parametersList: [
        SearchTerms(terms: terms.split(RegExp(r'\s+'))),
        PageSize(size: 20),
      ],
      version: ProductQueryVersion.v3,
    );
    final result = await OpenFoodAPIClient.searchProducts(null, config);
    return result.products ?? const [];
  }
}
