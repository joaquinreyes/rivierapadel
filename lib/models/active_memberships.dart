import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';

class ActiveMemberships {
  int? id;
  int? membershipId;
  String? membershipName;
  int? usesLeft;
  String? finishDate;
  String? duration;
  String? location;

  ActiveMemberships(
      {this.id,
      this.membershipName,
      this.usesLeft,
      this.membershipId,
      this.finishDate,
      this.duration,
      this.location});

  DateTime? get finishDateTime {
    if (finishDate != null) {
      return DateTime.tryParse(finishDate ?? "");
    }
    return null;
  }

  String finishDateString(BuildContext context) {
    return "${"VALID_UNTIL".tr(context)}:\n${finishDateTime != null ? finishDateTime!.format("dd/MM/yyyy") : "UNLIMITED".tr(context)}";
  }

  Widget usesLeftString(BuildContext context,{Color? textColor}) {
    if (usesLeft == null || usesLeft == -1) {
      return Text(
        "UNLIMITED".tr(context),
        style: AppTextStyles.sansRegular12.copyWith(color: AppColors.white),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration:
              BoxDecoration(color: textColor?.withOpacity(0.4) ?? AppColors.white, shape: BoxShape.circle),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          alignment: Alignment.center,
          child: Text(
            usesLeft.toString(),
            style: AppTextStyles.sansMedium12.copyWith(color:  textColor ?? AppColors.darkBlue),
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          "REMAINING".tr(context).toLowerCase(),
          style: AppTextStyles.sansRegular12.copyWith(color: textColor ?? AppColors.white),
        )
      ],
    );
  }

  ActiveMemberships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    membershipName = json['membership_name'];
    membershipId = json['membership_id'];
    usesLeft = json['uses_left'];
    finishDate = json['finish_date'];
    duration = json['duration'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['membership_name'] = membershipName;
    data['membership_id'] = membershipId;
    data['uses_left'] = usesLeft;
    data['finish_date'] = finishDate;
    data['duration'] = duration;
    data['location'] = location;
    return data;
  }
}
