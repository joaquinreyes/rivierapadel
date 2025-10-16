import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';

class RankedComponent extends StatelessWidget {
  const RankedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 13.w),
      child: Text(
        "RANKED".tr(context),
        style: AppTextStyles.balooMedium16.copyWith(
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
