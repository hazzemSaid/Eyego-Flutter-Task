import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  const SearchProducts(this._repository);

  final ProductRepository _repository;

  Future<Either<AuthFailure, List<Product>>> call(String query) {
    return _repository.searchProducts(query);
  }
}
