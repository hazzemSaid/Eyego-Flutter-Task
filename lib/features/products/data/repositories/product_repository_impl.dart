import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../datasources/product_remote_datasource.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remote);

  final ProductRemoteDataSource _remote;

  @override
  Future<Either<AuthFailure, List<Product>>> getProducts({
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final products = await _remote.getProducts(limit: limit, skip: skip);
      return Right(products);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, List<Product>>> searchProducts(
    String query,
  ) async {
    try {
      final products = await _remote.searchProducts(query);
      return Right(products);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, List<String>>> getCategories() async {
    try {
      final categories = await _remote.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final products = await _remote.getProductsByCategory(category);
      return Right(products);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }
}
