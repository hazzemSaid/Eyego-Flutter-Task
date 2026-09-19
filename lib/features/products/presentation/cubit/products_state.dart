import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

enum ProductsStatus { initial, loading, loaded, error }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;
  final bool hasMore;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategory = '',
    this.searchQuery = '',
    this.errorMessage,
    this.hasMore = true,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    String? Function()? errorMessage,
    bool? hasMore,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        categories,
        selectedCategory,
        searchQuery,
        errorMessage,
        hasMore,
      ];
}
