import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

class AvailableSlotWidget extends StatelessWidget {
  const AvailableSlotWidget({
    super.key,
    required this.text,
    required this.index,
    this.backgroundColor = AppColors.green,
    this.onTap,
    this.isHorizontal = false,
    this.otherTeamMemberID,
    this.iconColor = AppColors.green,
    this.textColor = AppColors.green,
  });

  final String text;
  final Color backgroundColor;
  final Function(int, int?)? onTap;
  final int index;
  final bool isHorizontal;
  final int? otherTeamMemberID;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(index, otherTeamMemberID) : null,
      child: isHorizontal ? _horizontal() : _vertical(),
    );
  }

  _horizontal() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(width: 15.h),
          _text(),
        ],
      ),
    );
  }

  Container _vertical() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      width: 61.w,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(height: 8.h),
          _text(),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  AutoSizeText _text() {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      maxFontSize: 12,
      minFontSize: 8,
      maxLines: 1,
      stepGranularity: 1,
      style: AppTextStyles.helveticaBold12.copyWith(
        color: textColor,
      ),
    );
  }

  Container _circle() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: DottedBorder(
        borderType: BorderType.Circle,
        dashPattern: const [5, 4],
        color: iconColor,
        strokeWidth: 1.h,
        child: Container(
          height: 35.w,
          width: 35.w,
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 20.h,
          ),
        ),
      ),
    );
  }
}
