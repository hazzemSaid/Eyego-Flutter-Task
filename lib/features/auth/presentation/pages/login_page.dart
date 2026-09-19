import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/auth_background.dart';
import '../../../../core/widgets/eye_orb_logo.dart';
import '../../../../core/widgets/eyego_primary_button.dart';
import '../../../../core/widgets/eyego_text_field.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(AuthCubit cubit) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    cubit.loginEmail(email: _email.text.trim(), password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              context.read<AuthCubit>().clearError();
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            return SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.lg,
                  vertical: AppDimens.md,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppDimens.maxFormWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppDimens.md),
                        const Center(
                          child: EyeOrbLogo(size: AppDimens.orbSizeMd),
                        ),
                        const SizedBox(height: AppDimens.sm),
                        const Center(child: EyegoWordmark(tagline: false)),
                        const SizedBox(height: AppDimens.lg),
                        Text(
                          AppStrings.welcomeBack,
                          style: AppTextStyles.headline(),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.loginSubtitle,
                          style: AppTextStyles.body(),
                        ),
                        const SizedBox(height: AppDimens.lg),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              EyegoTextField(
                                controller: _email,
                                label: AppStrings.emailLabel,
                                hint: AppStrings.emailHint,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: Validators.email,
                                prefixIcon: const Icon(
                                  Icons.alternate_email_rounded,
                                  color: AppColors.gray500,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: AppDimens.md),
                              EyegoTextField(
                                controller: _password,
                                label: AppStrings.passwordLabel,
                                hint: AppStrings.passwordHint,
                                obscureText: _obscure,
                                textInputAction: TextInputAction.done,
                                validator: Validators.password,
                                onSubmitted: (_) => _submit(cubit),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: AppColors.gray500,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.gray500,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.lg),
                        EyegoPrimaryButton(
                          label: AppStrings.loginCta,
                          isLoading: state.isLoading,
                          onPressed: state.isLoading || state.isGoogleLoading
                              ? null
                              : () => _submit(cubit),
                        ),
                        const SizedBox(height: AppDimens.md),
                        _divider(),
                        const SizedBox(height: AppDimens.md),
                        GoogleSignInButton(
                          label: AppStrings.googleCta,
                          isLoading: state.isGoogleLoading,
                          onPressed: state.isLoading || state.isGoogleLoading
                              ? null
                              : () => cubit.loginGoogle(),
                        ),
                        const SizedBox(height: AppDimens.lg),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                AppStrings.noAccount,
                                style: AppTextStyles.bodySmall(),
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.go(RouteNames.register),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  AppStrings.signUpLink,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.lg),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.gray800)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
          child: Text(
            AppStrings.orContinueWith,
            style: AppTextStyles.caption(),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.gray800)),
      ],
    );
  }
}
