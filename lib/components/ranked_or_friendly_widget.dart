import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
as inset;

import '../globals/constants.dart';

class RankedOrFriendly extends StatelessWidget {
  const RankedOrFriendly({
    super.key,
    this.isRanked = true,
  });

  final bool isRanked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset.BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: kInsetShadow,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      child: Row(
        children: [
          _buildWidget("FRIENDLY".tr(context), !isRanked),
          _buildWidget("RANKED".tr(context), isRanked),
        ],
      ),
    );
  }

  _buildWidget(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.oak : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
      child: Text(
        text,
        style: isSelected ? AppTextStyles.gothamRegular14.copyWith(color: AppColors.white) : AppTextStyles.sansRegular13.copyWith(
          color: AppColors.clay70,),
      ),
    );
  }
}
