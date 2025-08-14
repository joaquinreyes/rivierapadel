part of 'booking_tab.dart';

class _DateSelectorWidget extends ConsumerStatefulWidget {
  const _DateSelectorWidget({required this.futureDayLength});

  final int futureDayLength;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends ConsumerState<_DateSelectorWidget> {


  DateTime nowTime = DateTime.now();
  DateTime? endTime;

  @override
  void initState() {
    endTime = nowTime.add(Duration(days: widget.futureDayLength));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.futureDayLength < 1) {
      return const SizedBox();
    }

    final selectedIndex = ref.watch(_selectedTabIndex);
    // final selectedDate = ref.watch(selectedDateProvider);
    final isCourtSelected = selectedIndex == 0;

    if (!isCourtSelected && endTime != null) {
      final fetchBlockedCoaches = ref.watch(fetchBlockedCoachesProvider(
          startDate: nowTime, endDate: endTime!, sportName: "Padel"));

      return fetchBlockedCoaches.when(
          data: (data) {
            return _dateBuilder(data);
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => _dateBuilder([]));
    }
    return _dateBuilder([]);
  }


  Widget _dateBuilder(List<String> blockCoaches) {
    final selectedIndex = ref.watch(_selectedTabIndex);

    final isCourtSelected = selectedIndex == 0;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final selectedDate = isCourtSelected
        ? ref.watch(selectedDateProvider)
        : ref.watch(selectedDateLessonProvider);
    return Container(
      height: (width / height) > 0.6 ? 110.h : 71.h,
      margin: EdgeInsets.only(left: 6.w, top: 15.h, bottom: 7.h, right: 6.w),
      padding: EdgeInsets.only(left: 0.w, right: 0),
      child: _buildDateListView(context, selectedDate.dateTime, blockCoaches),
    );
  }


  Widget _buildDateListView(BuildContext context, DateTime selectedDate, List<String> blockCoaches) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.futureDayLength,
        itemBuilder: (context, i) {
          DateTime now = DubaiDateTime.now().dateTime;
          DateTime date =
              DubaiDateTime.custom(now.year, now.month, now.day + i).dateTime;
          return _getDateContainer(date, selectedDate, blockCoaches);
        },
      ),
    );
  }

  Widget _getDateContainer(
      DateTime date, DateTime selectedDate, List<String> blockCoaches) {
    bool isSelected = date.isAtSameMomentAs(selectedDate);

    bool isBlocked = blockCoaches.contains(date.format("yyyy-MM-dd"));
    final backgroundColor = isSelected
        ? isBlocked
        ? AppColors.darkGreen25
        : AppColors.darkBlue
        : isBlocked
        ? AppColors.darkGreen5
        : AppColors.darkGreen5;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _onDateTap(date),
        child: Container(
          height: 60.w,
          width: 50.w,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: _buildDateContent(date, isSelected,isBlocked),
        ),
      ),
    );
  }

  void _onDateTap(DateTime date) {
    ref.read(_selectedTabIndex) == 0
        ? ref.read(selectedDateProvider.notifier).selectedDate =
            DubaiDateTime.custom(
            date.year,
            date.month,
            date.day,
          )
        : ref.read(selectedDateLessonProvider.notifier).selectedDate =
            DubaiDateTime.custom(
            date.year,
            date.month,
            date.day,
          );

    Future(() {
      ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
      // ref.invalidate(getCourtBookingProvider);
    });
  }

  Widget _buildDateContent(DateTime date, bool isSelected, bool isBlocked) {
    final textColor = isSelected
        ? AppColors.white
        : isBlocked
        ? AppColors.darkBlue.withOpacity(0.70)
        : AppColors.darkBlue.withOpacity(0.70);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5.h),
        Text(
          date.format(DateFormat.ABBR_WEEKDAY),
          style: AppTextStyles.sansRegular15.copyWith(
            // color: AppColors.white,
            color: textColor,
          ),
        ),
        Text(
          '${date.day}',
          style: AppTextStyles.sansMedium15.copyWith(
            color: textColor,
              height: 1,
          ),
        ),
        Text(
          date.format(DateFormat.ABBR_MONTH),
          style: AppTextStyles.sansRegular15.copyWith(
            color: textColor,
            height: 1,
          ),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}

class _Sport extends ConsumerWidget {
  const _Sport(
      {required this.sportToShow,
      required this.index,
      required this.onTap,
      required this.isServiceSelected});

  final int index;
  final ClubLocationSports sportToShow;
  final Function onTap;
  final bool isServiceSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DurationAndSportContainer(
      isSelected: isServiceSelected,
      text: sportToShow.sportName ?? '',
      radius: 100.r,
      onTap: () {
        onTap();
      },
      // onTap: () {
      //   ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
      //   ref.read(selectedSportProvider.notifier).sport = sportToShow;
      // },
    );
  }
}

class _Duration extends ConsumerWidget {
  const _Duration({required this.duration, required this.index});

  final int index;
  final int duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDuration = ref.watch(_selectedDuration);
    bool isServiceSelected = (selectedDuration == duration);
    return _DurationAndSportContainer(
      isSelected: isServiceSelected,
      radius: 100.r,
      text: "$duration min",
      onTap: () {
        ref.read(_selectedDuration.notifier).state = duration;
        ref.read(_pageViewController.notifier).state.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
      },
    );
  }
}

class _DurationAndSportContainer extends StatelessWidget {
  const _DurationAndSportContainer(
      {required this.isSelected, required this.text, required this.onTap,this.radius});

  final bool isSelected;
  final Function() onTap;
  final String text;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.h),
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(radius ?? 5.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isSelected
              ? AppTextStyles.sansMedium14.copyWith(color: Colors.white,height: 1)
              : AppTextStyles.sansRegular13.copyWith(color: AppColors.clay70,height: 1),
        ),
      ),
    );
  }
}

class _Timeslots extends ConsumerStatefulWidget {
  const _Timeslots({required this.data, required this.locationID});

  final CourtBookingData data;
  final int locationID;

  @override
  ConsumerState<_Timeslots> createState() => __TimeslotsState();
}

class __TimeslotsState extends ConsumerState<_Timeslots> {
  @override
  Widget build(BuildContext context) {
    final selectedDuration = ref.watch(_selectedDuration);
    final selectedDate = ref.watch(selectedDateProvider);

    if (selectedDuration == null) {
      return Container();
    }

    final timeSlots = widget.data.getTimeSlots(
        selectedDuration, widget.locationID, selectedDate.dateTime);

    if (timeSlots.isEmpty) {
      return _buildNoAvailableSlotsMessage(context);
    }

    List<List<DateTime>> timeSlotChunked = Utils.getChunks(timeSlots, 4);

    return _buildTimeSlots(timeSlotChunked);
  }

  Widget _buildNoAvailableSlotsMessage(BuildContext context) {
    return Container(
      height: 100.h,
      alignment: Alignment.center,
      child: SecondaryText(
        text: "NO_AVAILABLE_SLOTS".trU(context),
      ),
    );
  }

  Widget _buildTimeSlots(List<List<DateTime>> timeSlotChunked) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < timeSlotChunked.length; i++)
          _buildTimeSlotRow(timeSlotChunked, i),
      ],
    );
  }

  Widget _buildTimeSlotRow(List<List<DateTime>> timeSlotChunked, int rowIndex) {
    bool addExtra = rowIndex == timeSlotChunked.length - 1 &&
        timeSlotChunked[rowIndex].length < 4;
    List<Widget> extraSlots = addExtra
        ? List.generate(4 - timeSlotChunked[rowIndex].length,
            (_) => Expanded(child: Container()))
        : [];

    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            height: 40.w,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                for (int colIndex = 0;
                    colIndex < timeSlotChunked[rowIndex].length;
                    colIndex++)
                  _buildTimeSlot(timeSlotChunked, rowIndex, colIndex),
                ...extraSlots,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(
      List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
    final (selectedTime, selectedLocationID) =
        ref.watch(_selectedTimeSlotAndLocationID);
    bool selected = selectedTime == timeSlotChunked[rowIndex][colIndex] &&
        selectedLocationID == widget.locationID;
    BorderRadius? borderRadius =
        _getBorderRadius(rowIndex, colIndex, timeSlotChunked);

    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          // padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.oak : AppColors.white,
            boxShadow: const [kBoxShadow],
            borderRadius: borderRadius,
          ),
          child: Text(
            timeSlotChunked[rowIndex][colIndex].format("h:mm a").toLowerCase(),
            style: selected ? AppTextStyles.sansMedium15.copyWith(color: AppColors.white) : AppTextStyles.sansRegular15,
          ),
        ),
      ),
    );
  }

  BorderRadius? _getBorderRadius(
      int rowIndex, int colIndex, List<List<DateTime>> timeSlotChunked) {
    return BorderRadius.all(
      Radius.circular(12.r),
    );
  }

  void _onTap(
      List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
    final selectedSlot = ref.read(_selectedTimeSlotAndLocationID);
    if (selectedSlot.$1 == timeSlotChunked[rowIndex][colIndex] &&
        selectedSlot.$2 == widget.locationID) {
      ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
      return;
    }
    ref.read(_selectedTimeSlotAndLocationID.notifier).state =
        (timeSlotChunked[rowIndex][colIndex], widget.locationID);
  }
}

class _AvailableTimeslot extends ConsumerStatefulWidget {
  const _AvailableTimeslot({required this.data, required this.locationID});

  final CourtBookingData data;
  final int locationID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __AvailableTimeslotState();
}

class __AvailableTimeslotState extends ConsumerState<_AvailableTimeslot> {
  @override
  Widget build(BuildContext context) {
    final selectedDuration = ref.watch(_selectedDuration);
    final (timeslot, locationID) = ref.watch(_selectedTimeSlotAndLocationID);
    final selectedDate = ref.watch(selectedDateProvider);
    if (selectedDuration == null || timeslot == null || locationID == null) {
      return Container();
    }
    if (widget.locationID != locationID) {
      return Container();
    }
    final courts = widget.data.getCourt(
        selectedDuration, locationID, timeslot, selectedDate.dateTime);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final startTime = timeslot;
        final endTime = startTime.add(Duration(minutes: selectedDuration));
        final String formattedTime =
            "${startTime.format("EEE d MMM")} | ${startTime.format("h:mm")} - ${endTime.format("h:mm a").toLowerCase()}";
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h, left: 10.w),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courts.values.toList()[index],
                          style: AppTextStyles.sansMedium15,
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Text(
                            formattedTime,
                            style: AppTextStyles.sansRegular15.copyWith(height: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  MainButton(
                    color: Colors.white,
                    showArrow: true,
                    applyShadow: true,
                    height: 35.h,
                    width: 85.w,
                    padding: EdgeInsets.only(left: 7.w,right: 7.w),
                    label: "BOOK".tr(context),
                    labelStyle: AppTextStyles.balooMedium14,
                    onTap: () async {
                      final booking = widget.data.getBooking(
                          selectedDate.dateTime,
                          timeslot,
                          locationID,
                          selectedDuration,
                          courts.keys.toList()[index]);
                      if (booking == null) {
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BookCourtDialog(
                            coachId: null,
                            bookings: booking,
                            bookingTime: DubaiDateTime.custom(
                              selectedDate.dateTime.year,
                              selectedDate.dateTime.month,
                              selectedDate.dateTime.day,
                              startTime.hour,
                              startTime.minute,
                            ).dateTime,
                            court: {
                              courts.keys.toList()[index]:
                                  courts.values.toList()[index]
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            if (index != courts.length - 1) ...[
              const SizedBox(height: 10),
              Container(
                height: 0.7.h,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                color: AppColors.darkGreen5,
              ),
            ]
          ],
        );
      },
    );
  }
}

class _Selector extends ConsumerWidget {
  const _Selector({required this.title, required this.index});

  final int index;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedTabIndex);
    bool isServiceSelected = (selectedIndex == index);
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(_selectedTabIndex.notifier).state = index;
          ref.read(_pageControllerFor.notifier).state.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
          if (index == 1) {
            ref.invalidate(fetchAllCoachesProvider);
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          height: 44.h,
          clipBehavior: Clip.none,
          // padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isServiceSelected ? AppColors.darkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          alignment: Alignment.center,
          child: Text(title,
              textAlign: TextAlign.center,
              style: isServiceSelected ? AppTextStyles.balooMedium17.copyWith(
                color: AppColors.white,
              ): AppTextStyles.balooMedium15.copyWith(color: AppColors.clay70)),
        ),
      ),
    );
  }
}

class _CoachDurationList extends ConsumerWidget {
  const _CoachDurationList({required this.lessonVariants, required this.index});

  final int index;
  final LessonVariants lessonVariants;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = lessonVariants.duration;
    if (duration == null) {
      return const SizedBox();
    }

    final selectedLessonType = ref.watch(_selectedCoachLessonDuration);
    bool isServiceSelected =
        (selectedLessonType?.duration == lessonVariants.duration);
    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        onTap: () {
          ref.read(_selectedCoachLessonDuration.notifier).state =
              lessonVariants;
        },
        child: Container(
          margin: EdgeInsets.all(4.h),
          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: isServiceSelected ? AppColors.darkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(5.r),
          ),
          alignment: Alignment.center,
          child: Text("${lessonVariants.duration ?? 0} ${"MINS".tr(context)}",
              textAlign: TextAlign.center,
              style: AppTextStyles.gothamRegular12.copyWith(
                fontWeight:
                    isServiceSelected ? FontWeight.w400 : FontWeight.w300,
                color:
                    isServiceSelected ? AppColors.white : AppColors.darkGreen70,
              )),
        ),
      ),
    );
  }
}

class _TimeslotsLesson extends ConsumerStatefulWidget {
  const _TimeslotsLesson({
    required this.data,
    required this.coachId,
    required this.selectedDate,
  });

  final LessonDataNew0? data;

  final DateTime? selectedDate;
  final int coachId;

  @override
  ConsumerState<_TimeslotsLesson> createState() => __TimeslotsLessonState();
}

class __TimeslotsLessonState extends ConsumerState<_TimeslotsLesson> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateLessonProvider);
    final selectedDuration = ref.watch(_selectedCoachLessonDuration);
    final List<DateTime> timeSlots = widget.data?.getTimeSlots(widget.coachId,
            widget.selectedDate ?? selectedDate.dateTime, selectedDuration) ??
        [];

    if (timeSlots.isEmpty) {
      return _buildNoAvailableSlotsMessage(context);
    }

    List<List<DateTime>> timeSlotChunked = Utils.getChunks(timeSlots, 4);

    return _buildTimeSlots(timeSlotChunked);
  }

  Widget _buildNoAvailableSlotsMessage(BuildContext context) {
    return Container(
      height: 100.h,
      alignment: Alignment.center,
      child: SecondaryText(text: "NO_AVAILABLE_SLOTS".trU(context)),
    );
  }

  Widget _buildTimeSlots(List<List<DateTime>> timeSlotChunked) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < timeSlotChunked.length; i++)
          _buildTimeSlotRow(timeSlotChunked, i),
      ],
    );
  }

  Widget _buildTimeSlotRow(List<List<DateTime>> timeSlotChunked, int rowIndex) {
    bool addExtra = rowIndex == timeSlotChunked.length - 1 &&
        timeSlotChunked[rowIndex].length < 4;
    List<Widget> extraSlots = addExtra
        ? List.generate(4 - timeSlotChunked[rowIndex].length,
            (_) => Expanded(child: Container()))
        : [];

    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            height: 40.w,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                for (int colIndex = 0;
                    colIndex < timeSlotChunked[rowIndex].length;
                    colIndex++)
                  _buildTimeSlot(timeSlotChunked, rowIndex, colIndex),
                ...extraSlots,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(
    List<List<DateTime>> timeSlotChunked,
    int rowIndex,
    int colIndex,
  ) {
    final (selectedTime, selectedLocationID) =
        ref.watch(_selectedTimeSlotAndLocationID);
    bool selected = selectedTime == timeSlotChunked[rowIndex][colIndex] &&
        selectedLocationID == widget.coachId;
    BorderRadius? borderRadius =
        _getBorderRadius(rowIndex, colIndex, timeSlotChunked);

    return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.oak : AppColors.white,
            boxShadow: const [kBoxShadow],
            borderRadius: borderRadius,
          ),
          child: Text(
            timeSlotChunked[rowIndex][colIndex]
                .format(DateFormat.HOUR24_MINUTE),
            style: AppTextStyles.gothamLight13
                .copyWith(color: AppColors.darkGreen),
          ),
        ),
      ),
    );
    /*return Expanded(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onTap: () => _onTap(timeSlotChunked, rowIndex, colIndex),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.richGreen60 : AppColors.white,
            boxShadow: const [kBoxShadow],
            borderRadius: borderRadius,
          ),
          child: Text(
            timeSlotChunked[rowIndex][colIndex].format(DateFormat.HOUR_MINUTE),
            style: selected
          ? AppTextStyles.poppinsSemiBold13.copyWith(color: Colors.white)
                : AppTextStyles.poppinsRegular14,
          ),
        ),
      ),
    );*/
  }

  BorderRadius? _getBorderRadius(
      int rowIndex, int colIndex, List<List<DateTime>> timeSlotChunked) {
    return BorderRadius.circular(7.r);
    // BorderRadius? borderRadius;
    // if (rowIndex == 0 && colIndex == 0) {
    //   borderRadius = BorderRadius.only(topLeft: Radius.circular(15.r));
    // }
    // if (rowIndex == 0 && colIndex == 3) {
    //   borderRadius = BorderRadius.only(topRight: Radius.circular(15.r));
    // }
    // if (rowIndex == timeSlotChunked.length - 1 && colIndex == 0) {
    //   borderRadius = BorderRadius.only(bottomLeft: Radius.circular(15.r));
    // }
    // if (rowIndex == timeSlotChunked.length - 1 && colIndex == 3) {
    //   borderRadius = BorderRadius.only(bottomRight: Radius.circular(15.r));
    // }
    // return borderRadius;
  }

  void _onTap(
      List<List<DateTime>> timeSlotChunked, int rowIndex, int colIndex) {
    final selectedSlot = ref.read(_selectedTimeSlotAndLocationID);
    if (selectedSlot.$1 == timeSlotChunked[rowIndex][colIndex] &&
        selectedSlot.$2 == widget.coachId) {
      ref.read(_selectedTimeSlotAndLocationID.notifier).state = (null, null);
      return;
    }
    ref.read(_selectedTimeSlotAndLocationID.notifier).state =
        (timeSlotChunked[rowIndex][colIndex], widget.coachId);
  }
}

class _AvailableTimeslotLesson extends ConsumerStatefulWidget {
  const _AvailableTimeslotLesson({
    this.title,
    required this.calenderTitle,
    required this.coachId,
    required this.locationId,
    required this.selectedDate,
    required this.data,
    // required this.locationID,
  });

  final LessonDataNew0? data;
  final String? title;
  final String calenderTitle;
  final int coachId;
  final int locationId;
  final DateTime? selectedDate;

  // final locationID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __AvailableTimeslotLessonState();
}

class __AvailableTimeslotLessonState
    extends ConsumerState<_AvailableTimeslotLesson> {
  @override
  Widget build(BuildContext context) {
    final selectedLessonVariant = ref.watch(_selectedCoachLessonDuration);
    final (timeslot, coachId) = ref.watch(_selectedTimeSlotAndLocationID);
    final selectedDate = ref.watch(selectedDateLessonProvider);
    if (selectedLessonVariant == null || timeslot == null || coachId == null) {
      return Container();
    }
    if (widget.selectedDate != null) {
      if (widget.selectedDate!.day != timeslot.day ||
          widget.selectedDate!.month != timeslot.month) {
        return const SizedBox();
      }
    }
    if (widget.coachId != coachId) {
      return const SizedBox();
    }
    final selectedLessonType = ref.watch(_selectedCoachLessonDuration);

    final Map<int, String> lessons = widget.data?.getLessons(
            selectedLessonVariant,
            coachId,
            timeslot,
            widget.selectedDate ?? selectedDate.dateTime) ??
        {};

    return Column(
      children: List.generate(
        lessons.length,
        (index) {
          final startTime = timeslot;
          final endTime = startTime
              .add(Duration(minutes: selectedLessonType?.duration ?? 30));
          final String formattedTime =
              "${startTime.format("EEE d MMM")} | ${startTime.format("h:mm")} - ${endTime.format("h:mm a")}";
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lessons.values.toList()[index],
                            style: AppTextStyles.gothamRegular14
                                .copyWith(color: AppColors.darkGreen),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            formattedTime,
                            style: AppTextStyles.gothamLight13
                                .copyWith(color: AppColors.darkGreen),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    MainButton(
                      color: Colors.white,
                      showArrow: true,
                      applyShadow: true,
                      height: 35.h,
                      width: 105.w,
                      label: "BOOK".tr(context),
                      labelStyle: AppTextStyles.balooMedium10.copyWith(
                        color: AppColors.darkGreen,
                      ),
                      onTap: () async {
                        final AvailableSlots? booking = widget.data?.getBooking(
                          // widget.selectedDate ?? selectedDate.dateTime,
                          // timeslot,
                          coachId,
                          // lessons.keys.toList()[index]
                        );
                        if (booking == null) {
                          return;
                        }

                        final lessonVariants =
                        booking.getLessonVariantsByMaxCapacity(
                            selectedLessonVariant,lessons.keys.toList()[index]);

                        if (lessonVariants.isEmpty) {
                          return;
                        }

                        final bookingTime =  DubaiDateTime.custom(
                          (widget.selectedDate ?? selectedDate.dateTime)
                              .year,
                          (widget.selectedDate ?? selectedDate.dateTime)
                              .month,
                          (widget.selectedDate ?? selectedDate.dateTime)
                              .day,
                          startTime.hour,
                          startTime.minute,
                        ).dateTime;

                        final courts =
                        booking.getCourts(lessons.keys.toList()[index],bookingTime,selectedLessonVariant);


                        myPrint("COURTS: ${courts.length}");
                        
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BookCourtDialogLesson(
                              courts: courts,
                              lessonVariants: lessonVariants,
                              title: widget.title ?? "",
                              calendarTitle: widget.calenderTitle,
                              lessonId: lessons.keys.toList()[index],
                              // lessonId: widget.lessonId,
                              coachId: widget.coachId,
                              locationId: widget.locationId,
                              locationName:
                                  booking.location?.locationName ?? "",
                              lessonTime: selectedLessonType?.duration ?? 30,
                              bookingTime: bookingTime,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (lessons.length - 1 != index) ...[
                SizedBox(height: 3.h),
                Divider(height: 2, color: Colors.grey.shade400),
              ]
            ],
          );
        },
      ),
    );
  }
}

class _VoucherCardWidget extends StatelessWidget {
  final VoucherModel voucher;
  final Function onTap;

  const _VoucherCardWidget({required this.voucher, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final credits = (voucher.value ?? 0).toStringAsFixed(2);
    final price = (voucher.price ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.oak35,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$credits ${"CREDITS".tr(context)}",
            style:
                AppTextStyles.balooMedium14.copyWith(height: 1),
          ),
          SizedBox(height: 9.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${"PRICE".tr(context)} ${Utils.formatPrice(price)}",
                style: AppTextStyles.sansMedium14.copyWith(height: 1),
              ),
              SizedBox(width: 20.w),
              MainButton(
                  width: 65.w,
                  height: 25.h,
                  padding: EdgeInsets.zero,
                  onTap: () {
                    onTap();
                  },
                  color: AppColors.white,
                  borderRadius: 8.r,
                  labelStyle: AppTextStyles.balooMedium15,
                  label: 'BUY'.tr(context))
            ],
          )
        ],
      ),
    );
  }
}

class _VoucherConfirmDialog extends StatelessWidget {
  final VoucherModel voucher;

  const _VoucherConfirmDialog({required this.voucher});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'VOUCHER_INFORMATION'.trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            "VOUCHER_DESCRIPTION".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            padding: EdgeInsets.all(15.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${"GET".tr(context)} ${voucher.value} ${"CREDITS".tr(context).toLowerCase()}",
                    style: AppTextStyles.balooMedium16),
                CDivider(color: AppColors.clay05,),
                Text(
                    "${"PRICE".tr(context)} ${Utils.formatPrice(voucher.price ?? 0)}",
                    style: AppTextStyles.sansRegular15),
              ],
            ),
          ),
          SizedBox(height: 41.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              width: double.infinity,
              child: MainButton(
                isForPopup: true,
                onTap: () {
                  Navigator.pop(context, true);
                },
                label: "PAY_VOUCHER".trU(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FilterRow extends ConsumerWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDateLessonSelected = ref.watch(_dateBookableLesson);
    final fetchAllCoaches = ref.watch(fetchAllCoachesProvider);
    final dateRangeLesson = ref.watch(_dateLessonsRangeProvider);
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    final allLocations = ref.watch(clubLocationsProvider);
    final selectedLocation = ref.watch(_selectedLessonsLocationProvider);
    final getCoachName = () {
      if (selectedLessonCoachId.length > 1) {
        return "MULTIPLE_COACHES".tr(context);
      }

      if (selectedLessonCoachId.isEmpty) {
        return "ALL_COACHES".tr(context);
      }

      final coachId = selectedLessonCoachId.first;
      final coach = fetchAllCoaches.value?.firstWhere(
        (c) => c.id == coachId,
        orElse: () => CoachListModel(fullName: ""),
      );

      return coach?.fullName?.isNotEmpty == true
          ? coach!.fullName ?? "ALL_COACHES".tr(context)
          : "ALL_COACHES".tr(context);
    }();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(children: [
        Image.asset(
          AppImages.filterIcon.path,
          height: 15.h,
          width: 15.h,
        ),

        SizedBox(width: 8.w),
        Expanded(
          child: allLocations.when(
            data: (data) {
              if (data == null) {
                return const SizedBox();
              }
              final list = data;
              if (list.first.id != kAllLocation.id) {
                list.insert(0, kAllLocation);
              }
              final coachesList = Utils.fetchLocationCoaches(data);
              if (coachesList.first.id != kAllCoaches.id) {
                coachesList.insert(0, kAllCoaches);
              }
              return Row(
                children: [
                  Expanded(
                      child: _buildFilterItem(
                        label: (selectedLocation.locationName ?? 'All Locations')
                            .capitalizeFirst,
                        allowArrow: isDateLessonSelected,
                        onTap: () {
                          if (isDateLessonSelected) {
                            final Widget widget =
                            _buildLocationSelector(ref, context, list);
                            if (PlatformC().isCurrentDesignPlatformDesktop) {
                              showDialog(
                                  context: context, builder: (context) => widget);
                              return;
                            }
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => widget);
                          }
                        },
                      )),
                ],
              );
            },
            error: (_, __) => Container(),
            loading: () => Container(),
          ),
        ),
        SizedBox(width: 8.w),
        if (isDateLessonSelected) ...[
          Expanded(
              child: _buildFilterItem(
            label: getCoachName.capitalizeFirst,
            onTap: () {
              final Widget widget = Consumer(
                builder: (context, ref, _) {
                  return _buildCoachSelector(
                      ref, context, fetchAllCoaches.value ?? []);
                },
              );
              if (PlatformC().isCurrentDesignPlatformDesktop) {
                showDialog(context: context, builder: (context) => widget);
                return;
              }
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => widget);
            },
          )),
          SizedBox(width: 4.w)
        ],
        if (!isDateLessonSelected) ...[
          Expanded(
            flex: 2,
            child: _buildFilterItem(
              label:
                  "${dateRangeLesson.startDate!.format('dd')} - ${dateRangeLesson.endDate!.format('dd MMM')}",
              onTap: () {
                final Widget widget =
                    _buildDateRangeSelector(ref, context, dateRangeLesson);
                if (PlatformC().isCurrentDesignPlatformDesktop) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return widget;
                    },
                  );
                  return;
                }
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return widget;
                  },
                );
              },
            ),
          ),
          SizedBox(width: 4.w),
        ],

      ]),
    );
  }

  Widget _buildLocationSelector(
      WidgetRef ref, BuildContext context, List<ClubLocationData> locations) {
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    return _bottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'LOCATION'.trU(context),
            style: AppTextStyles.balooMedium19,
          ),
          SizedBox(height: 15.h),
          Flexible(
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: locations.length,
                padding: EdgeInsets.only(bottom: 10.h),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: OptionTile(
                      option: (location.locationName ?? "").capitalizeFirst,
                      enabled: true,
                      selected: location.id ==
                          ref.read(_selectedLessonsLocationProvider).id,
                      onTap: () {
                        ref
                            .read(_selectedLessonsLocationProvider.notifier)
                            .state = location;
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(
      WidgetRef ref, BuildContext context, PickerDateRange range) {
    DateRangePickerController dateController = DateRangePickerController();

    return _bottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'DATE'.trU(context),
            style: AppTextStyles.balooMedium19,
          ),
          SizedBox(height: 10.h),
          SfDateRangePickerTheme(
            data: const SfDateRangePickerThemeData().copyWith(
                headerTextStyle: AppTextStyles.balooMedium18.copyWith(
                  color: AppColors.darkBlue,
                ),
                viewHeaderTextStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
                disabledDatesTextStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
                todayTextStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
                todayHighlightColor: AppColors.darkBlue,
                headerBackgroundColor: Colors.transparent),
            child: SfDateRangePicker(
              todayHighlightColor: AppColors.clay70,
              controller: dateController,
              selectionMode: DateRangePickerSelectionMode.range,
              selectionShape: DateRangePickerSelectionShape.circle,
              initialSelectedRange: range,
              enablePastDates: false,
              endRangeSelectionColor: AppColors.darkBlue,
              startRangeSelectionColor: AppColors.darkBlue,
              rangeSelectionColor: AppColors.darkBlue.withOpacity(0.25),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              selectionTextStyle: AppTextStyles.balooMedium20.copyWith(
                color: AppColors.white,
              ),
              rangeTextStyle: AppTextStyles.balooMedium20.copyWith(
                color: AppColors.white,
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                dayFormat: "E",
                viewHeaderHeight: 52.h,
                firstDayOfWeek: 1,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: AppTextStyles.gothamRegular14.copyWith(
                    color: AppColors.clay70,
                  ),
                ),
              ),
              headerHeight: 52.h,
              yearCellStyle: DateRangePickerYearCellStyle(
                todayTextStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
                disabledDatesTextStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
                textStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
                leadingDatesTextStyle: AppTextStyles.balooMedium20.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                final range = args.value as PickerDateRange;
                if (range.startDate != null && range.endDate != null) {
                  ref.read(_dateLessonsRangeProvider.notifier).state = range;
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet({required Widget child, required BuildContext context}) {
    bool isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    if (isDesktop) {
      return CustomDialog(height: 550.h, child: child);
    }
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 440.h),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                kBoxShadow,
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: child,
          ),
          Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close,
                      color: AppColors.darkGreen, size: 16)))
        ],
      ),
    );
  }

  Widget _buildCoachSelector(
      WidgetRef ref, BuildContext context, List<CoachListModel> coaches) {
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    return _bottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'COACHES'.trU(context),
            style: AppTextStyles.balooMedium19,
          ),
          SizedBox(height: 5.h),
          Flexible(
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: OptionTile(
                        option: (kLessonsAllCoaches.locationName ?? "")
                            .toUpperCase()
                            .tr(context),
                        enabled: true,
                        selected: selectedLessonCoachId.isEmpty,
                        onTap: () {
                          ref.read(_selectedLessonCoachId.notifier).state = [];
                        },
                      ),
                    ),
                    ListView.builder(
                      itemCount: coaches.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        final isSelected =
                            selectedLessonCoachId.contains(coach.id ?? 0);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: OptionTile(
                            option: (coach.fullName ?? "").capitalizeFirst,
                            enabled: true,
                            selected: isSelected,
                            onTap: () {
                              final value = [...selectedLessonCoachId];

                              if (isSelected) {
                                value.remove(coach.id ?? 0);
                              } else {
                                value.add(coach.id ?? 0);
                              }
                              ref.read(_selectedLessonCoachId.notifier).state =
                                  value;
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterItem({
    required String label,
    required Function() onTap,
    bool allowArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        decoration: inset.BoxDecoration(
          boxShadow: kInsetShadow,
          color: AppColors.clay05,
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.gothamRegular12,
              ),
            ),
            if (allowArrow)
              Image.asset(
                AppImages.dropdownIcon.path,
                height: 16.h,
                width: 16.h,
              )
          ],
        ),
      ),
    );
  }
}

class _CoachSelection extends ConsumerWidget {
  const _CoachSelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final selectedLessonCoachId = ref.watch(_selectedLessonCoachId);
    final fetchAllCoaches = ref.watch(fetchAllCoachesProvider);

    return fetchAllCoaches.when(
      data: (data) {
        if (data.isEmpty) {
          return SecondaryText(text: "NO_COACH_FOUND".tr(context));
        }
        return Container(
          height: (width / height) > 0.6 ? 110.h : 71.h,
          margin:
              EdgeInsets.only(left: 6.w, top: 15.h, bottom: 7.h, right: 6.w),
          padding: EdgeInsets.only(left: 5.w, right: 0),
          child:
              _buildCoachesListView(ref, context, selectedLessonCoachId, data),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, _) => SecondaryText(text: error.toString()),
    );
  }

  Widget _buildCoachesListView(WidgetRef ref, BuildContext context,
      List<int> selectedCoach, List<CoachListModel> coachList) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coachList.length,
        itemBuilder: (context, i) {
          final slot = coachList[i];
          return _getDateContainer(ref, slot, selectedCoach);
        },
      ),
    );
  }

  Widget _getDateContainer(
      WidgetRef ref, CoachListModel slots, List<int> selectedCoach) {
    bool isSelected = selectedCoach.contains(slots.id ?? 0);

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => _onDateTap(ref, slots),
        child: Container(
          height: 60.h,
          width: 80.w,
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.darkBlue : AppColors.darkGreen5,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: _buildCoachContent(slots, isSelected),
        ),
      ),
    );
  }

  void _onDateTap(WidgetRef ref, CoachListModel coach) {
    ref.read(_selectedLessonCoachId.notifier).state = [coach.id ?? 0];
    final fetchAllCoaches = (ref.read(fetchAllCoachesProvider).value ?? [])
        .where((e) => e.id == coach.id);
    if (fetchAllCoaches.isNotEmpty) {
      ref.read(_selectedLessonsLocationProvider.notifier).state =
          ClubLocationData(
              id: fetchAllCoaches.first.location?.id ?? -1,
              locationName: fetchAllCoaches.first.location?.locationName ??
                  "All Locations");
    }
  }

  Widget _buildCoachContent(CoachListModel coach, bool isSelected) {
    final coachName = coach.fullName ?? "";
    final coachProfile = coach.profileUrl ?? "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5.h),
        NetworkCircleImage(
          path: coachProfile,
          width: 28.w,
          height: 28.w,
          reservedLogo: !isSelected,
          boxBorder: Border.all(color: AppColors.white25),
          scale: 1,
        ),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            coachName,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sansRegular12.copyWith(
                color: isSelected ? Colors.white : AppColors.darkGreen),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
