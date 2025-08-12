import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

class SecondaryTextField extends StatelessWidget {
  final String? labelText;
  final String? errorText;
  final String? helperText;
  final String? hintText;
  final String? initialValue;
  final TextStyle? style;
  final TextStyle? hintTextStyle;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? width;
  final bool? obscureText;
  final bool? isDense;
  final bool? readOnly;
  final bool? isError;
  final bool? autofocus;
  final bool hasBorders;
  final bool hasShadow;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets? contentPadding;
  final FocusNode? node;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool isEnabled;
  SecondaryTextField({
    this.width,
    this.height,
    this.textInputAction,
    this.keyboardType,
    this.controller,
    this.node,
    this.contentPadding,
    this.obscureText,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.errorText,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.style,
    this.labelText,
    this.helperText,
    this.hintText,
    this.hintTextStyle,
    this.isDense,
    this.inputFormatters,
    this.hasBorders = true,
    this.hasShadow = false,
    this.readOnly,
    this.maxLines,
    this.minLines,
    this.autofocus,
    this.fillColor = AppColors.white25,
    this.initialValue,
    this.isError = false,
    this.isEnabled = true,
    Key? key,
  }) : super(key: key);

  final borderRadius = 50.r;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: height ?? .h,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        textAlign: textAlign,
        enabled: isEnabled,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        focusNode: node,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        cursorRadius: Radius.circular(15.r),
        cursorWidth: 1,
        autofocus: autofocus ?? false,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        cursorColor: errorText == null ? AppColors.white : AppColors.errorColor,
        style: style ??
            AppTextStyles.gothamLight12.copyWith(
              height: 1,
              color: (readOnly ?? false) ? AppColors.white25 : AppColors.white,
              ////fontFamily: kPirulen,
              fontSize: 12.sp,
            ),
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 12.w,
              ),
          alignLabelWithHint: true,
          labelText: labelText,
          labelStyle: AppTextStyles.balooBold18,
          helperText: helperText,
          hintText: hintText,
          hintStyle: hintTextStyle ??
              AppTextStyles.sansRegular13.copyWith(color: AppColors.white55),
          prefixIcon: prefixIcon,
          prefixIconConstraints:
              BoxConstraints.tightFor(width: 50.h, height: 45.h),
          suffixIconConstraints:
              BoxConstraints.tightFor(width: 30.w, height: 15.h),
          errorText: errorText,
          suffix: suffix,
          suffixIcon: suffixIcon,
          prefix: prefix,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
