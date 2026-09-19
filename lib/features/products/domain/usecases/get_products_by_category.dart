import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategory {
  const GetProductsByCategory(this._repository);

  final ProductRepository _repository;

  Future<Either<AuthFailure, List<Product>>> call(String category) {
    return _repository.getProductsByCategory(category);
  }
}
