import 'package:acepadel/app_styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../managers/user_manager.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';
import '../home_screen/tabs/profile_tab/profile_tab.dart';

class WebHeader extends ConsumerWidget {
  const WebHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              AppImages.logo.path,
              width: 80.w,
              height: 80.h,
            ),
            Text("Rivera Padel",style: AppTextStyles.balooBold26),
            const Spacer(),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 18.w),
              child:  SecondaryButton(
                applyShadow: false,
                color: AppColors.clay05,
                onTap: () async {
                  bool? logout = await showDialog(
                      context: context,
                      builder: (_) => const SignOutConfirmation());
                  if (logout == true) {
                    ref.read(userManagerProvider).signout(ref);
                    ref.read(goRouterProvider).pushReplacement(RouteNames.auth);
                  }
                },
                child: Text(
                  "SIGN_OUT".tr(context),
                  style: AppTextStyles.gothamLight12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
