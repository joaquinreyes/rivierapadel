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
        Text("${"COACH".trU(context)} ${coaches.length}",
            style: AppTextStyles.balooMedium17),
        SizedBox(height: 4.h),
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
        color: AppColors.clay05,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      child: Row(
        children: [
          Column(
            children: [
              NetworkCircleImage(
                path: coach.profileUrl,
                width: 37.h,
                height: 37.h,
                boxBorder: Border.all(color: AppColors.white25),
              ),
              Text(
                "${coach.fullName?.toUpperCase()}",
                style: AppTextStyles.balooMedium11,
              )
            ],
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              coach.description ?? "",
              style: AppTextStyles.sansRegular13
            ),
          ),
        ],
      ),
    );
  }
}
