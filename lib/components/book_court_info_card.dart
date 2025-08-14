import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/court_booking.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../models/lesson_model_new.dart';

class BookCourtInfoCard extends ConsumerWidget {
  const BookCourtInfoCard({
    super.key,
    required this.bookings,
    required this.bookingTime,
    required this.courtName,
    this.textPrice,
    required this.price,
    this.color = AppColors.white,
    this.textColor = AppColors.darkBlue,
    this.dividerColor,
  });

  final Bookings bookings;
  final DateTime bookingTime;
  final String courtName;
  final Color color;
  final Color textColor;
  final Color? dividerColor;
  final double? price;
  final String? textPrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime startTime = bookingTime;
    DateTime endTime = bookingTime.add(Duration(minutes: bookings.duration!));

    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'LOCATION'.tr(context),
                style: AppTextStyles.balooMedium16.copyWith(color: textColor),
              ),
              const Spacer(),
              Text(
                '${"DATE".tr(context)} & ${"TIME".tr(context)}',
                style: AppTextStyles.balooMedium16.copyWith(color: textColor),
              ),
            ],
          ),
          CDivider(color: dividerColor ?? AppColors.clay05),
          // SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courtName.capitalizeFirst,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sansRegular15.copyWith(color: textColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      bookings.location?.locationName?.capitalizeFirst ?? '',
                      style: AppTextStyles.sansRegular15.copyWith(color: textColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      textPrice ??
                          "${"PRICE".tr(context)} ${Utils.formatPrice(price)}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sansRegular15.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${startTime.format("h:mm")} - ${endTime.format("h:mm a").toLowerCase()}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sansRegular15.copyWith(color: textColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      startTime.format("EE dd MMM"),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sansRegular15.copyWith(color: textColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${bookings.duration} min",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sansRegular15.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookCourtInfoCardLesson extends ConsumerWidget {
  const BookCourtInfoCardLesson(
      {super.key,
      this.isBooked = false,
      this.title,
      required this.bookingTime,
      this.lessonVariant,
      this.bgColor = AppColors.white,
      this.duration,
      this.courtName,
      this.coachName,
      this.price,
      this.locationName});

  final Color? bgColor;
  final bool isBooked;
  final String? title;
  final int? duration;
  final DateTime bookingTime;
  final String? courtName;
  final String? coachName;
  final double? price;
  final String? locationName;
  final LessonVariants? lessonVariant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime startTime = bookingTime;
    DateTime endTime = bookingTime.add(Duration(minutes: duration!));
    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                coachName?.capitalizeFirst ?? '' /*'LOCATION'.tr(context)*/,
                style: AppTextStyles.balooMedium13
                    .copyWith(color: AppColors.darkBlue),
              )),
              SizedBox(width: 5.w),
              Text(
                '${"DATE".tr(context)} & ${"TIME".tr(context)}',
                style: AppTextStyles.balooMedium13
                    .copyWith(color: AppColors.darkBlue),
              ),
            ],
          ),
          const CDivider(),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courtName?.capitalizeFirst ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.darkBlue),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      locationName?.capitalizeFirst ?? '',
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.darkBlue),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${"PRICE".tr(context)} ${Utils.formatPrice(price?.toDouble())}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.darkBlue),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${startTime.format("HH:mm")} - ${endTime.format("HH:mm")}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.darkBlue),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      startTime.format("EE dd MMM"),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.darkBlue),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "$duration mins${lessonVariant != null ? " : ${lessonVariant?.maximumCapacity ?? ""} pax" : ''}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.darkBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
