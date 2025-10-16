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
    required this.storePrice,
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
  final double? storePrice;
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
        children: [
          _infoRow(
              "DATE".tr(context), '${startTime.format('EEEE, d MMMM yyyy')}'),
          _infoRow("TIME".tr(context),
              '${startTime.format('h:mm a')} - ${endTime.format('h:mm a')}'),
          _infoRow("LOCATION".tr(context),
              (bookings.location?.locationName ?? '').capitalizeFirst),
          _infoRow(
              "ACTIVITY".tr(context),
              (bookings.sport?.sportName ?? "").capitalizeFirst),
          _infoRow("VENUE".tr(context), courtName),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.clay05,
              borderRadius: BorderRadius.circular(6.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: textPrice != null
                ? Column(
                    children: (textPrice ?? "").split("\n").map((e) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.split(":").first,
                            style: AppTextStyles.balooMedium16
                                .copyWith(color: textColor),
                          ),
                          Text(
                            e.split(":").last,
                            style: AppTextStyles.balooMedium16
                                .copyWith(color: textColor),
                            textAlign: TextAlign.right,
                          ),
                        ]);
                  }).toList())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PRICE".tr(context),
                        style: AppTextStyles.balooMedium16
                            .copyWith(color: textColor),
                      ),
                      if (storePrice != null && storePrice! > (price ?? 0))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Utils.formatPrice(storePrice),
                              style: AppTextStyles.sansRegular15.copyWith(
                                color: textColor.withOpacity(0.6),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              Utils.formatPrice(price),
                              style: AppTextStyles.balooMedium16
                                  .copyWith(color: textColor),
                            ),
                          ],
                        )
                      else
                        Text(
                          Utils.formatPrice(price),
                          style: AppTextStyles.balooMedium16
                              .copyWith(color: textColor),
                        ),
                    ],
                  ),
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.center,
            child: Text(
              "INCLUSIVE_OF_VAT_AND_SERVICE_FEES".tr(context),
              style: AppTextStyles.sansRegular15.copyWith(
                color: textColor,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.balooMedium16.copyWith(color: textColor),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.sansRegular15.copyWith(color: textColor),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
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
