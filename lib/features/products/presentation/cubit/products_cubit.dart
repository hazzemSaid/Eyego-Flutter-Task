import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products_by_category.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({
    required GetProducts getProducts,
    required SearchProducts searchProducts,
    required GetCategories getCategories,
    required GetProductsByCategory getProductsByCategory,
  })  : _getProducts = getProducts,
        _searchProducts = searchProducts,
        _getCategories = getCategories,
        _getProductsByCategory = getProductsByCategory,
        super(const ProductsState());

  final GetProducts _getProducts;
  final SearchProducts _searchProducts;
  final GetCategories _getCategories;
  final GetProductsByCategory _getProductsByCategory;

  int _skip = 0;
  static const _limit = 30;

  Future<void> loadInitial() async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final categoriesResult = await _getCategories();
    categoriesResult.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        errorMessage: () => failure.message,
      )),
      (categories) async {
        emit(state.copyWith(categories: categories));
        await _loadProducts();
      },
    );
  }

  Future<void> _loadProducts() async {
    final result = await _getProducts(limit: _limit, skip: _skip);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: () => failure.message,
      )),
      (products) {
        final all = [...state.products, ...products];
        emit(state.copyWith(
          status: ProductsStatus.loaded,
          products: all,
          hasMore: products.length == _limit,
        ));
        _skip += products.length;
      },
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == ProductsStatus.loading) return;
    emit(state.copyWith(status: ProductsStatus.loading));
    await _loadProducts();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _skip = 0;
      emit(state.copyWith(
        searchQuery: '',
        products: [],
        status: ProductsStatus.initial,
      ));
      await loadInitial();
      return;
    }

    emit(state.copyWith(
      status: ProductsStatus.loading,
      searchQuery: query,
      selectedCategory: '',
    ));

    final result = await _searchProducts(query);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: () => failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        products: products,
        hasMore: false,
      )),
    );
  }

  Future<void> filterByCategory(String category) async {
    if (category == state.selectedCategory) return;

    _skip = 0;
    emit(state.copyWith(
      status: ProductsStatus.loading,
      selectedCategory: category,
      searchQuery: '',
      products: [],
    ));

    if (category.isEmpty) {
      await loadInitial();
      return;
    }

    final result = await _getProductsByCategory(category);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: () => failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        products: products,
        hasMore: false,
      )),
    );
  }
}
