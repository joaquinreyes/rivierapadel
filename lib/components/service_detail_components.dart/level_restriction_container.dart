import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class LevelRestrictionContainer extends StatelessWidget {
  const LevelRestrictionContainer({
    super.key,
    required this.levelRestriction,
  });

  final String? levelRestriction;

  @override
  Widget build(BuildContext context) {
    if (levelRestriction == null || levelRestriction!.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [kBoxShadow],
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        "${"LEVEL".tr(context)} $levelRestriction",
        style: AppTextStyles.sansMedium14,
      ),
    );
  }
}
