import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: AppTextStyles.headline(color: AppColors.white),
                ),
              ),
              const Icon(
                Icons.star_rounded,
                size: 20,
                color: AppColors.gray400,
              ),
              const SizedBox(width: 4),
              Text(
                product.rating.toStringAsFixed(1),
                style: AppTextStyles.body(color: AppColors.gray400),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.brand,
            style: AppTextStyles.body(color: AppColors.gray500),
          ),
          const SizedBox(height: 4),
          Text(
            product.category.toUpperCase(),
            style: AppTextStyles.caption(color: AppColors.gray600),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '\$${product.discountedPrice.toStringAsFixed(2)}',
                style: AppTextStyles.headline(color: AppColors.white),
              ),
              if (product.discountPercentage > 0) ...[
                const SizedBox(width: 12),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${product.stock} in stock',
            style: AppTextStyles.bodySmall(
              color:
                  product.stock > 0 ? AppColors.gray400 : AppColors.gray600,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.gray800),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: AppTextStyles.title(color: AppColors.gray300),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: AppTextStyles.body(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}
