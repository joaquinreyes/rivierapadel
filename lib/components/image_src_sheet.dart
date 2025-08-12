import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/custom_extensions.dart';
import 'main_button.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.darkBlue,
                size: 15.sp,
              ),
            ),
          ),
          Text(
            'CHANGE_PROFILE_PICTURE'.trU(context),
            style: AppTextStyles.balooMedium19,
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: 'CAMERA'.tr(context),
            enabled: true,
            showArrow: true,
            labelStyle: AppTextStyles.sansMedium18.copyWith(color: AppColors.white,height: 1),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          SizedBox(height: 17.h),
          MainButton(
            label: 'GALLERY'.tr(context),
            enabled: true,
            showArrow: true,
            labelStyle: AppTextStyles.sansMedium18.copyWith(color: AppColors.white,height: 1),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
          SizedBox(height: 22.h),
        ],
      ),
    );
  }
}
