import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<AuthFailure, List<Product>>> getProducts({
    int limit = 30,
    int skip = 0,
  });

  Future<Either<AuthFailure, List<Product>>> searchProducts(String query);

  Future<Either<AuthFailure, List<String>>> getCategories();

  Future<Either<AuthFailure, List<Product>>> getProductsByCategory(
    String category,
  );
}
