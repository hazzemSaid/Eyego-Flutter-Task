import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  Future<Either<AuthFailure, List<Product>>> call({
    int limit = 30,
    int skip = 0,
  }) {
    return _repository.getProducts(limit: limit, skip: skip);
  }
}
