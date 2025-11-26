import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/images.dart';

class ChangesCancelledListingCard extends StatelessWidget {
  const ChangesCancelledListingCard({
    super.key,
    required this.text,
    this.color,
    this.iconColor,
    this.textColor,
    this.isUpperCase = true,
    this.padding,
    this.style,
  });

  final String text;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final TextStyle? style;
  final bool isUpperCase;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.oak,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: padding ?? EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.warning.path,
            width: 13.w,
            height: 13.w,
            color: iconColor ?? AppColors.white,
          ),
          SizedBox(width: 10.w),
          Text(
            isUpperCase ? text.toUpperCase() : text,
            style: style ?? AppTextStyles.balooMedium13.copyWith(color: textColor ?? AppColors.white),
          ),
        ],
      ),
    );
  }
}
