import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../food/catalog_product.dart';

class CatalogClient {
  CatalogClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  bool get isConfigured => CatalogConfig.isConfigured;

  Future<List<CatalogProduct>> search(String query, {int limit = 30}) async {
    if (!isConfigured || query.trim().isEmpty) return <CatalogProduct>[];
    final rows = await _rpc('search_products', {
      'q': query.trim(),
      'lim': limit,
    });
    return [for (final row in rows) CatalogProduct.fromJson(row)];
  }

  Future<CatalogProduct?> getByBarcode(String barcode) async {
    if (!isConfigured || barcode.trim().isEmpty) return null;
    final rows = await _rpc('get_product_by_barcode', {'code': barcode.trim()});
    if (rows.isEmpty) return null;
    return CatalogProduct.fromJson(rows.first);
  }

  Future<List<CatalogProduct>> productsSince(int version, {int limit = 500}) async {
    if (!isConfigured) return const [];
    final rows = await _rpc('products_since', {
      'since_version': version,
      'lim': limit,
    });
    return [for (final row in rows) CatalogProduct.fromJson(row)];
  }

  Uri _https(String url) {
    final uri = Uri.parse(url);
    if (uri.scheme != 'https') {
      throw CatalogException('https verplicht');
    }
    return uri;
  }

  Future<int> catalogVersion() async {
    if (!isConfigured) return 0;
    final uri = _https(
      '${CatalogConfig.supabaseUrl}/rest/v1/catalog_meta?id=eq.1&select=version',
    );
    final response = await _http.get(uri, headers: _headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CatalogException('catalog_meta ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is List && decoded.isNotEmpty) {
      return (decoded.first['version'] as num?)?.toInt() ?? 0;
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> _rpc(
    String name,
    Map<String, Object?> body,
  ) async {
    final uri = _https('${CatalogConfig.supabaseUrl}/rest/v1/rpc/$name');
    final response = await _http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CatalogException('$name ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) return const [];
    return [
      for (final row in decoded)
        if (row is Map<String, dynamic>) row,
    ];
  }

  Map<String, String> get _headers => {
        'apikey': CatalogConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${CatalogConfig.supabaseAnonKey}',
        'Content-Type': 'application/json',
      };
}

class CatalogException implements Exception {
  CatalogException(this.message);
  final String message;

  @override
  String toString() => 'CatalogException: $message';
}
