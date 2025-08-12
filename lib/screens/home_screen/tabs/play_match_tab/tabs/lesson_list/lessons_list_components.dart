part of 'lessons_list.dart';

class _LessonDatesVisibilityToggle extends StatelessWidget {
  final bool isDatesVisible;
  final VoidCallback onTap;

  const _LessonDatesVisibilityToggle({
    required this.isDatesVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDatesVisible
                    ? "HIDE_DATES".tr(context)
                    : "SHOW_DATES".tr(context),
                style: AppTextStyles.gothamLight12
                    .copyWith(color: AppColors.darkGreen),
              ),
              SizedBox(width: 4.w),
              Icon(
                isDatesVisible ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16.sp,
                color: AppColors.darkGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonDatesListView extends StatelessWidget {
  final List<LessonServices>? services;

  final Function(int) onTap;
  final LessonsModel lesson;

  const _LessonDatesListView({
    required this.services,
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: services?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        bool check = true;
        try {
          if (lesson.selectedCoach != null) {
            check = (lesson.coaches).any((e) => e.id == lesson.selectedCoach);
          }
        } catch (e) {
          myPrint(e.toString());
        }
        return check
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const CDivider(),
              )
            : const SizedBox();
      },
      itemBuilder: (context, index) {
        final serviceBooking = services![index].serviceBookings?.first;
        if (lesson.selectedCoach != null) {
          final check =
              (lesson.coaches).any((e) => e.id == lesson.selectedCoach);
          if (!check) {
            return const SizedBox();
          }
        }
        final maximumCapacity = serviceBooking?.maximumCapacity ?? 0;
        final minimumCapacity = serviceBooking?.minimumCapacity ?? 0;
        return _LessonDateItem(
          serviceBooking: serviceBooking,
          maxCapacity: maximumCapacity,
          minCapacity: minimumCapacity,
          isEnabled: isEnabled(serviceBooking?.players?.length ?? 0,
              maximumCapacity, minimumCapacity),
          onTap: () {
            onTap(index);
          },
        );
      },
    );
  }

  bool isEnabled(int playersCount, int maximumCapacity, int minimumCapacity) {
    final maxCapacity = maximumCapacity;
    final minCapacity = minimumCapacity;
    if (maxCapacity == 0) {
      return false;
    }
    if (playersCount >= maxCapacity) {
      return false;
    } else if (playersCount >= minCapacity) {
      return true;
    } else {
      return true;
    }
  }
}

class _LessonCoachesListView extends StatelessWidget {
  final LessonsModel lesson;

  final Function(int?) onChangeSelectedCoach;
  const _LessonCoachesListView({
    required this.lesson,
    required this.onChangeSelectedCoach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      height: 110.h,
      decoration: inset.BoxDecoration(
        boxShadow: kInsetShadow,
        borderRadius: BorderRadius.circular(25.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: ListView.separated(
        itemCount: Utils.fetchLessonCoaches(lesson).length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(width: 5.w);
        },
        itemBuilder: (context, index) {
          final coaches = Utils.fetchLessonCoaches(lesson)[index];
          final isSelected = lesson.selectedCoach == coaches.id;
          final profileUrl = coaches.profileUrl ?? '';
          final fullName = (coaches.fullName ?? '').split(" ").first;
          return InkWell(
              onTap: () {
                onChangeSelectedCoach(coaches.id);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: isSelected ? AppColors.darkBlue : Colors.transparent),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NetworkCircleImage(
                        path: profileUrl, width: 40.w, height: 40.h),
                    Text(
                      "COACH".tr(context),
                      style: AppTextStyles.gothamRegular12.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.darkGreen70),
                    ),
                    Text(
                      fullName,
                      style: AppTextStyles.balooBold11.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.darkGreen70,
                          height: 0.8),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class _LessonDateItem extends StatelessWidget {
  final LessonServiceBookings? serviceBooking;
  final int? maxCapacity;
  final int? minCapacity;
  final VoidCallback onTap;
  final bool isEnabled;

  const _LessonDateItem({
    required this.serviceBooking,
    required this.maxCapacity,
    required this.minCapacity,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceBooking?.bookingDate.format("EEE dd MMM") ?? "",
              style: AppTextStyles.gothamRegular14
                  .copyWith(color: AppColors.darkGreen),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                // "${serviceBooking?.bookingStartTime.format("hh:mm")} - ${serviceBooking?.bookingEndTime.format("hh:mm a")}",
                serviceBooking?.formatStartEndTime ?? "",
                style: AppTextStyles.gothamLight13
                    .copyWith(color: AppColors.darkGreen),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Utils.eventLessonStatusText(
                context: context,
                playersCount: serviceBooking?.players?.length ?? 0,
                maxCapacity: maxCapacity,
                minCapacity: minCapacity,
              ),
              style: AppTextStyles.balooBold9.copyWith(
                color: AppColors.darkGreen,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
              ),
              child: Text(
                "${serviceBooking?.players?.length.toString() ?? "0"}/$maxCapacity",
                style: AppTextStyles.gothamRegular12
                    .copyWith(color: AppColors.darkGreen),
              ),
            ),
          ],
        ),
        MainButton(
          onTap: onTap,
          color: Colors.white,
          showArrow: true,
          enabled: isEnabled,
          applyShadow: isEnabled,
          height: 35.h,
          width: 90.w,
          label: "BOOK".tr(context),
          labelStyle: AppTextStyles.balooMedium10.copyWith(
            color: AppColors.darkGreen,
          ),
        )
      ],
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ARE_YOU_SURE_YOU_WANT_TO_JOIN".tr(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.balooBold15.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 20.h),
          Text(
            "LESSON_CANCELLATION_POLICY".tr(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.balooMedium11.copyWith(color: AppColors.white),
          ),
          Text(
            "CANCELLATION_POLICY_3".tr(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.balooMedium11.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "JOIN_PAY_MY_SHARE".tr(context),
            labelStyle:
                AppTextStyles.balooMedium13.copyWith(color: AppColors.darkBlue),
            color: AppColors.yellow,
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}
