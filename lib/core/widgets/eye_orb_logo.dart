import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class EyeOrbLogo extends StatelessWidget {
  const EyeOrbLogo({super.key, this.size = AppDimens.orbSizeMd});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: Center(
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EyegoWordmark extends StatelessWidget {
  const EyegoWordmark({super.key, this.tagline = true});

  final bool tagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: const TextSpan(
            style: AppTextStyles.logoMark,
            children: [
              TextSpan(text: 'Eye'),
              TextSpan(
                text: 'Go',
                style: TextStyle(color: AppColors.gray400),
              ),
            ],
          ),
        ),
        if (tagline)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'See the world clearly',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 13,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
