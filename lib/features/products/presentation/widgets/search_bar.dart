import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(color: AppColors.gray600),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.gray500,
          ),
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.gray500,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: AppColors.gray900,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            borderSide: const BorderSide(color: AppColors.gray800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            borderSide: const BorderSide(color: AppColors.white, width: 1.4),
          ),
        ),
      ),
    );
  }
}
