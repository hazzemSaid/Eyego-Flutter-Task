import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/auth_background.dart';
import '../../../../core/widgets/eye_orb_logo.dart';
import '../../domain/repositories/auth_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), _leave);
  }

  void _leave() {
    if (!mounted) return;
    final user = sl<AuthRepository>().currentUser;
    final loggedIn = user != null && user.isNotEmpty;
    context.go(loggedIn ? RouteNames.home : RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EyeOrbLogo(size: AppDimens.orbSizeLg),
              const SizedBox(height: AppDimens.lg),
              const EyegoWordmark(),
              const SizedBox(height: AppDimens.xl),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Text(
                AppStrings.splashLoading,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
