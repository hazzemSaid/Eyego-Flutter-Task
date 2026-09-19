import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';

class ProductDetailImages extends StatelessWidget {
  const ProductDetailImages({
    super.key,
    required this.product,
    required this.onImageTap,
  });

  final Product product;
  final void Function(int index) onImageTap;

  @override
  Widget build(BuildContext context) {
    if (product.images.length <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.gray800),
          const SizedBox(height: 16),
          Text(
            'More Images',
            style: AppTextStyles.title(color: AppColors.gray300),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onImageTap(index + 1),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusSm),
                    child: CachedNetworkImage(
                      imageUrl: product.images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        color: AppColors.gray800,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: AppColors.gray800,
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
