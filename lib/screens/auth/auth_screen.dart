import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/auth/auth_responseive.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final clubLocations = ref.watch(clubLocationsProvider);
    return AuthResponsive(
      child: Scaffold(
        backgroundColor: PlatformC().isCurrentDesignPlatformDesktop
            ? Colors.transparent
            : Colors.white,
        body: clubLocations.when(
          data: (data) {
            if (data == null) {
              return const Center(
                child: SecondaryText(text: "Unable to get Locations."),
              );
            }
            Future(() {
              ref.read(selectedSportProvider.notifier).sport ??=
                  Utils.fetchSportsList(data).first;
            });
            return _Body();
          },
          loading: () => const _Body(),
          error: (e, _) => Center(child: SecondaryText(text: e.toString())),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AbsorbPointer(
      absorbing: ref.watch(clubLocationsProvider).isLoading,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: PlatformC().isCurrentDesignPlatformDesktop ? 30 : 0,
          ),
          // color: AppColors.lightPink,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.splashLogoBg.path),
              )),
          child: ConstrainedBox(
            constraints: kComponentWidthConstraint,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(height: 80.h),
                Image.asset(
                  AppImages.splashLogo.path,
                  width: double.infinity,
                  height: 390.h,
                ),
                const Spacer(),
                MainButton(
                  label: FlutterI18n.translate(context, "SIGN_IN").toUpperCase(),
                  showArrow: true,
                  // height: 40.h,
                  onTap: () {
                    ref.read(goRouterProvider).push(RouteNames.signIn);
                  },
                ),
                SizedBox(height: 22.h),
                MainButton(
                  color: AppColors.darkBlue50,
                  label: FlutterI18n.translate(context, "REGISTER"),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  labelStyle: AppTextStyles.sansRegular18
                      .copyWith(color: AppColors.white,),
                  showArrow: true,
                  // height: 40.h,
                  onTap: () {
                    ref.read(goRouterProvider).push(RouteNames.signUp);
                  },
                ),
                SizedBox(height: 88.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
