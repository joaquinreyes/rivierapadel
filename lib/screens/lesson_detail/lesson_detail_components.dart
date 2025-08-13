part of 'lesson_detail.dart';

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.lesson});

  final ServiceDetail lesson;

  @override
  Widget build(BuildContext context) {
    final maxPaxValue = lesson.maxPaxValue;
    final bool isLessonVariant = maxPaxValue != null;
    String? levelRestriction = lesson.service?.event?.levelRestriction;

    if (isLessonVariant) {
      return _LessonVariantInfoCard(lesson: lesson);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  (lesson.service?.lesson?.lessonName ?? "").capitalizeFirst,
                  style: AppTextStyles.sansMedium16
                      .copyWith(color: AppColors.white),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                    (lesson.service?.location?.locationName ?? "")
                        .toUpperCase(),
                    textAlign: TextAlign.end,
                    style: AppTextStyles.balooMedium14
                        .copyWith(color: AppColors.white)),
              ),
            ],
          ),
          const CDivider(color: AppColors.white25),
          // SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _colInfo(
                  lesson.bookingDate.format("EEE dd MMM"),
                  "${lesson.bookingStartTime.format("h:mm")} - ${lesson.bookingEndTime.format("h:mm a").toLowerCase()}",
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SLOTS'.trU(context),
                      style: AppTextStyles.balooMedium12
                          .copyWith(color: AppColors.white),
                    ),
                    // SizedBox(height: 4.h),
                    Text(
                      "${'MAX'.tr(context)} ${lesson.getMaximumCapacity.toString() ?? ""} ${'PLAYERS'.tr(context)}",
                      style: AppTextStyles.sansRegular12
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      "${'MIN'.tr(context)} ${lesson.getMinimumCapacity.toString() ?? ""} ${'PLAYERS'.tr(context)}",
                      style: AppTextStyles.sansRegular12
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _colInfo(
                  levelRestriction != null ? "${"LEVEL".tr(context)} $levelRestriction" : "",
                  "${"PRICE".tr(context)} ${Utils.formatPrice(lesson.service?.price)}",
                  isEnd: true,
                ),
              )
            ],
          )
          // OpenMatchParticipantRow(
          //   isForReserve: false,
          //   backGroundColor: AppColors.white,
          //   players: match.players ?? [],
          // ),
        ],
      ),
    );
  }

  Column _colInfo(String text1, String text2, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment:
          isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style:
              AppTextStyles.sansRegular13.copyWith(color: AppColors.white),
        ),
        SizedBox(height: 2.h),
        Text(
          text2,
          style:
              AppTextStyles.sansRegular13.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

class _LessonVariantInfoCard extends StatelessWidget {
  const _LessonVariantInfoCard({required this.lesson});

  final ServiceDetail lesson;

  @override
  Widget build(BuildContext context) {
    final coachName =
        (lesson.getCoaches.isNotEmpty ? lesson.getCoaches.first.fullName : "-")
                ?.capitalizeFirst ??
            "-";
    final location =
        lesson.service?.location?.locationName.capitalizeFirst ?? "-";
    final lessonType =
        lesson.service?.lesson?.lessonName?.capitalizeFirst ?? "Private Lesson";
    final court = lesson.courtName.isNotEmpty ? lesson.courtName : "Court 1";
    final paid = Utils.formatPrice(lesson.service?.price);
    final duration = lesson.duration2 > 0 ? "${lesson.duration2} min" : "-";
    final pax = lesson.getMaximumCapacity > 0
        ? "${lesson.getMaximumCapacity} pax"
        : "-";
    final time =
        "${lesson.bookingStartTime.format("H:mm")} - ${lesson.bookingEndTime.format("H:mm")}";
    final date = lesson.bookingDate.format("EEEE d MMM");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coachName,
                  style: AppTextStyles.gothamBold14
                      .copyWith(color: AppColors.white),
                ),
              ),
              Expanded(
                child: Text(
                  location,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.gothamBold14
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const CDivider(color: AppColors.white25),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessonType,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      court,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Paid $paid",
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.white),
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
                      "$duration - $pax",
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: AppTextStyles.gothamLight13
                          .copyWith(color: AppColors.white),
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

enum _ConfirmationDialogType { join, leave }

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({required this.type, this.policy});

  final _ConfirmationDialogType type;
  final CancellationPolicy? policy;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _headingText(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.popupHeaderTextStyle,
          ),
          SizedBox(height: 20.h),
          Text(
            type == _ConfirmationDialogType.join
                ? "LESSON_CANCELLATION_POLICY".tr(context)
                : "IF_YOU_LEAVE_DESC_EVENT".tr(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.popupBodyTextStyle,
          ),
          if (type == _ConfirmationDialogType.leave)
            RefundDescriptionComponent(
                policy: policy,
                text: policy == null ? "LEAVE_POLICY_LESSON".tr(context) : null,
                style: AppTextStyles.popupBodyTextStyle),
          SizedBox(height: 20.h),
          MainButton(
            isForPopup: true,
            // labelStyle:
            //     AppTextStyles.balooMedium13.copyWith(color: AppColors.darkBlue),
            label: _buttonText(context),
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }

  _headingText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN".trU(context);
      case _ConfirmationDialogType.leave:
        return "ARE_YOU_SURE_YOU_WANT_TO_LEAVE".trU(context);
    }
  }

  _buttonText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "JOIN_PAY_MY_SHARE".trU(context);

      case _ConfirmationDialogType.leave:
        return "LEAVE".trU(context);
    }
  }
}

class _LessonPlayersSlots extends StatelessWidget {
  const _LessonPlayersSlots({
    required this.players,
    required this.maxPlayers,
    required this.onSlotTap,
  });

  final List<BookingPlayerBase> players;
  final int maxPlayers;
  final Function(int, int?) onSlotTap;

  @override
  Widget build(BuildContext context) {
    final int totalParticipants = players.length;
    final int totalRows = (maxPlayers / 4).ceil();
    int playerIndex = 0;

    List<Widget> rows = List.generate(totalRows, (rowIndex) {
      List<Widget> participantsRow = List.generate(
        math.min(4, maxPlayers - 4 * rowIndex),
        (colIndex) {
          return playerIndex < totalParticipants
              ? ParticipantSlot(
                  player: players[playerIndex++],
                  textColor: AppColors.black,
                )
              : AvailableSlotWidget(
                  backgroundColor: Colors.transparent,
                  iconColor: AppColors.darkGreen,
                  text: "AVAILABLE".trU(context),
                  index: colIndex,
                  onTap: (index, __) => onSlotTap(index, null),
                );
        },
      );

      // Fill the remaining slots with invisible widgets if the last row is incomplete
      while (participantsRow.length < 4) {
        participantsRow.add(
          Opacity(
            opacity: 0,
            child: AvailableSlotWidget(
              backgroundColor: Colors.transparent,
              iconColor: AppColors.darkGreen,
              text: "AVAILABLE".trU(context),
              index: -1,
            ),
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: participantsRow,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int j = 0; j < rows.length; j++) ...[
          rows[j],
          if (j < rows.length - 1) SizedBox(height: 10.h),
        ],
      ],
    );
  }
}
