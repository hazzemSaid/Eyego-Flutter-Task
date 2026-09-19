import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';
import '../widgets/full_screen_image_viewer.dart';
import '../widgets/product_detail_header.dart';
import '../widgets/product_detail_images.dart';
import '../widgets/product_detail_info.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  void _openImage(BuildContext context, int index) {
    final images = [product.thumbnail, ...product.images];
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) =>
            FullScreenImageViewer(image: images[0], initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ProductDetailHeader(
              product: product,
              onImageTap: () => _openImage(context, 0),
            ),
            SliverToBoxAdapter(child: ProductDetailInfo(product: product)),
            if (product.images.length > 1)
              SliverToBoxAdapter(
                child: ProductDetailImages(
                  product: product,
                  onImageTap: (index) => _openImage(context, index + 1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
