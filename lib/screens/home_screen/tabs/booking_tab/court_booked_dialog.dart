import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/models/lesson_model_new.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/book_court_info_card.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/models/court_booking.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../../../globals/utils.dart';

class CourtBookedDialog extends ConsumerStatefulWidget {
  const CourtBookedDialog(
      {super.key,
      required this.bookings,
      required this.bookingTime,
      required this.court,
      this.amountPaid,
      this.refundAmount,
      required this.isOpenMatch,
      required this.serviceID});

  final Bookings bookings;
  final DateTime bookingTime;
  final Map<int, String> court;
  final bool isOpenMatch;
  final double? amountPaid;
  final int? serviceID;
  final double? refundAmount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CourtBookedDialogState();
}

class _CourtBookedDialogState extends ConsumerState<CourtBookedDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "BOOKING_INFORMATION".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "CANCELLATION_POLICY".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          BookCourtInfoCard(
            textPrice: widget.refundAmount != null
                ? "${"PRICE".tr(context)} ${Utils.formatPrice((widget.amountPaid ?? widget.bookings.price)?.toDouble())}\n${"REFUND".tr(context)} ${Utils.formatPrice(widget.refundAmount?.toDouble())}"
                : null,
            bookings: widget.bookings,
            dividerColor: AppColors.white25,
            textColor: AppColors.white,
            price: widget.amountPaid ?? widget.bookings.price,
            bookingTime: widget.bookingTime,
            courtName: widget.court.values.first,
            color: AppColors.oak,
          ),
          if (widget.isOpenMatch)
          SizedBox(height: 15.h),
          if (widget.isOpenMatch) _openMatch(),
          SizedBox(height: 15.h),
          Row(
            children: [
              SecondaryImageButton(
                label: 'ADD_TO_CALENDAR'.tr(context),
                image: AppImages.calendar.path,
                onTap: () {
                  final sportName = ref
                          .read(selectedSportProvider.notifier)
                          .state
                          ?.sportName ??
                      '';
                  String title = widget.isOpenMatch
                      ? "$sportName Match"
                      : "Booking @ ${widget.court.values.first} - ${widget.bookings.location?.locationName?.capitalizeFirst ?? ''}";
                  DateTime startTime = widget.bookingTime;
                  DateTime endTime = widget.bookingTime
                      .add(Duration(minutes: widget.bookings.duration!));
                  ref.watch(addToCalendarProvider(
                    title: title,
                    startDate: startTime,
                    endDate: endTime,
                  ));
                },
                isForPopup: true,
              ),
              const Spacer(),
              SecondaryImageButton(
                label: "SEE_MY_MATCHES".tr(context),
                image: AppImages.tennisBall.path,
                imageHeight: 13.h,
                imageWidth: 13.h,
                isForPopup: true,
                onTap: () {
                  Future(() {
                    ref.read(pageControllerProvider).animateToPage(
                          2,
                          duration: kAnimationDuration,
                          curve: Curves.linear,
                        );
                    ref.read(pageIndexProvider.notifier).index = 2;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          if (widget.isOpenMatch) ...[
            SizedBox(height: 10.h),
            SecondaryImageButton(
              imageHeight: 14.h,
              imageWidth: 14.h,
              isForPopup: true,
              label: 'SHARE_MATCH'.tr(context),
              image: AppImages.whatsaapIcon.path,
              onTap: () {
                final service = ref
                    .watch(fetchServiceDetailProvider(widget.serviceID!))
                    .asData
                    ?.value;
                if (service == null) return;
                Utils.shareOpenMatch(context, service);
              },
            ),
          ],
        ],
      ),
    );
  }

  _openMatch() {
    final service = ref.watch(fetchServiceDetailProvider(widget.serviceID!));
    return service.when(
      data: (data) {
        final String organizerNote = data.organizerNote ?? "";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (organizerNote.isNotEmpty) ...[
              Text(
                "NOTE_FROM_ORGANIZER".tr(context),
                style: AppTextStyles.sansRegular16
                    .copyWith(color: AppColors.white),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white25,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                width: double.infinity,
                child: Text(
                  data.organizerNote ?? "",
                  style: AppTextStyles.sansRegular13
                      .copyWith(color: AppColors.white),
                ),
              ),
            SizedBox(height: 15.h),
            ],
            Text(
              "YOUR_OPEN_MATCH".tr(context),
              style:
                  AppTextStyles.sansRegular16.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 10.h),
            OpenMatchParticipantRowWithBG(
              availableSlotbackGroundColor: AppColors.blue35,
              availableSlotIconColor: AppColors.white,
              bgColor: AppColors.white25,
              textColor: AppColors.white,
              textForAvailableSlot: "RESERVE".tr(context),
              players: data.players ?? [],
            ),
            SizedBox(height: 15.h),
          ],
        );
      },
      error: (err, __) => SecondaryText(text: err.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CourtLessonBookedDialog extends ConsumerStatefulWidget {
  const CourtLessonBookedDialog(
      {super.key,
      required this.title,
      required this.bookingTime,
      required this.courtId,
      required this.calendarTitle,
      required this.lessonId,
      required this.coachId,
      required this.courtName,
      required this.locationId,
      required this.locationName,
      required this.lessonVariant,
      required this.lessonTime,
      required this.price});

  final DateTime bookingTime;
  final String title;
  final String calendarTitle;
  final double price;
  final String courtName;
  final int courtId;
  final int lessonId;
  final int coachId;
  final int locationId;
  final String locationName;
  final int lessonTime;
  final LessonVariants? lessonVariant;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CourtLessonBookedDialogState();
}

class _CourtLessonBookedDialogState
    extends ConsumerState<CourtLessonBookedDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text("BOOKING_INFORMATION".trU(context),
                style: AppTextStyles.popupHeaderTextStyle),
          ),
          SizedBox(height: 5.h),
          Text(
            "CANCELLATION_POLICY".tr(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.popupBodyTextStyle,
          ),
          SizedBox(height: 20.h),
          BookCourtInfoCardLesson(
            lessonVariant: widget.lessonVariant,
            bookingTime: widget.bookingTime,
            coachName: widget.title,
            duration: widget.lessonTime,
            locationName: widget.locationName,
            title: widget.title,
            courtName: widget.courtName,
            price: widget.price,
            isBooked: true,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              SecondaryImageButton(
                label: 'ADD_TO_CALENDAR'.trU(context),
                isForPopup: true,
                image: AppImages.calendar.path,
                onTap: () {
                  String title =
                      "Booking @ ${widget.title} - ${widget.locationName.capitalizeFirst ?? ''}";
                  DateTime startTime = widget.bookingTime;
                  DateTime endTime = widget.bookingTime
                      .add(Duration(minutes: widget.lessonTime));
                  ref.watch(addToCalendarProvider(
                    title: title,
                    startDate: startTime,
                    endDate: endTime,
                  ));
                },
              ),
              const Spacer(),
              SecondaryImageButton(
                label: "SEE_MY_BOOKINGS".trU(context),
                isForPopup: true,
                image: AppImages.tennisBall.path,
                imageHeight: 13.h,
                imageWidth: 13.h,
                onTap: () {
                  Future(() {
                    ref.read(pageControllerProvider).animateToPage(
                          2,
                          duration: kAnimationDuration,
                          curve: Curves.linear,
                        );
                    ref.read(pageIndexProvider.notifier).index = 2;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
