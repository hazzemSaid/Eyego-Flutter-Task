import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/product_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final ProductRepository _repository;

  Future<Either<AuthFailure, List<String>>> call() {
    return _repository.getCategories();
  }
}
