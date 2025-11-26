import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/ranked_component.dart';
import 'package:acepadel/components/waiting_for_approval.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/models/court_booking.dart' as bookingModel;

import '../managers/user_manager.dart';
import '../models/lesson_model_new.dart';
import '../repository/booking_repo.dart';
import '../repository/user_repo.dart';
import '../screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
import 'changes_cancelled_listing_card.dart';

class UserLessonsEventsCard extends ConsumerWidget {
  const UserLessonsEventsCard(
      {super.key, required this.booking, this.isPast = false, this.isLesson = false});
  final UserBookings booking;
  final bool isLesson;
  final bool isPast;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayerPendingPayment = booking.isPlayerPendingPayment(ref);
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
    final color = isCancelled || isPlayerPendingPayment ? AppColors.darkBlue : AppColors.clay05;
    final textColor = isCancelled || isPlayerPendingPayment ? AppColors.white : AppColors.darkBlue;
    final dividerColor = isCancelled || isPlayerPendingPayment ? AppColors.white25 : AppColors.darkBlue.withOpacity(0.05);

    final isRankedEvent = booking.rankedEvent ?? false;

    // Extract data for the card
    final coachName = "${"COACH".trU(context)} ${booking.coachName?.toUpperCase() ?? ""}";
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
    final time = booking.formatStartEndTimeAm;
    final date = booking.formatBookingDate;

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
          if (isPlayerPendingPayment)
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangesCancelledListingCard(
                    color: AppColors.white,
                    isUpperCase: false,
                    iconColor: AppColors.darkBlue,
                    textColor: AppColors.darkBlue,
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.w),
                    style: AppTextStyles.balooMedium13.copyWith(color: AppColors.darkBlue),
                    text: "BOOKING_UNPAID".tr(context),
                  ),
                  MainButton(
                    label: "PAY_NOW".tr(context),
                    onTap: () async {
                      String sportName = "";
                      if ((booking.players ?? []).isNotEmpty &&
                          booking.players!.first.customer!.sportsLevel
                              .isNotEmpty) {
                        sportName = booking.players!.first.customer!.sportsLevel
                            .first.sportName ??
                            "";
                      }

                      List<Courts> listCourts = [];

                      (booking.courts ?? []).map((e) {
                        listCourts.add(
                            Courts.fromJson(e.toJson()));
                      }).toList();
                      final isEvent = (booking.service?.serviceType ?? "").toLowerCase() == "event";
                      final singleEvent =
                          (booking.service?.eventType ?? "").toLowerCase() == "single";
                      dynamic paid = await showDialog(
                        context: context,
                        builder: (context) {
                          return BookCourtDialog(
                            allowPayLater: false,

                            getPendingPayment: true,
                            joinOpenMatch: false,
                            joinEvent: isEvent,
                            joinLesson: !isEvent,
                            eventDoubleJoin: !singleEvent,
                            showRefund: true,
                            coachId: null,
                            courtPriceRequestType: CourtPriceRequestType.join,
                            bookings: bookingModel.Bookings(
                                id: booking.id,
                                price: booking.service!.price,
                                duration: booking.duration2,
                                isOpenMatch: true,
                                sport: bookingModel.Sport(sportName: sportName),
                                location: bookingModel.Location(
                                    id: booking.service!.location!.id,
                                    courts: listCourts,
                                    location: booking
                                        .service!.location!.locationName)),
                            bookingTime: booking.bookingStartTime,
                            court: {
                              (booking.courts ?? []).first.id ?? 0:
                              (booking.courts ?? []).first.courtName ?? ""
                            },
                          );
                        },
                      );

                      if (paid is bool && paid) {
                        Utils.showMessageDialog(
                            context, "YOU_HAVE_PAID_SUCCESSFULLY".tr(context));
                        ref.invalidate(fetchUserAllBookingsProvider);
                        ref.invalidate(walletInfoProvider);
                      }
                    },
                    width: 85.w,
                    height: 30.h,
                    isForPopup: true,
                    labelStyle: AppTextStyles.balooMedium14.copyWith(color: AppColors.white),
                    padding: EdgeInsets.zero,
                  )
                ],
              ),
            ),
          // Top row: Coach and Location
          Row(
            children: [
              Expanded(
                child: Text(
                  locationName,
                  style: AppTextStyles.sansMedium16.copyWith(color: textColor),
                ),
              ),
              Text(
                coachName,
                style: AppTextStyles.sansMedium12.copyWith(color: textColor),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          // SizedBox(height: 6.h),
          CDivider(color: dividerColor,),
          if (isRankedEvent)
            Align(alignment: Alignment.centerRight, child: RankedComponent()),
          // SizedBox(height: 6.h),
          // Details section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   lessonName,
                    //   style: AppTextStyles.gothamLight13.copyWith(color: textColor),
                    // ),
                    // SizedBox(height: 4.h),
                    Text(
                      courtName,
                      style: AppTextStyles.sansRegular13.copyWith(color: textColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${"PRICE".tr(context)} $price",
                      style: AppTextStyles.sansRegular13.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
              // Right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   "$duration$pax",
                    //   style: AppTextStyles.gothamLight13.copyWith(color: textColor),
                    // ),
                    // SizedBox(height: 4.h),
                    Text(
                      date,
                      style: AppTextStyles.sansRegular13.copyWith(color: textColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      time,
                      style: AppTextStyles.sansRegular13.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((booking.service?.isEvent ?? false) &&
              isPast &&
              (booking.scoreSubmitted ?? false) &&
              booking.getMyPositionEvent(currentUserID ?? 0) != null)
            Container(
              decoration: BoxDecoration(
                color: AppColors.blue60,
                borderRadius: BorderRadius.circular(12.r),
              ),
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 13.w),
              child: Text(
                "${(booking.getMyPositionEvent(currentUserID ?? 0) ?? 0).getUserPosition} Place",
                style: AppTextStyles.balooMedium16.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.white
                ),
              ),
            )
        ],
      ),
    );
  }
}
