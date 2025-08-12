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
        color: AppColors.lightPink,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CHANGE_PROFILE_PICTURE'.tr(context),
            style: AppTextStyles.panchangBold15,
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: 'CAMERA'.tr(context),
            enabled: true,
            showArrow: false,
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          SizedBox(height: 17.h),
          MainButton(
            label: 'GALLERY'.tr(context),
            enabled: true,
            showArrow: false,
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
