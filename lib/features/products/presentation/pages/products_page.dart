import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/search_bar.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  Timer? _debounce;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    _scrollController.addListener(_onScroll);
    context.read<ProductsCubit>().loadInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductsCubit>().loadMore();
    }
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProductsCubit>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.lg,
                AppDimens.lg,
                AppDimens.lg,
                AppDimens.md,
              ),
            ),
            ProductsSearchBar(
              onChanged: _onSearch,
              onClear: () {
                context.read<ProductsCubit>().search('');
              },
            ),
            const SizedBox(height: AppDimens.md),
            BlocBuilder<ProductsCubit, ProductsState>(
              buildWhen: (prev, curr) =>
                  prev.categories != curr.categories ||
                  prev.selectedCategory != curr.selectedCategory,
              builder: (context, state) {
                if (state.categories.isEmpty) return const SizedBox.shrink();
                return CategoryChips(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: (category) {
                    context.read<ProductsCubit>().filterByCategory(category);
                  },
                );
              },
            ),
            const SizedBox(height: AppDimens.md),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                buildWhen: (prev, curr) =>
                    prev.status != curr.status ||
                    prev.products != curr.products,
                builder: (context, state) {
                  if (state.status == ProductsStatus.initial ||
                      (state.status == ProductsStatus.loading &&
                          state.products.isEmpty)) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (state.status == ProductsStatus.error &&
                      state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.gray600,
                            size: 48,
                          ),
                          const SizedBox(height: AppDimens.md),
                          Text(
                            state.errorMessage ?? 'Something went wrong',
                            style: AppTextStyles.body(color: AppColors.gray500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimens.lg),
                          TextButton(
                            onPressed: () =>
                                context.read<ProductsCubit>().loadInitial(),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildProductGrid(state),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductsState state) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return RefreshIndicator(
      color: AppColors.white,
      backgroundColor: AppColors.gray900,
      onRefresh: () async {
        context.read<ProductsCubit>().loadInitial();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppDimens.sm,
                crossAxisSpacing: AppDimens.sm,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: ProductCard(product: state.products[index]),
                );
              }, childCount: state.products.length),
            ),
          ),
          if (state.status == ProductsStatus.loading &&
              state.products.isNotEmpty)
            const SliverPadding(
              padding: EdgeInsets.all(AppDimens.lg),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppDimens.xl)),
        ],
      ),
    );
  }
}
