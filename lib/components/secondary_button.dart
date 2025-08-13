import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/constants.dart';

class SecondaryImageButton extends StatelessWidget {
  SecondaryImageButton({
    super.key,
    this.onTap,
    required this.label,
    required this.image,
    double? imageHeight,
    double? imageWidth,
    double? fontSize,
    double? spacing,
    this.textColor,
    this.iconColor,
    this.color,
    this.padding,
    this.applyShadow = true,
    this.isForPopup = false,
  })  : imageHeight = imageHeight ?? 15.h,
        imageWidth = imageWidth ?? 15.h,
        fontSize = fontSize ?? 10.5.sp,
        spacing = spacing ?? 7.w;
  final VoidCallback? onTap;
  final String label;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final double fontSize;
  final Color? color;
  EdgeInsets? padding;
  final double? spacing;
  final Color? textColor;
  final Color? iconColor;
  final bool applyShadow;
  final bool isForPopup;
  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      color: color ?? (isForPopup ? AppColors.white25 : AppColors.clay05),
      padding: padding,
      applyShadow: applyShadow,
      onTap: () {
        onTap?.call();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            height: imageHeight,
            width: imageWidth,
            color: isForPopup
                ? AppColors.white
                : (iconColor ?? AppColors.darkBlue),
          ),
          SizedBox(width: spacing),
          Text(
            label,
            style: isForPopup ? AppTextStyles.sansRegular13.copyWith(color: AppColors.white) : AppTextStyles.sansRegular13.copyWith(
                fontSize: fontSize,
                color: (iconColor ?? AppColors.darkBlue)),
          ),
        ],
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  SecondaryButton(
      {super.key,
      this.onTap,
      required this.child,
      this.enabled = true,
      this.color,
      this.padding,
      this.borderRadius = 100,
      this.applyShadow = true});
  final VoidCallback? onTap;
  final Widget child;
  final bool enabled;
  Color? color;
  EdgeInsets? padding;
  final double borderRadius;
  final bool applyShadow;
  @override
  Widget build(BuildContext context) {
    color ??= AppColors.darkGreen5;
    padding ??= EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius.r),
            boxShadow: applyShadow ? [kBoxShadow] : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius.r),
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
