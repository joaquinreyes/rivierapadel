import 'dart:async';
import 'dart:ui';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/models/voucher_model.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/play_match_tab.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/notification_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/club_locations.dart';
import 'package:acepadel/models/court_booking.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/repository/location_repo.dart';
import 'package:acepadel/screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/utils/dubai_date_time.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../components/custom_dialog.dart';
import '../../../../components/network_circle_image.dart';
import '../../../../globals/current_platform.dart';
import '../../../../models/coach_list_model.dart';
import '../../../../models/lesson_model_new.dart';
import '../../../../repository/booking_repo.dart';
import '../../../../repository/payment_repo.dart';
import '../../../../repository/play_repo.dart';
import '../../../payment_information/payment_information.dart';
import 'package:syncfusion_flutter_core/theme.dart'
    show SfDateRangePickerTheme, SfDateRangePickerThemeData;

part 'booking_tab_components.dart';

part 'booking_tab_provider.dart';

class BookingTab extends ConsumerStatefulWidget {
  const BookingTab({super.key});

  @override
  ConsumerState<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends ConsumerState<BookingTab> {
  List<ClubLocationSports> sports = [];

  @override
  void initState() {
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
      ref.refresh(_selectedDuration);
      ref.refresh(_selectedTimeSlotAndLocationID);
      ref.refresh(_pageViewController);
      ref.refresh(selectedSportProvider);
      ref.refresh(selectedSportLessonProvider);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(_selectedTabIndex, (previous, next) {
      if (next != previous) {
        Future(() {
          ref.read(_pageControllerFor.notifier).state.animateToPage(
                next,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
        });
      }
    });

    final data = ref.watch(clubLocationsProvider);
    final pageController = ref.watch(_pageControllerFor);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(getCourtBookingProvider.future),
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Row(
            children: [
              24.horizontalSpace,
              Text("AVAILABLE_COURTS".trU(context),
              style: AppTextStyles.balooMedium22.copyWith(height: 1),),
              // Container(
              //   alignment: AlignmentDirectional.centerStart,
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   child: Image.asset(
              //     AppImages.logoHorizontal.path,
              //     width: 100.w,
              //     height: 50.w,
              //   ),
              // ),
              const Spacer(),
              const NotificationButton(),
              SizedBox(width: 30.w),
            ],
          ),
          // SizedBox(height: 2.5.h),
          // _viewSelectRow(),
          // SizedBox(height: 10.h),
          Expanded(
              child: data.when(
            data: (data) {
              if (data == null) {
                return const Center(
                    child: SecondaryText(text: "Unable to get Locations."));
              }
              Future(() {
                sports = [...Utils.fetchSportsList(data)];
                if (ref.read(selectedSportProvider.notifier).sport == null) {
                  ref.read(selectedSportProvider.notifier).sport = sports.first;
                }
                if (ref.read(selectedSportLessonProvider.notifier).sport ==
                    null) {
                  ref.read(selectedSportLessonProvider.notifier).sport =
                      sports.first;
                }
              });
              return _slotsView(data, pageController);
              // return _bookingBody(data);
            },
            error: (error, stackTrace) => SecondaryText(text: error.toString()),
            loading: () {
              return const CupertinoActivityIndicator(radius: 10);
            },
          )),
        ],
      ),
    );
  }

  Widget _slotsView(
      List<ClubLocationData> locationsData, PageController pageController) {
    final lessonSelected = ref.watch(_selectedTabIndex) != 0;
    final isDateLessonSelected = ref.watch(_dateBookableLesson);

    return Column(
      children: [
        Row(
          children: [
            if (lessonSelected) _coachDateSelector(),
            Expanded(
              child: !isDateLessonSelected && lessonSelected
                  ? const _CoachSelection()
                  : _DateSelectorWidget(
                      futureDayLength: Utils.getFutureDateLength(
                          locationsData, getSportsName(ref))),
            ),
          ],
        ),
        // SizedBox(height: 4.h),
        Expanded(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _bookingBody(locationsData),
              _lessonsBody(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lessonsBody() {
    return const SingleChildScrollView(
      child: LessonsList(),
    );

    final selectedSport = ref.watch(selectedSportLessonProvider);
    return LayoutBuilder(
      builder: (context, constraint) {
        final sportList = [...sports];
        sportList.removeWhere(
            (e) => (e.sportName ?? "").toLowerCase() == "recovery");
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: Column(
              children: [
                _sportsRow(sportList, selectedSport,
                    (ClubLocationSports sport) {
                  ref.read(_selectedTimeSlotAndLocationID.notifier).state =
                      (null, null);

                  ref.read(selectedSportLessonProvider.notifier).sport = sport;
                }),
                SizedBox(height: 5.h),
                ExpandablePageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ref.watch(_pageViewController),
                  children: const [LessonsList()],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _viewSelectRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(1.5.h),
      constraints: kComponentWidthConstraint,
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          _Selector(title: 'COURTS'.trU(context), index: 0),
          _Selector(title: "COACHES".trU(context), index: 1),
        ],
      ),
    );
  }

  Widget _bookingBody(List<ClubLocationData> locationsData) {
    final courtBookings = ref.watch(getCourtBookingProvider);
    final sport = ref.watch(selectedSportProvider);
    final futureDateLength =
        Utils.getFutureDateLength(locationsData, sport?.sportName ?? '');
    _invalidateDateIfBeyondFutureLimit(futureDateLength);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _sportsRow(sports, sport, (ClubLocationSports sport) {
            ref.read(_selectedTimeSlotAndLocationID.notifier).state =
                (null, null);
            ref.read(selectedSportProvider.notifier).sport = sport;
          }), // remove
          SizedBox(height: 2.h),
          courtBookings.when(
            data: (data) {
              if (data == null) {
                return SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context));
              }
              return Column(
                children: [
                  _body(locationsData, data),
                ],
              );
            },
            error: (error, stackTrace) => SecondaryText(text: error.toString()),
            loading: () {
              return const CupertinoActivityIndicator(radius: 10);
            },
          ),
        ],
      ),
    );
  }

  Widget _body(List<ClubLocationData> locationsData, CourtBookingData data) {
    final selectedDate = ref.watch(selectedDateProvider);
    final vouchers = ref.watch(getVouchersApiProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _serviceRow(data),
        SizedBox(height: 17.h),
        vouchers.when(
          data: (data) {
            if (data.isEmpty) {
              return const SizedBox();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    "BUY_CREDIT_VOUCHERS".trU(context),
                    style: AppTextStyles.balooMedium17
                        .copyWith(height: 1),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                SingleChildScrollView(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data
                        .map((e) => Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: _VoucherCardWidget(
                                  voucher: e,
                                  onTap: () async {
                                    final data = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return _VoucherConfirmDialog(
                                          voucher: e,
                                        );
                                      },
                                    );
                                    if (data == null) {
                                      return;
                                    }
                                    if (data is bool &&
                                        data &&
                                        context.mounted &&
                                        mounted) {
                                      final value = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return PaymentInformation(
                                              transactionRequestType:
                                                  TransactionRequestType.cart,
                                              isVoucherPurchase: true,
                                              type: PaymentDetailsRequestType
                                                  .booking,
                                              locationID: e.locationId ?? 0,
                                              price: e.price ?? 0,
                                              requestType:
                                                  PaymentProcessRequestType
                                                      .join,
                                              serviceID: e.id,
                                              allowMembership: false,
                                              allowPayLater: false,
                                              allowCoupon: false,
                                              allowWallet: false,
                                              duration: null,
                                              startDate: null);
                                        },
                                      );
                                      if (value is bool &&
                                          value &&
                                          context.mounted &&
                                          mounted) {
                                        Utils.showMessageDialog(
                                          context,
                                          "YOU_HAVE_BUY_VOUCHER_SUCCESSFULLY"
                                              .tr(context),
                                        );
                                      }
                                    }
                                  }),
                            ))
                        .toList(),
                  ),
                )
              ],
            );
          },
          error: (error, stackTrace) => SecondaryText(text: error.toString()),
          loading: () {
            return const CupertinoActivityIndicator(radius: 10);
          },
        ),
        SizedBox(height: 15.h),
        ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: ref.watch(_pageViewController),
          children: data.durationsToShow
              .map((duration) => _locationsAndTimeSlots(
                  data, duration, selectedDate, locationsData))
              .toList(),
        ),
        // ExpandablePageView(
        //   physics: const NeverScrollableScrollPhysics(),
        //   controller: pageController,
        //   children: [
        //     for (int duration in data.durationsToShow)
        //       _locationsAndTimeSlots(
        //         data,
        //         duration,
        //         selectedDate,
        //         locationsData,
        //       ),
        //   ],
        // ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _locationsAndTimeSlots(CourtBookingData data, int? selectedDuration,
      DubaiDateTime selectedDate, List<ClubLocationData> locationsData) {
    final userLoc = ref.watch(fetchLocationProvider).asData?.value;
    if (data.isAllTimeSlotsEmpty(
        selectedDuration ?? 0, selectedDate.dateTime)) {
      return SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context));
    }
    return ListView.builder(
      itemCount: data.locations.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final timeSlots = data.getTimeSlots(selectedDuration ?? 0,
            data.locations[index], selectedDate.dateTime);
        if (timeSlots.isEmpty) {
          return const SizedBox();
        }

        final int locationIndex = locationsData
            .indexWhere((element) => element.id == data.locations[index]);
        if (locationIndex == -1) {
          return const SizedBox();
        }
        final ClubLocationData location = locationsData[locationIndex];
        final locationName = location.locationName?.capitalizeFirst ?? '';

        final distance =
            location.getLocationRadius(userLoc?.latitude, userLoc?.longitude);
        return Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: _serviceTimeSlotsBackgroundContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        locationName.toUpperCase(),
                        style: AppTextStyles.balooMedium15.copyWith(height: 1,),
                      ),
                    ),
                    // const Spacer(),
                    8.horizontalSpace,
                    Text(
                      distance,
                      style: AppTextStyles.sansRegular15.copyWith(
                        color: AppColors.clay70,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _Timeslots(data: data, locationID: data.locations[index]),
                _AvailableTimeslot(
                  data: data,
                  locationID: data.locations[index],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sportsRow(List<ClubLocationSports> sports,
      ClubLocationSports? selectedSport, Function(ClubLocationSports) onTap) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (int i = 0; i < sports.length; i++)
          Expanded(
              child: _Sport(
                  sportToShow: sports[i],
                  index: i,
                  isServiceSelected: selectedSport == sports[i],
                  onTap: () {
                    onTap(sports[i]);
                  })),
      ],
    );
  }

  Widget _coachDateSelector() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      height: (width / height) > 0.6 ? 110.h : 71.h,
      margin: EdgeInsets.only(left: 6.w, top: 15.h, bottom: 7.h),
      padding: EdgeInsets.only(left: 5.w, right: 0),
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dateAndCoach(text: "DATE".tr(context), value: true),
          _dateAndCoach(text: "COACH".tr(context), value: false),
        ],
      ),
    );
  }

  Widget _dateAndCoach({required String text, required bool value}) {
    final isDateLessonSelected = ref.watch(_dateBookableLesson) == value;
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      onTap: () {
        if (value) {
          ref.read(_selectedLessonCoachId.notifier).state = [];
        } else {
          final fetchAllCoaches =
              ref.watch(fetchAllCoachesProvider).value ?? [];

          final selectedLessonCoachId = ref.read(_selectedLessonCoachId);

          if (selectedLessonCoachId.length == fetchAllCoaches.length ||
              selectedLessonCoachId.length > 1 ||
              selectedLessonCoachId.isEmpty) {
            if (fetchAllCoaches.isNotEmpty) {
              ref.read(_selectedLessonCoachId.notifier).state = [
                (fetchAllCoaches.first.id ?? 0)
              ];

              ref.read(_selectedLessonsLocationProvider.notifier).state =
                  ClubLocationData(
                      id: fetchAllCoaches.first.location?.id ?? -1,
                      locationName:
                          fetchAllCoaches.first.location?.locationName ??
                              "All Locations");
            }
          }
        }
        ref.read(_dateBookableLesson.notifier).state = value;
      },
      child: Container(
        margin: EdgeInsets.all(4.h),
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
          color: isDateLessonSelected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(5.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isDateLessonSelected
              ? AppTextStyles.gothamRegular12
                  .copyWith(color: AppColors.darkGreen)
              : AppTextStyles.gothamLight12,
        ),
      ),
    );
  }

  Widget _serviceRow(CourtBookingData data) {
    int? currentDuration = ref.read(_selectedDuration);
    Future(() {
      if (currentDuration != null &&
          data.durationsToShow.contains(currentDuration)) {
        ref.read(_selectedDuration.notifier).state = currentDuration;
      } else {
        ref.read(_selectedDuration.notifier).state = data.durationsToShow.first;
      }
    });
    return _sportsAndServiceBackgroundContainer(
      child: Row(
        children: [
          for (int i = 0; i < data.durationsToShow.length; i++)
            Expanded(
                child: _Duration(duration: data.durationsToShow[i], index: i)),
        ],
      ),
    );
  }

  Widget _sportsAndServiceBackgroundContainer({Widget? child}) {
    return Container(
      height: 38.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
      constraints: kComponentWidthConstraint,
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        color: AppColors.clay05,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: child,
    );
  }

  Container _serviceTimeSlotsBackgroundContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,15.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.clay05,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  void _invalidateDateIfBeyondFutureLimit(int futureDateLength) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DubaiDateTime.now();
    final difference =
        selectedDate.dateTime.difference(today.dateTime).inDays + 1;
    if (difference >= futureDateLength) {
      Future(() {
        ref.invalidate(selectedDateProvider);
      });
    }
  }
}

class LessonsList extends ConsumerStatefulWidget {
  const LessonsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonState();
}

class _LessonState extends ConsumerState<LessonsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(selectedDateLessonProvider);
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    final isDateLessonSelected = ref.watch(_dateBookableLesson);
    final dateLessonsRangeProvider = ref.watch(_dateLessonsRangeProvider);
    final startDate = dateLessonsRangeProvider.startDate!;
    final endDate = dateLessonsRangeProvider.endDate!;
    final lessons = ref.watch(lessonsSlotProvider(
        startTime: !isDateLessonSelected ? startDate : date.dateTime,
        sportName: "padel",
        // sportName: selectedSport?.sportName ?? "padel",
        endTime: !isDateLessonSelected ? endDate : null,
        coachId: selectedLessonCoachId,
        duration: null));
    return Column(
      children: [
        _lessonDurationList(),
        SizedBox(height: 10.h),
        const _FilterRow(),
        SizedBox(height: 24.h),
        lessons.when(
          skipLoadingOnRefresh: false,
          data: (data) {
            if (data.data?.availableSlots?.isEmpty ?? true) {
              return SecondaryText(text: "NO_AVAILABLE_SLOTS".tr(context));
            }
            final lessonVariants = ref.watch(_lessonVariantList);
            LessonVariants? lessonVariant =
                ref.watch(_selectedCoachLessonDuration);
            if (lessonVariants.isEmpty) {
              Future(() {
                ref.read(_lessonVariantList.notifier).state =
                    data.durationsToShow;
              });
            }

            if (lessonVariant != null) {
              if (lessonVariants
                      .indexWhere((e) => e.duration == lessonVariant.id) !=
                  -1) {
                Future(() {
                  ref.read(_selectedCoachLessonDuration.notifier).state =
                      lessonVariant;
                });
              }
            } else {
              if (lessonVariants.isNotEmpty) {
                Future(() {
                  ref.read(_selectedCoachLessonDuration.notifier).state =
                      lessonVariants.first;
                });
              }
            }

            final selectedCoach = ref.watch(_selectedLessonCoachId);
            final dateBookableSelected = ref.watch(_dateBookableLesson);

            final selectedLocation =
                ref.watch(_selectedLessonsLocationProvider);

            final availableSlots = data.data?.getAvailableSlotsByLocation(
                    selectedCoach, dateBookableSelected, selectedLocation) ??
                [];

            List<DateTime> days = [];
            for (DateTime date = startDate;
                !date.isAfter(endDate);
                date = date.add(const Duration(days: 1))) {
              days.add(date);
            }

            return Column(
              children: [
                availableSlots.isNotEmpty
                    ? !dateBookableSelected
                        ? Column(
                            children: days.map((date) {
                              final cardData = availableSlots.first;
                              return _coachCard(cardData, data,
                                  selectedDate: date);
                            }).toList(),
                          )
                        : ListView.builder(
                            itemCount: availableSlots.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final cardData = availableSlots[index];
                              return _coachCard(cardData, data);
                            },
                          )
                    : SecondaryText(text: "NO_AVAILABLE_SLOTS".tr(context))
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => SecondaryText(text: error.toString()),
        ),
      ],
    );
  }

  Widget _coachCard(AvailableSlots cardData, LessonModelNew data,
      {DateTime? selectedDate}) {
    final dateBookableSelected = ref.watch(_dateBookableLesson);

    final selectedDateTemp = ref.watch(selectedDateLessonProvider);
    final selectedDuration = ref.watch(_selectedCoachLessonDuration);
    final List<DateTime> timeSlots = data.data?.getTimeSlots(cardData.id ?? 0,
        selectedDate ?? selectedDateTemp.dateTime, selectedDuration) ??
        [];

    if (timeSlots.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: _serviceTimeSlotsBackgroundContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!dateBookableSelected)
                  Text(
                    selectedDate != null
                        ? DateFormat('EEE d MMM').format(selectedDate)
                        : cardData.getDateCourt(selectedDuration),
                    style: AppTextStyles.gothamBold14
                        .copyWith(color: AppColors.darkGreen),
                  ),
                Row(
                  children: [
                    if ((cardData.profileUrl ?? "").isNotEmpty) ...[
                      CircleAvatar(
                        radius: 15.sp,
                        foregroundImage: NetworkImage(
                          cardData.profileUrl ?? "",
                        ),
                      ),
                      SizedBox(width: 8.w)
                    ],
                    Text(
                      cardData.fullName?.capitalizeFirst ?? "",
                      style: AppTextStyles.balooBold9
                          .copyWith(color: AppColors.darkGreen),
                    ),
                  ],
                ),
                if (dateBookableSelected)
                  InkWell(
                    onTap: () {
                      if ((cardData.profileUrl ?? "").isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CoachDetailsDialog(data: cardData);
                          },
                        );
                      }
                    },
                    child: Text(
                      "INFO".tr(context),
                      style: AppTextStyles.gothamLight13.copyWith(
                        color: AppColors.darkGreen70,
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 10.h),
            _TimeslotsLesson(
              selectedDate: selectedDate,
              data: data.data,
              coachId: cardData.id ?? (-1),
            ),
            SizedBox(height: 7.h),
            _AvailableTimeslotLesson(
              selectedDate: selectedDate,
              data: data.data,
              calenderTitle:
                  "${cardData.fullName ?? ""} ${cardData.location?.locationName}",
              title: cardData.fullName ?? "",
              coachId: cardData.id ?? 0,
              locationId: cardData.location?.id ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  // Container _lessonListCoach(LessonModelNew data) {
  //   int? selectedLessonId = ref.read(_selectedLessonId);
  //   Future(() {
  //     if (selectedLessonId != null) {
  //       if (data.durationsToShow
  //               .indexWhere((e) => e.id == selectedLessonId) !=
  //           -1) {
  //         ref.read(_selectedLessonId.notifier).state =
  //             selectedLessonId;
  //       }
  //     } else {
  //       if (data.durationsToShow.isNotEmpty) {
  //         ref.read(_selectedLessonId.notifier).state =
  //             data.durationsToShow.first.id;
  //       }
  //     }
  //   });
  //
  //   final listLessonTypes = data.durationsToShow;
  //
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 15.w),
  //     constraints: kComponentWidthConstraint,
  //     decoration: inset.BoxDecoration(
  //       boxShadow: kInsetShadow,
  //       borderRadius: BorderRadius.circular(5.r),
  //     ),
  //     child: Row(
  //       children: [
  //         for (int i = 0; i < listLessonTypes.length; i++)
  //           _LessonListCoach(lessonType: listLessonTypes[i], index: i),
  //       ],
  //     ),
  //   );
  // }
  Container _lessonDurationList() {
    // LessonVariants? lessonVariant = ref.read(_selectedCoachLessonDuration);
    // Future(() {
    //   if (lessonVariant != null) {
    //     if (data.durationsToShow
    //             .indexWhere((e) => e.duration == lessonVariant.id) !=
    //         -1) {
    //       ref.read(_selectedCoachLessonDuration.notifier).state = lessonVariant;
    //     }
    //   } else {
    //     if (data.durationsToShow.isNotEmpty) {
    //       ref.read(_selectedCoachLessonDuration.notifier).state =
    //           data.durationsToShow.first;
    //     }
    //   }
    // });
    //
    final listLessonTypes = ref.watch(_lessonVariantList);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          for (int i = 0; i < listLessonTypes.length; i++)
            _CoachDurationList(lessonVariants: listLessonTypes[i], index: i),
        ],
      ),
    );
  }

  // Container _coachDurationList(LessonModelNew data) {
  //   int? currentLessonDuration = ref.read(_selectedLessonBookingType);
  //   Future(() {
  //     if (currentLessonDuration != null) {
  //       if (data.durationsToShow
  //               .indexWhere((e) => e.duration == currentLessonDuration) !=
  //           -1) {
  //         ref.read(_selectedLessonBookingType.notifier).state =
  //             currentLessonDuration;
  //       }
  //     } else {
  //       if (data.durationsToShow.isNotEmpty) {
  //         ref.read(_selectedLessonBookingType.notifier).state =
  //             data.durationsToShow.first.duration;
  //       }
  //     }
  //   });
  //
  //   final listLessonTypes = data.durationsToShow;
  //
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 15.w),
  //     constraints: kComponentWidthConstraint,
  //     decoration: inset.BoxDecoration(
  //       boxShadow: kInsetShadow,
  //       borderRadius: BorderRadius.circular(5.r),
  //     ),
  //     child: Row(
  //       children: [
  //         for (int i = 0; i < listLessonTypes.length; i++)
  //           _LessonBookingType(lessonType: listLessonTypes[i], index: i),
  //       ],
  //     ),
  //   );
  // }

  Container _serviceTimeSlotsBackgroundContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.darkGreen5,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: child,
    );
  }
}

class CoachDetailsDialog extends StatelessWidget {
  const CoachDetailsDialog({super.key, required this.data});

  final AvailableSlots? data;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 90.h,
              width: 90.h,
              child: CircleAvatar(
                foregroundImage: NetworkImage(
                  data?.profileUrl ?? "",
                ),
              )),
          SizedBox(height: 15.h),
          Text(
            '${'COACH'.trU(context)} ${data?.fullName?.trU(context)}',
            textAlign: TextAlign.center,
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          SizedBox(height: 15.h),
          Text(
            data?.description ?? "",
            textAlign: TextAlign.center,
            style: AppTextStyles.popupBodyTextStyle,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
