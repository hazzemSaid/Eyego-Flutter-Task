import 'package:dio/dio.dart';

import '../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;
  static const _baseUrl = 'https://dummyjson.com';

  @override
  Future<List<Product>> getProducts({int limit = 30, int skip = 0}) async {
    final response = await _dio.get(
      '$_baseUrl/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    final data = response.data['products'] as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await _dio.get(
      '$_baseUrl/products/search',
      queryParameters: {'q': query},
    );
    final data = response.data['products'] as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await _dio.get('$_baseUrl/products/category-list');
    final data = response.data as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _dio.get(
      '$_baseUrl/products/category/$category',
    );
    final data = response.data['products'] as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .map((e) => e.toEntity())
        .toList();
  }
}
