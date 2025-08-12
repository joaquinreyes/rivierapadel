import 'package:acepadel/app_styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              AppImages.logoWebHeader.path,
              width: 360.w,
              height: 80.h,
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 18.w),
              child: SecondaryButton(
                onTap: () {
                  // Get.dialog(signOutDialog(AppController.I));
                },
                child: Text(
                  "SIGN_OUT".tr(context),
                  style: AppTextStyles.balooMedium10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
