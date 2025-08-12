import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
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
  final bool? autofocus;
  final bool hasBorders;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets? contentPadding;
  final FocusNode node;
  final TextEditingController controller;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final InputBorder? border;

  final bool isForPopup;
  final String? Function(String?)? validator;
  final bool isRequired;
  const CustomTextField({
    this.width,
    this.height,
    this.textInputAction,
    this.border,
    this.keyboardType,
    required this.controller,
    required this.node,
    this.contentPadding,
    this.obscureText,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.style,
    this.labelText,
    this.helperText,
    this.hintText,
    this.hintTextStyle,
    this.isDense = true,
    this.hasBorders = true,
    this.readOnly,
    this.maxLines,
    this.minLines,
    this.autofocus,
    this.fillColor = AppColors.lightPink,
    this.initialValue,
    this.borderColor,
    this.isForPopup = false,
    this.validator,
    this.isRequired = false,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    TextStyle style = widget.style ??
        (widget.isForPopup
            ? AppTextStyles.helveticaLight12
            : AppTextStyles.helveticaLight16);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.node.hasFocus) {
          widget.node.requestFocus();
        }
      },
      child: TextFormField(
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        textAlign: widget.textAlign,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        focusNode: widget.node,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.obscureText ?? false,
        cursorRadius: Radius.circular(15.r),
        cursorWidth: 1.5,
        autofocus: widget.autofocus ?? false,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines ?? 1,
        validator: widget.validator,
        cursorHeight: 20.h,
        style: style,
        decoration: InputDecoration(
          filled: widget.isForPopup ? true : widget.fillColor != null,
          fillColor: widget.isForPopup ? AppColors.white25 : widget.fillColor,
          contentPadding: widget.contentPadding ??
              (!widget.isForPopup
                  ? EdgeInsets.symmetric(vertical: 8.h)
                  : const EdgeInsets.all(8)),
          alignLabelWithHint: true,
          labelText: widget.labelText,
          labelStyle: widget.isForPopup
              ? AppTextStyles.panchangBold18
              : AppTextStyles.panchangBold26,
          helperText: widget.helperText,
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle ??
              (widget.isForPopup
                  ? AppTextStyles.helveticaLight12
                      .copyWith(color: AppColors.white55)
                  : AppTextStyles.helveticaLight16
                      .copyWith(color: AppColors.darkGreen70)),
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints:
              BoxConstraints.tightFor(width: 50.h, height: 45.h),
          suffix: widget.suffix,
          suffixIcon: widget.suffixIcon,
          suffixIconConstraints: BoxConstraints(maxHeight: 16.h),
          isDense: widget.isDense,
          border: widget.isForPopup ? _popupTextFieldBorder() : _border(),
          errorBorder: widget.border ??
              (widget.isForPopup
                  ? _popupTextFieldBorder()
                  : _border(
                      color: AppColors.errorColor,
                    )),
          focusedBorder: widget.border ??
              (widget.isForPopup ? _popupTextFieldBorder() : _border()),
          enabledBorder: widget.border ??
              (widget.isForPopup ? _popupTextFieldBorder() : _border()),
          disabledBorder: widget.border ??
              (widget.isForPopup
                  ? _popupTextFieldBorder()
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.borderColor ?? AppColors.green,
                      ),
                    )),
        ),
      ),
    );
  }

  OutlineInputBorder _popupTextFieldBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(0.r),
    );
  }

  UnderlineInputBorder _border({Color color = AppColors.darkGreen}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: widget.borderColor ?? color),
    );
  }
}
