import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/images.dart';

class ChangesCancelledListingCard extends StatelessWidget {
  const ChangesCancelledListingCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.oak,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.warning.path,
            width: 13.w,
            height: 13.w,
            color: AppColors.white,
          ),
          SizedBox(width: 10.w),
          Text(
            text.toUpperCase(),
            style: AppTextStyles.balooMedium13.copyWith(color: AppColors.white,),
          ),
        ],
      ),
    );
  }
}
