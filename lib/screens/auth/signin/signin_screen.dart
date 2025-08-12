import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/keyboard_visibility_builder.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_textfield.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';

import '../../../managers/fcm_manager.dart';
part 'signin_components.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool get canProceed =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _passwordController.text.length >= 6;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          image: PlatformC().isCurrentDesignPlatformDesktop
              ? DecorationImage(
                  image: AssetImage(AppImages.webStaticPage.path),
                  fit: BoxFit.fitWidth,
                )
              : null,
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: PlatformC().isCurrentDesignPlatformDesktop
                ? Colors.transparent
                : AppColors.lightPink,
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  height: height,
                  color: AppColors.lightPink,
                  margin: EdgeInsets.symmetric(
                      vertical:
                          PlatformC().isCurrentDesignPlatformDesktop ? 30 : 0),
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  constraints: kComponentWidthConstraint,
                  child: Form(
                    key: _formKey,
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: 34.5.h),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                AppImages.arrowBack.path,
                                height: 24.h,
                              ),
                            ),
                          ),
                          Text(
                            "SIGN_IN".tr(context),
                            style: AppTextStyles.panchangBold26,
                          ),
                          Text(
                            '${"WELCOME_BACK".tr(context)}!',
                            style: AppTextStyles.panchangMedium13,
                          ),
                          SizedBox(height: 45.h),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "EMAIL".tr(context),
                                    style: AppTextStyles.panchangMedium14,
                                  ),
                                  CustomTextField(
                                    controller: _emailController,
                                    node: _emailNode,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (!(value?.isValidEmail ?? true)) {
                                        return "PLEASE_ENTER_VALID_".tr(
                                          context,
                                          params: {'FIELD': "EMAIL"},
                                        );
                                      }
                                      return null;
                                    },
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(height: 54.h),
                                  Text(
                                    "PASSWORD".tr(context),
                                    style: AppTextStyles.panchangMedium14,
                                  ),
                                  CustomTextField(
                                    controller: _passwordController,
                                    node: _passNode,
                                    validator: (val) {
                                      if ((val?.isEmpty ?? true) ||
                                          (val?.length ?? 0) < 6) {
                                        return "PASSWORD_MUST_BE_".tr(context);
                                      }
                                      return null;
                                    },
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    obscureText: true,
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _forgotPasswordDialog(context, ref);
                                      },
                                      child: Text(
                                        "FORGOT_MY_PASSWORD".tr(context),
                                        style: AppTextStyles.helveticaLight13
                                            .copyWith(
                                          color: AppColors.darkGreen70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          MainButton(
                            enabled: canProceed,
                            label: FlutterI18n.translate(context, "SIGN_IN")
                                .capitalizeFirst,
                            showArrow: true,
                            onTap: () async {
                              if (!(_formKey.currentState?.validate() ??
                                  true)) {
                                return;
                              }
                              final provider = loginUserProvider(
                                  _emailController.text.trim(),
                                  _passwordController.text);
                              final AppUser? data =
                                  await Utils.showLoadingDialog<AppUser>(
                                context,
                                provider,
                                ref,
                              );

                              if (data != null && context.mounted) {
                                if (FcmManager().token.isNotEmpty) {
                                  ref.watch(
                                      saveFCMTokenProvider(FcmManager().token));
                                }
                                ref.watch(getCourtBookingProvider);
                                ref.read(pageIndexProvider.notifier).index = 1;
                                ref.refresh(pageControllerProvider);
                                ref.read(goRouterProvider).go(RouteNames.home);
                              }
                            },
                          ),
                          SizedBox(height: 82.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
