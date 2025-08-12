import 'dart:developer';

import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/selected_tag.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/book_court_info_card.dart';
import 'package:acepadel/components/custom_textfield.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/court_booking.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/repository/payment_repo.dart';
import 'package:acepadel/screens/home_screen/tabs/booking_tab/court_booked_dialog.dart';
import 'package:acepadel/screens/payment_information/payment_information.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

import '../../../../../components/secondary_text.dart';
import '../../../../../models/court_price_model.dart';
import '../../../../../models/lesson_model_new.dart';
import '../../play_match_tab/play_match_tab.dart';

part 'components.dart';

part 'providers.dart';

class BookCourtDialog extends ConsumerStatefulWidget {
  const BookCourtDialog(
      {super.key,
      required this.bookings,
      required this.bookingTime,
      required this.coachId,
      this.isOnlyOpenMatch = false,
      this.showRefund = false,
      this.courtPriceRequestType,
      required this.court});

  final Bookings bookings;
  final DateTime bookingTime;
  final Map<int, String> court;
  final CourtPriceRequestType? courtPriceRequestType;
  final bool isOnlyOpenMatch;
  final bool showRefund;
  final int? coachId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookCourtDialogState();
}

class _BookCourtDialogState extends ConsumerState<BookCourtDialog> {
  bool isPaid = true;
  late final List<int> courtIdList;




  @override
  void initState() {
    courtIdList = [widget.court.keys.first];

    Future(() {
      if (widget.isOnlyOpenMatch) {
        ref.read(_isOpenMatchProvider.notifier).state = widget.isOnlyOpenMatch;
      } else {
        ref.refresh(_isOpenMatchProvider);
      }
      ref.refresh(_isFriendlyMatchProvider);
      ref.refresh(_isApprovePlayersProvider);
      ref.refresh(_organizerNoteProvider);
      ref.refresh(_matchLevelProvider);
      ref.refresh(_reserveSpotsForMatchProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOpenMatch = ref.watch(_isOpenMatchProvider);
    final reserveSpotsForMatch = ref.watch(_reserveSpotsForMatchProvider);

    // final provider = courtPriceProvider(
    //     serviceId: widget.bookings.id ?? 0,
    //     coachId: widget.coachId,
    //     courtId: [widget.court.keys.first],
    //     durationInMin: widget.bookings.duration ?? 0,
    //     requestType:
    //         widget.courtPriceRequestType ?? CourtPriceRequestType.booking,
    //     dateTime: widget.bookingTime);

    final provider = ref.watch(fetchCourtPriceProvider(
        serviceId: widget.bookings.id ?? 0,
        reserveCounter: reserveSpotsForMatch,
        isOpenMatch: widget.isOnlyOpenMatch,
        coachId: widget.coachId,
        durationInMin: widget.bookings.duration ?? 0,
        courtId: courtIdList,
        requestType:
            widget.courtPriceRequestType ?? CourtPriceRequestType.booking,
        dateTime: widget.bookingTime));

    double price = 0;
    double refundAmount = 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        maxHeight: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "BOOKING_INFORMATION".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            SizedBox(height: 5.h),
            // Text(
            //   "CANCELLATION_POLICY".tr(context),
            //   textAlign: TextAlign.center,
            //   style: AppTextStyles.popupBodyTextStyle,
            // ),
            // SizedBox(height: 20.h),
            // BookCourtInfoCard(
            //     showRefund: widget.showRefund,
            //     refundAmount: (widget.bookings.price ?? 0) - price,
            //     isLoading: isLoading,
            //     bookings: widget.bookings,
            //     bookingTime: widget.bookingTime,
            //     courtName: widget.court.values.first,
            //     price: price),

            provider.when(
              data: (data) {
                String? textPrice;
                double pricePaid = 0;
                int? cancellationHour;

                if (data is String) {
                  if (data.contains("pay your remaining")) {
                    isPaid = true;
                    textPrice = "PRICE".trU(context);
                  } else {
                    isPaid = false;
                    textPrice = "REFUND".trU(context);
                  }
                  data.split(" ").map((e) {
                    if (double.tryParse(e.toString()) != null) {
                      if (isPaid) {
                        price = double.tryParse(e.toString()) ?? 0;
                      } else {
                        price = widget.bookings.price ?? 0;
                        refundAmount = double.tryParse(e.toString()) ?? 0;
                      }
                      textPrice =
                          "$textPrice : ${Utils.formatPrice(isPaid ? price : refundAmount)}";
                    }
                  }).toList();
                } else {
                  CourtPriceModel value = data;
                  final double discountedPrice = value.discountedPrice ?? 0;
                  final double openMatchDiscountedPrice =
                      value.openMatchDiscountedPrice ?? 0;
                  pricePaid = price = ref.read(_isOpenMatchProvider)
                      ? (openMatchDiscountedPrice *
                          (widget.isOnlyOpenMatch
                              ? 1
                              : (reserveSpotsForMatch + 1)))
                      : discountedPrice;

                  cancellationHour = isOpenMatch
                      ? value
                          .cancellationPolicy?.openMatchCancellationTimeInHours
                      : value.cancellationPolicy?.cancellationTimeInHours;
                }
                return Column(
                  children: [
                    if (cancellationHour != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          cancellationHour == 0
                              ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING"
                                  .tr(context)
                              : "CANCELLATION_POLICY_HOURS".tr(context,
                                  params: {
                                      "HOUR": cancellationHour.toString()
                                    }),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.popupBodyTextStyle,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: BookCourtInfoCard(
                        textPrice: textPrice,
                        price: pricePaid,
                        bookings: widget.bookings,
                        bookingTime: widget.bookingTime,
                        courtName: widget.court.values.first,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CupertinoActivityIndicator(
                radius: 10,
                color: AppColors.white,
              ),
              error: (error, stackTrace) {
                return SecondaryText(
                    text: error.toString(), textColor: AppColors.white);
              },
            ),

            if (widget.bookings.isOpenMatch == true) ...[
              SizedBox(height: 20.h),
              if (!widget.isOnlyOpenMatch)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "DO_YOU_WANT_TO_OPEN_THIS_MATCH".tr(context),
                              style: AppTextStyles.balooMedium16.copyWith(
                                color: AppColors.white,
                                height: 1
                              ),
                            ),
                          ),
                          Text(
                            " ${"OPTIONAL".tr(context).toLowerCase()}",
                            style: AppTextStyles.sansRegular15.copyWith(
                              color: AppColors.white,
                            ),
                          )
                        ]
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     text: "DO_YOU_WANT_TO_OPEN_THIS_MATCH".tr(context),
                    //     style: AppTextStyles.sansRegular14.copyWith(
                    //       color: AppColors.white,
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: " ${"OPTIONAL".tr(context)}",
                    //         style: AppTextStyles.gothamLight13.copyWith(
                    //           color: AppColors.white,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 5.h),
                    _selectionRowContainer(
                      text: "OPEN_MATCH_TO_FIND_PLAYERS".tr(context),
                      isSelected: isOpenMatch,
                      onTap: () {
                        ref.read(_isOpenMatchProvider.notifier).state =
                            !isOpenMatch;
                      },
                    ),
                  ],
                ),
              if (isOpenMatch) const _OpenMatch(),
            ],
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "BOOKING_PAYMENT".tr(context),
                style: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            MainButton(
              enabled: price > 0,
              label:
                  isOpenMatch ? "PAY_MY_SHARE".trU(context) : "PAY".trU(context),
              isForPopup: true,
              onTap: () {
                _payCourt(false, isPaid ? price : (price - refundAmount),
                    refundAmount);
              },
            ),
            SizedBox(height: 5.h),
            if (!widget.isOnlyOpenMatch)
              MainButton(
                color: AppColors.white25,
                label: "ADD_TO_CART".trU(context),
                isForPopup: true,
                onTap: () {
                  _payCourt(true, isPaid ? price : (price - refundAmount),
                      refundAmount);
                },
              ),
          ],
        ),
      ),
    );
  }

  _payCourt(bool isAddToCart, double amountPaid, double refundAmount) async {
    final isOpenMatch = ref.read(_isOpenMatchProvider);
    final reservedPlayers = ref.read(_reserveSpotsForMatchProvider);
    final organizerNote = ref.read(_organizerNoteProvider);
    final isFriendlyMatch = ref.read(_isFriendlyMatchProvider);
    final isApprovalNeeded = ref.read(_isApprovePlayersProvider);
    final matchLevel = ref.read(_matchLevelProvider);
    final maxLevel = matchLevel.isNotEmpty ? matchLevel.last : null;
    final minLevel = matchLevel.isNotEmpty ? matchLevel.first : null;

    if (widget.isOnlyOpenMatch) {
      final provider = upgradeBookingToOpenProvider(
        booking: widget.bookings,
        openMatchMinLevel: minLevel,
        openMatchMaxLevel: maxLevel,
        reservedPlayers: isOpenMatch ? reservedPlayers : 1,
        organizerNote: isOpenMatch ? organizerNote : null,
        isFriendlyMatch: isOpenMatch ? isFriendlyMatch : null,
        approvalNeeded: isOpenMatch ? isApprovalNeeded : null,
      );
      final double? serviceId =
          await Utils.showLoadingDialog(context, provider, ref);
      ref.invalidate(getCourtBookingProvider);
      if (serviceId != null && mounted) {
        await showDialog(
          context: context,
          builder: (context) {
            return CourtBookedDialog(
              bookings: widget.bookings,
              bookingTime: widget.bookingTime,
              court: widget.court,
              amountPaid: amountPaid,
              refundAmount: refundAmount,
              isOpenMatch: isOpenMatch,
              serviceID: widget.bookings.id,
            );
          },
        );
      }
      ref.read(goRouterProvider).pop(widget.bookings.id);

      return;
    }

    final provider = bookCourtProvider(
      requestType: isAddToCart
          ? BookingRequestType.addToCart
          : BookingRequestType.processingBooking,
      booking: widget.bookings,
      courtID: widget.court.keys.first,
      dateTime: widget.bookingTime,
      openMatchMinLevel: minLevel,
      openMatchMaxLevel: maxLevel,
      isOpenMatch: isOpenMatch,
      reservedPlayers: isOpenMatch ? reservedPlayers : 1,
      organizerNote: isOpenMatch ? organizerNote : null,
      isFriendlyMatch: isOpenMatch ? isFriendlyMatch : null,
      approvalNeeded: isOpenMatch ? isApprovalNeeded : null,
    );
    final double? price = await Utils.showLoadingDialog(context, provider, ref);

    if (!mounted) {
      return;
    }
    if (isAddToCart) {
      ref.invalidate(getCourtBookingProvider);
      ref.invalidate(fetchBookingCartListProvider);
      ref.read(goRouterProvider).pop();
      return;
    }
    if (price == null) {
      return;
    }
    final time = DateTime.now();

    final data = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
            transactionRequestType: TransactionRequestType.normal,
            serviceID: widget.bookings.id,
            type: PaymentDetailsRequestType.booking,
            locationID: widget.bookings.location!.id!,
            requestType: PaymentProcessRequestType.courtBooking,
            price: price,
            duration: widget.bookings.duration ?? 0,
            startDate: time);
      },
    );
    var (int? serviceID, double? amount) = (null, null);
    if (data is (int, double?)) {
      (serviceID, amount) = data;
    } else if (data is int) {
      serviceID = data;
    }
    ref.refresh(getCourtBookingProvider);
    if (serviceID != null && mounted) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return CourtBookedDialog(
            bookings: widget.bookings,
            amountPaid: amountPaid,
            // amountPaid: (amount ?? 0) > 0 ? amount : null,
            bookingTime: widget.bookingTime,
            court: widget.court,
            isOpenMatch: isOpenMatch,
            serviceID: serviceID,
          );
        },
      );
    }
  }
}

class BookCourtDialogLesson extends ConsumerStatefulWidget {
  const BookCourtDialogLesson(
      {super.key,
      required this.title,
      required this.bookingTime,
      required this.calendarTitle,
      required this.lessonId,
      required this.coachId,
      required this.locationId,
      required this.lessonVariants,
      required this.courts,
      required this.locationName,
      required this.lessonTime});

  final DateTime bookingTime;
  final String title;
  final String calendarTitle;
  final int lessonId;
  final int coachId;
  final int locationId;
  final String locationName;
  final int lessonTime;
  final List<LessonVariants> lessonVariants;
  final List<Courts> courts;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookCourtDialogLessonState();
}

class _BookCourtDialogLessonState extends ConsumerState<BookCourtDialogLesson> {
  late final List<int> courtIdList;
  final _selectedLessonVariantProvider = StateProvider<LessonVariants?>((ref) => null);

  int? courtId ;
  String? courtName ;

  @override
  void initState() {
    if (widget.courts.isNotEmpty) {
      courtId = widget.courts.first.id ?? 0;
      courtName = widget.courts.first.courtName ?? "";
      courtIdList = [courtId ?? 0 ];
    } else {
      courtIdList = [];
    }
    Future(() {
      ref.invalidate(_isOpenMatchProvider);
      ref.invalidate(_isFriendlyMatchProvider);
      ref.invalidate(_isApprovePlayersProvider);
      ref.invalidate(_organizerNoteProvider);
      ref.invalidate(_matchLevelProvider);
      ref.invalidate(_reserveSpotsForMatchProvider);
      if (widget.lessonVariants.isNotEmpty &&
          ref.read(_selectedLessonVariantProvider) == null) {
        ref.read(_selectedLessonVariantProvider.notifier).state =
            widget.lessonVariants.first;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOpenMatch = ref.watch(_isOpenMatchProvider);
    if (widget.courts.isNotEmpty) {
      courtName = widget.courts.first.courtName ?? "";
    }
    final selectedLessonVariant = ref.watch(_selectedLessonVariantProvider);
    // Prevent API call if variant is not yet set
    if (selectedLessonVariant == null) {
      return const SizedBox(); // or loading indicator
    }
    final provider = ref.watch(fetchCourtPriceProvider(
      serviceId: widget.lessonId,
      coachId: null,
      courtId: courtIdList,
      durationInMin: widget.lessonTime,
      requestType: CourtPriceRequestType.lesson,
      dateTime: widget.bookingTime,
      lessonVariant: selectedLessonVariant,
    ));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("BOOKING_INFORMATION".trU(context),
                style: AppTextStyles.popupHeaderTextStyle),
            SizedBox(height: 5.h),
            provider.when(
              data: (data) {
                double pricePaid = 0;
                int? cancellationHour;

                CourtPriceModel value = data;
                final double discountedPrice = value.discountedPrice ?? 0;
                pricePaid = discountedPrice;

                cancellationHour = isOpenMatch
                    ? value.cancellationPolicy?.openMatchCancellationTimeInHours
                    : value.cancellationPolicy?.cancellationTimeInHours;

                return Column(
                  children: [
                    if (cancellationHour != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          cancellationHour == 0
                              ? "YOU_WILL_NOT_GET_REFUND_ON_THIS_BOOKING"
                                  .tr(context)
                              : "CANCELLATION_POLICY_HOURS".tr(context,
                                  params: {
                                      "HOUR": cancellationHour.toString()
                                    }),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.popupBodyTextStyle,
                        ),
                      ),
                    BookCourtInfoCardLesson(
                      bgColor: AppColors.white,
                      bookingTime: widget.bookingTime,
                      title: widget.title,
                      price: pricePaid,
                      duration: widget.lessonTime,
                      coachName: widget.title,
                      courtName: courtName,
                      locationName: widget.locationName,
                    ),
                  ],
                );
              },
              loading: () => const CupertinoActivityIndicator(
                radius: 10,
                color: AppColors.white,
              ),
              error: (error, stackTrace) {
                return SecondaryText(
                    text: error.toString(), textColor: AppColors.white);
              },
            ),
            if (isOpenMatch) const _OpenMatch(),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "NUMBER_OF_PAX".trU(context),
                style: AppTextStyles.balooMedium15.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: widget.lessonVariants.map((e) {
                final isSelected = selectedLessonVariant.id == e.id;
                return InkWell(
                  onTap: () {
                    ref.read(_selectedLessonVariantProvider.notifier).state = e;
                  },
                  child: Container(
                    width: 70.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: isSelected ? AppColors.yellow : AppColors.yellow50,
                    ),
                    child: Text(
                      (e.maximumCapacity ?? 0).toString(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.balooMedium13.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "BOOKING_PAYMENT".trU(context),
                style: AppTextStyles.balooMedium15.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            MainButton(
              label: "PAY".tr(context),
              isForPopup: true,
              onTap: () async {
                await _payCourt(false, selectedLessonVariant);
              },
            ),
            /*SizedBox(height: 10.h),
              MainButton(
                label: "ADD_TO_CART".tr(context),
                color: AppColors.loyalBlue5,
                onTap: () async {
                  await _payCourt(true);
                },
              ),*/
          ],
        ),
      ),
    );
  }

  Future<void> _payCourt(
      bool isAddToCart, LessonVariants? selectedLessonVariant) async {
    try {
      final provider = bookLessonCourtProvider(
        lessonVariant: selectedLessonVariant,
        // requestType: isAddToCart
        //     ? BookingRequestType.addToCart
        //     : BookingRequestType.processingBooking,
        lessonTime: widget.lessonTime,
        coachId: widget.coachId,
        lessonId: widget.lessonId,
        courtId: courtId ?? 0,
        locationId: widget.locationId,
        dateTime: widget.bookingTime,
      );
      final price = await Utils.showLoadingDialog(context, provider, ref);
      if (price == null || price is String || !mounted) return;
      final data = await showDialog(
        context: context,
        builder: (context) => PaymentInformation(
            transactionRequestType: TransactionRequestType.normal,
            type: PaymentDetailsRequestType.lesson,
            locationID: widget.locationId,
            requestType: PaymentProcessRequestType.courtBooking,
            price: price,
            serviceID: widget.lessonId,
            duration: widget.lessonTime,
            startDate: widget.bookingTime),
      );
      var (int? serviceID, double? amount) = (null, null);
      if (data is (int, double?)) {
        (serviceID, amount) = data;
      } else if (data is int) {
        serviceID = data;
      }
      if (serviceID != null && mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CourtLessonBookedDialog(
            lessonVariant: selectedLessonVariant,
            courtName: courtName ?? "",
            price: price,
            locationName: widget.locationName,
            courtId: courtId ?? 0,
            calendarTitle: widget.calendarTitle,
            coachId: widget.coachId,
            lessonId: widget.lessonId,
            lessonTime: widget.lessonTime,
            locationId: widget.locationId,
            bookingTime: widget.bookingTime,
            title: widget.title,
            // isOpenMatch: true,
          ),
        );
      }

      /*if (serviceID != null && mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => BookCourtInfoCardLesson(
            // price: 100f,
            bookingTime: widget.bookingTime,
            title: widget.title,
            price: price,
            duration: widget.lessonTime,
            coachName: widget.title,
            courtName: courtName,
            locationName: widget.locationName,
          ),
        );
      }*/
    } catch (e) {
      myPrint(e.toString());
    }
  }
}
