import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../globals/utils.dart';

class ChangesCancelledDetailsCard extends StatelessWidget {
  const ChangesCancelledDetailsCard(
      {super.key, required this.heading, required this.description});
  final String heading;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(5.r),
      ),
      padding: EdgeInsets.only(
        left: 15.w,
        right: 10.w,
        top: 10.h,
        bottom: 15.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                heading,
                style: AppTextStyles.balooBold12,
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            description,
            style: AppTextStyles.gothamLight13,
          ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.centerRight,
            child: SecondaryImageButton(
              onTap: () async {
                await Utils.openWhatsappSupport(context: context);
              },
              label: "SEND_US_A_MESSAGE".tr(context),
              image: AppImages.whatsaapIcon.path,
              color: AppColors.darkGreen25,
              textColor: AppColors.darkGreen,
              iconColor: AppColors.darkGreen,
              fontSize: 11.sp,
              applyShadow: false,
            ),
          ),
        ],
      ),
    );
  }
}
