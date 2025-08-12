import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class ServiceCoaches extends StatelessWidget {
  const ServiceCoaches({super.key, required this.coaches});
  final List<ServiceDetail_Coach> coaches;
  @override
  Widget build(BuildContext context) {
    if (coaches.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text("${"COACHES".tr(context)} ${coaches.length}",
            style: AppTextStyles.panchangBold13),
        SizedBox(height: 10.h),
        ListView.separated(
          shrinkWrap: true,
          itemCount: coaches.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) => _coachCard(coaches[index]),
        ),
      ],
    );
  }

  _coachCard(ServiceDetail_Coach coach) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green5,
        borderRadius: BorderRadius.circular(5.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      child: Row(
        children: [
          Column(
            children: [
              NetworkCircleImage(
                  path: coach.profileUrl, width: 40.w, height: 40.w),
              Text(
                "${coach.fullName}",
                style: AppTextStyles.panchangBold9
                    .copyWith(color: AppColors.darkGreen),
              )
            ],
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              coach.description ?? "",
              style: AppTextStyles.helveticaLight12
                  .copyWith(color: AppColors.darkGreen),
            ),
          ),
        ],
      ),
    );
  }
}
