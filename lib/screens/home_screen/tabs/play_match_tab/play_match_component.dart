part of 'play_match_tab.dart';

class _ViewSelector extends ConsumerWidget {
  const _ViewSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedTabIndex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: inset.BoxDecoration(
          boxShadow: kInsetShadow, color: AppColors.darkGreen5),
      child: Row(
        children: [
          _ViewSelectorComponent(
              isSelected: selectedIndex == 0,
              title: '${'OPEN'.trU(context)} ${'MATCHES'.trU(context)}',
              ref: ref,
              value: 0),
          _ViewSelectorComponent(
              isSelected: selectedIndex == 1,
              title: "EVENTS".trU(context),
              ref: ref,
              value: 1),
          _ViewSelectorComponent(
              isSelected: selectedIndex == 2,
              title: "LESSONS".trU(context),
              ref: ref,
              value: 2),
        ],
      ),
    );
  }
}

class _ViewSelectorComponent extends StatelessWidget {
  final bool isSelected;
  final String title;
  final WidgetRef ref;
  final int value;

  const _ViewSelectorComponent(
      {required this.isSelected,
      required this.title,
      required this.ref,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? AppColors.darkBlue : Colors.transparent),
        child: GestureDetector(
          onTap: () {
            if (!isSelected) {
              ref.read(_selectedTabIndex.notifier).state = value;
            }
          },
          child: Text(
            title,
            style: isSelected
                ? AppTextStyles.balooBold14
                    .copyWith(height: 0.95, color: AppColors.white)
                : AppTextStyles.balooBold13
                    .copyWith(height: 0.95, color: AppColors.darkGreen70),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _FilterRow extends ConsumerWidget {
  _FilterRow();

  DateRangePickerController dateController = DateRangePickerController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelRange = ref.watch(_selectedLevelProvider);
    final dateRange = ref.watch(_dateRangeProvider);
    final selectedLocation = ref.watch(_selectedLocationProvider);
    final allLocations = ref.watch(clubLocationsProvider);
    final selectedIndex = ref.watch(_selectedTabIndex);
    final selectedCoach = ref.watch(_selectedCoachesProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Image.asset(
            AppImages.filterIcon.path,
            height: 15.h,
            width: 15.w,
          ),
          SizedBox(width: 8.w),
          if (selectedIndex == 0) ...[
            Expanded(
              flex: 2,
              child: _buildFilterItem(
                label:
                    "${levelRange.first.toStringAsFixed(1)} - ${levelRange.last.toStringAsFixed(1)}",
                onTap: () {
                  final Widget widget =
                      _buildLevelSelector(context, levelRange);
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
            // const Spacer(),
            SizedBox(width: 4.w),
          ],

          Expanded(
            flex: 2,
            child: _buildFilterItem(
              label:
                  "${dateRange.startDate!.format('dd')} - ${dateRange.endDate!.format('dd MMM')}",
              onTap: () {
                final Widget widget =
                    _buildDateRangeSelector(ref, context, dateRange);
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
          // const Spacer(),
          SizedBox(width: 4.w),
          Expanded(
            flex: selectedIndex == 2 ? 4 : 2,
            child: allLocations.when(
              data: (data) {
                if (data == null) {
                  return Container();
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
                      onTap: () {
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
                      },
                    )),
                    if (selectedIndex == 2) SizedBox(width: 5.w),
                    if (selectedIndex == 2)
                      Expanded(
                          child: _buildFilterItem(
                        label: (selectedCoach.fullName ?? 'All Coaches')
                            .capitalizeFirst,
                        onTap: () {
                          final Widget widget =
                              _buildCoachSelector(ref, context, coachesList);
                          if (PlatformC().isCurrentDesignPlatformDesktop) {
                            showDialog(
                                context: context, builder: (context) => widget);
                            return;
                          }
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => widget);
                        },
                      )),
                  ],
                );
              },
              error: (_, __) => Container(),
              loading: () => Container(),
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFilterItem({
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25.r),
      child: Container(
        decoration: inset.BoxDecoration(
          boxShadow: kInsetShadow,
          color: AppColors.darkGreen5,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.gothamRegular12,
              ),
            ),
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

  Widget _buildDateRangeSelector(
      WidgetRef ref, BuildContext context, PickerDateRange range) {
    return _bottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 22.h),
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
            style: AppTextStyles.balooBold15,
          ),
          SizedBox(height: 20.h),
          SfDateRangePickerTheme(
            data: const SfDateRangePickerThemeData().copyWith(
                headerTextStyle: AppTextStyles.balooBold16.copyWith(
                  color: AppColors.darkGreen,
                ),
                viewHeaderTextStyle: AppTextStyles.balooBold18.copyWith(
                  color: AppColors.darkGreen,
                ),
                disabledDatesTextStyle: AppTextStyles.balooBold14.copyWith(
                  color: AppColors.darkGreen,
                ),
                todayTextStyle: AppTextStyles.balooBold14.copyWith(
                  color: AppColors.darkGreen,
                ),
                todayHighlightColor: AppColors.green5,
                headerBackgroundColor: Colors.transparent),
            child: SfDateRangePicker(
              todayHighlightColor: AppColors.green25,
              controller: dateController,
              selectionMode: DateRangePickerSelectionMode.range,
              selectionShape: DateRangePickerSelectionShape.circle,
              initialSelectedRange: range,
              enablePastDates: false,
              endRangeSelectionColor: AppColors.darkBlue,
              startRangeSelectionColor: AppColors.darkBlue,
              rangeSelectionColor: AppColors.green25,
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: AppTextStyles.balooBold14.copyWith(
                  color: AppColors.darkGreen,
                ),
              ),
              selectionTextStyle: AppTextStyles.balooBold14.copyWith(
                color: AppColors.white,
              ),
              rangeTextStyle: AppTextStyles.balooBold14.copyWith(
                color: AppColors.white,
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                dayFormat: "E",
                viewHeaderHeight: 52.h,
                firstDayOfWeek: 1,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: AppTextStyles.gothamRegular16.copyWith(
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              headerHeight: 52.h,
              yearCellStyle: DateRangePickerYearCellStyle(
                todayTextStyle: AppTextStyles.balooBold16.copyWith(
                  color: AppColors.darkGreen,
                ),
                disabledDatesTextStyle: AppTextStyles.balooBold16.copyWith(
                  color: AppColors.darkGreen,
                ),
                textStyle: AppTextStyles.balooBold16.copyWith(
                  color: AppColors.darkGreen,
                ),
                leadingDatesTextStyle: AppTextStyles.balooBold16.copyWith(
                  color: AppColors.darkGreen,
                ),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                final range = args.value as PickerDateRange;
                if (range.startDate != null && range.endDate != null) {
                  ref.read(_dateRangeProvider.notifier).state = range;
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector(BuildContext context, List<double> levelRange) {
    return _bottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 22.h),
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
            'LEVEL'.trU(context),
            style: AppTextStyles.balooBold15,
          ),
          SizedBox(height: 20.h),
          const _LevelListForSelection()
        ],
      ),
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
          SizedBox(height: 22.h),
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
            style: AppTextStyles.balooBold15,
          ),
          SizedBox(height: 20.h),
          Flexible(
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: locations.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: OptionTile(
                      option: (location.locationName ?? "").capitalizeFirst,
                      enabled: true,
                      selected:
                          location.id == ref.read(_selectedLocationProvider).id,
                      onTap: () {
                        ref.read(_selectedLocationProvider.notifier).state =
                            location;
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

  Widget _buildCoachSelector(
      WidgetRef ref, BuildContext context, List<ServiceDetail_Coach> coaches) {
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    return _bottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 22.h),
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
            style: AppTextStyles.balooBold15,
          ),
          SizedBox(height: 20.h),
          Flexible(
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: ListView.builder(
                itemCount: coaches.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final location = coaches[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: OptionTile(
                      option: (location.fullName ?? "").capitalizeFirst,
                      enabled: true,
                      selected:
                          location.id == ref.read(_selectedCoachesProvider).id,
                      onTap: () {
                        ref.read(_selectedCoachesProvider.notifier).state =
                            location;
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
}

class _LevelListForSelection extends ConsumerStatefulWidget {
  const _LevelListForSelection();

  @override
  ConsumerState<_LevelListForSelection> createState() =>
      _LevelListForSelectionState();
}

class _LevelListForSelectionState
    extends ConsumerState<_LevelListForSelection> {
  List<double> currentLevel = [];

  List<double> newLevel = [];

  @override
  Widget build(BuildContext context) {
    final currentLevel = ref.watch(_selectedLevelProvider);
    final isDesktop = PlatformC().isCurrentDesignPlatformDesktop;
    return Flexible(
      child: Scrollbar(
        thumbVisibility: isDesktop,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h),
          itemCount: levelsList.length,
          itemBuilder: (context, index) {
            final level = levelsList[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: OptionTile(
                option: "${"LEVEL".tr(context)} $level",
                enabled: true,
                selected: newLevel.isEmpty
                    ? level >= currentLevel.first && level <= currentLevel.last
                    : newLevel.contains(level),
                onTap: () {
                  if (newLevel.isEmpty) {
                    newLevel = [level];
                  } else if (newLevel.length == 1) {
                    newLevel.add(level);
                    newLevel.sort();
                    ref.read(_selectedLevelProvider.notifier).state = newLevel;
                    Navigator.pop(context);
                  }
                  setState(() {});
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    required this.enabled,
  });

  final String option;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: enabled ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AppColors.darkBlue : AppColors.green5,
            borderRadius: BorderRadius.circular(5.r),
          ),
          padding: EdgeInsets.all(10.h),
          child: Row(
            children: [
              SelectedTag(
                isSelected: selected,
              ),
              SizedBox(width: 20.w),
              Expanded(
                flex: 10,
                child: Text((option),
                    style: AppTextStyles.balooMedium13.copyWith(
                        color:
                            selected ? AppColors.white : AppColors.darkGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
