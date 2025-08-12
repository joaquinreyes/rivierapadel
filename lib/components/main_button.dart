import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    this.label,
    this.onTap,
    this.child,
    this.padding = EdgeInsets.zero,
    this.color,
    this.labelStyle,
    this.labelColor,
    this.applySize = true,
    this.applyShadow = false,
    this.enabled = true,
    this.loading = false,
    this.borderRadius,
    this.height,
    this.width,
    this.constraints,
    this.showArrow = false,
    this.isForPopup = false,
    super.key,
  });

  final String? label;
  final TextStyle? labelStyle;
  final bool applySize;
  final bool applyShadow;
  final bool enabled;
  final bool loading;
  final Color? color;
  final Color? labelColor;
  final VoidCallback? onTap;
  final double? borderRadius;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsets padding;
  final Widget? child;
  final bool showArrow;
  final bool isForPopup;

  Color get _defaultBackgroundColor =>
      isForPopup ? AppColors.yellow : AppColors.green;

  Color get _backgroundColor => color ?? _defaultBackgroundColor;

  Color get _defaultDisabledColor => AppColors.darkGreen25;

  double get effectiveBorderRadius => borderRadius ?? 5.r;

  BoxDecoration get buttonDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: enabled ? _backgroundColor : _defaultDisabledColor,
        boxShadow: applyShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.10),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                )
              ]
            : null,
      );

  BoxDecoration get containerDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: Colors.transparent,
      );

  double? get effectiveHeight => height ?? (applySize ? 40.h : null);

  double? get effectiveWidth => width ?? (applySize ? 294.w : null);

  BoxConstraints? get effectiveConstraints =>
      constraints ?? (applySize ? kComponentWidthConstraint : null);

  Widget _buildContent() {
    if (loading) {
      return _buildLoadingIndicator();
    }
    if (child != null) {
      return child!;
    }
    return _buildLabel();
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 25.h,
      width: 25.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(labelColor),
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: (showArrow && !isForPopup)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label ?? '',
            textAlign: TextAlign.center,
            style: isForPopup ? _labelTextStyleForPopup : _labelTextStyle,
          ),
          if (showArrow && !isForPopup) _buildArrowIcon(),
        ],
      ),
    );
  }

  TextStyle get _labelTextStyle {
    if (enabled) {
      return labelStyle ??
          AppTextStyles.panchangBold16.copyWith(
            height: 1.2,
            color: AppColors.white,
          );
    } else {
      return labelStyle ??
          AppTextStyles.panchangMedium13.copyWith(
            height: 1.2,
            color: AppColors.white,
          );
    }
  }

  TextStyle get _labelTextStyleForPopup {
    if (enabled) {
      return labelStyle ??
          AppTextStyles.panchangMedium13.copyWith(
            height: 1.2,
            color: AppColors.green,
          );
    } else {
      return labelStyle ??
          AppTextStyles.panchangMedium13.copyWith(
            height: 1.2,
            color: AppColors.white,
          );
    }
  }

  Widget _buildArrowIcon() {
    return Image.asset(
      AppImages.rightArrow.path,
      height: 18.h,
      width: 18.h,
      color: labelStyle?.color ??
          labelColor ??
          (enabled ? AppColors.white : AppColors.white),
    );
  }

  void _handleTap() {
    if (!loading && enabled && onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      decoration: containerDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        onTap: _handleTap,
        child: Container(
          height: effectiveHeight,
          width: effectiveWidth,
          decoration: buttonDecoration,
          padding: padding,
          constraints: effectiveConstraints,
          child: Center(
            child: AnimatedSwitcher(
              duration: kAnimationDuration,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}
