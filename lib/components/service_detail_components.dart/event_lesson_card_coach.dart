import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/models/service_detail_model.dart';

class EventLessonCardCoach extends StatelessWidget {
  const EventLessonCardCoach({
    super.key,
    required this.coaches,
    this.showAllCouches = true,
  });
  final List<ServiceDetail_Coach>? coaches;
  final bool showAllCouches;

  @override
  Widget build(BuildContext context) {
    if (coaches == null || coaches!.isEmpty) {
      return const SizedBox();
    }

    if (!showAllCouches) {
      final coach = coaches!.first;
      int coachCount = coaches?.length ?? 0;
      String coachName = coach.fullName ?? "";
      String coachProfile = coach.profileUrl ?? "";
      if (coachCount > 1) {
        coachName = "$coachName +${coachCount - 1}";
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          NetworkCircleImage(
            path: coachProfile,
            width: 28.w,
            height: 28.w,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              coachName,
              style: AppTextStyles.panchangBold9,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: (coaches ?? []).map((e) {
        String coachProfile = e.profileUrl ?? "";
        String coachName = e.fullName ?? "";
        return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NetworkCircleImage(
                  path: coachProfile,
                  width: 28.w,
                  height: 28.w,
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: Text(
                    coachName,
                    style: AppTextStyles.panchangBold9,
                  ),
                ),
              ],
            ));
      }).toList(),
    );
  }
}
