import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/waiting_for_approval.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../managers/user_manager.dart';
import 'changes_cancelled_listing_card.dart';

class UserLessonsEventsCard extends ConsumerWidget {
  const UserLessonsEventsCard(
      {super.key, required this.booking, this.isLesson = false});
  final UserBookings booking;
  final bool isLesson;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserID = ref.read(userManagerProvider).user?.user?.id;
    bool isPlayerCancelled = false;

    final index = booking.players?.indexWhere(
      (element) => element.customer?.id == currentUserID,
    );

    if (index == -1 || index == null) {
      final index2 = booking.requestWaitingList?.indexWhere(
        (element) => element.id == currentUserID,
      );
      if (index2 == -1 || index == null) {
        return const SizedBox();
      }
    } else {
      isPlayerCancelled = booking.players?[index].isCanceled ?? false;
    }
    bool isEventCancelled = booking.isCancelled ?? false;
    bool isCancelled = isPlayerCancelled || isEventCancelled;
    bool isWaiting = false;

    bool isApproved = false;
    bool inWaitingList = false;
    if ((booking.requestWaitingList ?? []).isNotEmpty) {
      String status = (booking.requestWaitingList ?? []).first.status ?? "";
      isWaiting = status == "pending" || status == "waiting_approval";
      inWaitingList = status == "waiting";
      isApproved = status == "approved";
    }
    String cancelText = "";
    if (isPlayerCancelled) {
      cancelText = "YOU_HAVE_LEFT_SUCCESSFULLY".tr(context);
    }
    if (isEventCancelled) {
      cancelText = isLesson
          ? "LESSON_CANCELLED".tr(context)
          : "EVENT_CANCELLED".tr(context);
    }
    final color = isCancelled ? AppColors.darkGreen5 : AppColors.darkGreen5;
    const textColor = AppColors.black;

    // Extract data for the card
    final coachName = "${"COACH".tr(context)} ${booking.coachName ?? ""}";
    final locationName = booking.service?.location?.locationName ?? "-";
    final lessonName = booking.service?.eventLessonName ?? "Lesson";
    final courtName = booking.courtName;
    final price = booking.service?.price != null
        ? Utils.formatPrice(booking.service?.price?.toDouble())
        : "-";
    final duration = "${booking.calculatedDuration} min";
    final pax = booking.maximumCapacity != null
        ? " - ${booking.maximumCapacity} pax"
        : "";
    final time = booking.formatStartEndTime;
    final date = booking.formatBookingDate;

    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((isWaiting || inWaitingList) && !isCancelled) ...[
            if (isApproved)
              ChangesCancelledListingCard(
                  text: "Approved_To_Join_Join_Now".tr(context)),
            if (inWaitingList)
              ChangesCancelledListingCard(text: "IN_WAITING_LIST".tr(context)),
            if (isWaiting) const WaitingForApproval(),
            SizedBox(height: 5.h)
          ],
          if (isCancelled) ...[
            ChangesCancelledListingCard(text: cancelText),
            SizedBox(height: 10.h),
          ],
          // Top row: Coach and Location
          Row(
            children: [
              Expanded(
                child: Text(
                  coachName,
                  style: AppTextStyles.helveticaBold14.copyWith(color: textColor),
                ),
              ),
              Text(
                locationName,
                style: AppTextStyles.helveticaBold13.copyWith(color: textColor),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          const CDivider(),
          SizedBox(height: 6.h),
          // Details section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessonName,
                      style: AppTextStyles.helveticaLight13.copyWith(color: textColor),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      courtName,
                      style: AppTextStyles.helveticaLight13.copyWith(color: textColor),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${"PAID".tr(context)} $price",
                      style: AppTextStyles.helveticaLight13.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
              // Right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$duration$pax",
                      style: AppTextStyles.helveticaLight13.copyWith(color: textColor),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: AppTextStyles.helveticaLight13.copyWith(color: textColor),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: AppTextStyles.helveticaLight13.copyWith(color: textColor),
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
