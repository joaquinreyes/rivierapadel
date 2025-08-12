import 'package:acepadel/app_styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class ServiceInformationText extends StatelessWidget {
  const ServiceInformationText({
    super.key,
    required this.service,
  });

  final ServiceDetail service;

  @override
  Widget build(BuildContext context) {
    if (service.service?.additionalService?.isEmpty ?? true) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            Image.asset(AppImages.infoIcon.path, width: 12.w, height: 12.h),
            SizedBox(width: 10.w),
            Text(
              "INFORMATION".tr(context),
              style: AppTextStyles.panchangBold13
                  .copyWith(color: AppColors.darkGreen),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          service.service?.additionalService ?? "",
          style: AppTextStyles.helveticaLight12,
        ),
      ],
    );
  }
}
