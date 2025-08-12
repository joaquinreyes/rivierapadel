import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/images.dart';
import '../globals/constants.dart';

class CustomDropDown<T> extends StatefulWidget {
  const CustomDropDown({
    required this.label,
    required this.items,
    required this.childrenBuilder,
    this.height,
    this.maxDropDownHeight,
    this.onExpansionChanged,
    this.iconColor = AppColors.white,
    Key? key,
  }) : super(key: key);
  final double? height;
  final double? maxDropDownHeight;
  final String label;
  final Widget Function(T, int) childrenBuilder;
  final ValueChanged<bool>? onExpansionChanged;
  final List<T> items;
  final Color iconColor;

  @override
  State<CustomDropDown<T>> createState() => CustomDropDownState<T>();
}

class CustomDropDownState<T> extends State<CustomDropDown<T>> {
  bool _isOpen = false;
  bool get isOpen => _isOpen;
  void toggleExpansion() {
    _isOpen = !_isOpen;
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isOpen);
    }
    setState(() {});
  }

  void close() {
    if (_isOpen) {
      _isOpen = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const duration = kAnimationDuration;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: () {
            widget.items.isEmpty ? null : toggleExpansion();
          },
          child: AnimatedContainer(
            height: widget.height ?? 28.h,
            duration: duration,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.white25,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: AppTextStyles.gothamLight12.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? -0.5 : 0,
                  duration: duration,
                  child: Image.asset(
                    AppImages.dropdownIcon.path,
                    width: 10.w,
                    color: widget.iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: AnimatedContainer(
            height: _isOpen ? null : 0,
            constraints:
                BoxConstraints(maxHeight: widget.maxDropDownHeight ?? 250.h),
            duration: duration,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return widget.childrenBuilder(widget.items[index], index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
