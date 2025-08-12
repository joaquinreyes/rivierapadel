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
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(5.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.warning.path,
            width: 13.w,
            height: 13.w,
            color: AppColors.darkGreen,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: AppTextStyles.panchangBold10,
          ),
        ],
      ),
    );
  }
}
