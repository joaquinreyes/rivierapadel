part of 'event_detail.dart';

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.event});

  final ServiceDetail event;

  @override
  Widget build(BuildContext context) {
    String? levelRestriction = event.service?.event?.levelRestriction;
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
                  (event.service?.event?.eventName ?? "").capitalizeFirst,
                  style: AppTextStyles.sansMedium16
                      .copyWith(color: AppColors.white),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  (event.service?.location?.locationName ?? "").toUpperCase(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.balooMedium14
                      .copyWith(color: AppColors.white),
                ),
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
                  event.bookingDate.format("EEE dd MMM"),
                  "${event.bookingStartTime.format("h:mm")} - ${event.bookingEndTime.format("h:mm a").toLowerCase()}",
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
                      "${'MAX'.tr(context)} ${event.getMaximumCapacity.toString() ?? ""} ${'PLAYERS'.tr(context)}",
                      style: AppTextStyles.sansRegular12
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      "${'MIN'.tr(context)} ${event.getMinimumCapacity.toString() ?? ""} ${'PLAYERS'.tr(context)}",
                      style: AppTextStyles.sansRegular12
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _colInfo(
                  levelRestriction != null
                      ? "${"LEVEL".tr(context)} $levelRestriction"
                      : "",
                  "${"PRICE".tr(context)} ${Utils.formatPrice(event.service?.price)}",
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

enum _ConfirmationDialogType {
  join,
  leave,
  joinWaitingLit,
  approvePlayer,
  applyForApproval,
  withdraw,
  reserve,
  releaseReserve,
}

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
          if (type != _ConfirmationDialogType.withdraw) ...[
            SizedBox(height: 5.h),
            Text(
              _descText(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
          ],
          if (type == _ConfirmationDialogType.leave)
            RefundDescriptionComponent(
                policy: policy,
                text: policy == null ? "LEAVE_POLICY_EVENT".tr(context) : null,
                style: AppTextStyles.popupBodyTextStyle),
          // if (type == _ConfirmationDialogType.leave)
          //   Text(
          //     "LEAVE_POLICY_EVENT".tr(context),
          //     textAlign: TextAlign.center,
          //     style:
          //         AppTextStyles.panchangBold10.copyWith(color: AppColors.white),
          //   ),
          SizedBox(height: 20.h),
          MainButton(
            // color: AppColors.yellow,
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
      case _ConfirmationDialogType.joinWaitingLit:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN_THE_WAITING_LIST".trU(context);
      case _ConfirmationDialogType.approvePlayer:
        return "ARE_YOU_SURE_YOU_WANT_TO_APPROVE_THIS_PLAYER".trU(context);
      case _ConfirmationDialogType.applyForApproval:
        return "WILL_REQUIRE_APPROVAL".trU(context);
      case _ConfirmationDialogType.reserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RESERVE_THIS_SPOT".trU(context);
      case _ConfirmationDialogType.releaseReserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RELEASE_THIS_RESERVED_SPOT"
            .trU(context);
      case _ConfirmationDialogType.withdraw:
        return "ARE_YOU_SURE_YOU_WANT_TO_WITHDRAW_FROM_THE_MATCH".trU(context);
    }
  }

  _descText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "IF_YOU_JOIN_DESC_EVENT".tr(context);
      case _ConfirmationDialogType.leave:
        return "IF_YOU_LEAVE_DESC_EVENT".tr(context);
      case _ConfirmationDialogType.joinWaitingLit:
        return "IF_YOU_JOIN_DESC_WAITING_LIST".tr(context);
      case _ConfirmationDialogType.releaseReserve:
      case _ConfirmationDialogType.approvePlayer:
        return "THIS_ACTION_CANNOT_BE_UNDONE".tr(context);
      case _ConfirmationDialogType.applyForApproval:
        return "WILL_REQUIRE_APPROVAL_DESC".tr(context);
      case _ConfirmationDialogType.reserve:
        return "YOU_WONT_BE_ABLE_TO_EDIT_THIS_LATER".tr(context);
      case _ConfirmationDialogType.withdraw:
        return "";
    }
  }

  _buttonText(BuildContext context) {
    switch (type) {
      case _ConfirmationDialogType.join:
        return "JOIN_PAY_MY_SHARE".trU(context);

      case _ConfirmationDialogType.leave:
        return "LEAVE".trU(context);
      case _ConfirmationDialogType.joinWaitingLit:
        return "JOIN_WAITING_LIST".trU(context);
      case _ConfirmationDialogType.approvePlayer:
        return "APPROVE_PLAYER".trU(context);
      case _ConfirmationDialogType.applyForApproval:
        return "APPLY_TO_TEAM".trU(context);
      case _ConfirmationDialogType.withdraw:
        return "YES_WITHDRAW".trU(context);
      case _ConfirmationDialogType.releaseReserve:
        return "RELEASE_THIS_SPOT".trU(context);
      case _ConfirmationDialogType.reserve:
        return "RESERVE_PAY_SLOT".trU(context);
    }
  }
}

class _EventPlayersSlots extends ConsumerStatefulWidget {
  const _EventPlayersSlots(
      {required this.players,
      required this.maxPlayers,
      required this.onSlotTap,
      required this.service,
      required this.onRelease,
      required this.id,
      this.isDoubleEvents = false});

  final List<BookingPlayerBase> players;
  final int maxPlayers;
  final Function(int, int?) onSlotTap;
  final bool isDoubleEvents;
  final ServiceDetail service;
  final int id;
  final Function(int)? onRelease;

  @override
  ConsumerState<_EventPlayersSlots> createState() => _EventPlayersSlotsState();
}

class _EventPlayersSlotsState extends ConsumerState<_EventPlayersSlots> {
  late int maxPlayers;

  @override
  Widget build(BuildContext context) {
    if (widget.isDoubleEvents) {
      maxPlayers =
          widget.maxPlayers.isEven ? widget.maxPlayers : widget.maxPlayers - 1;
      return _DoubleEventsPlayers(
        onRelease: widget.onRelease,
        isWaitingList: false,
        id: widget.id,
        service: widget.service,
        players: widget.players,
        onSlotTap: widget.onSlotTap,
        maxPlayers: maxPlayers,
      );
    }
    maxPlayers = widget.maxPlayers;
    return _SingleEventPlayers(
      maxPlayers: maxPlayers,
      players: widget.players,
      onSlotTap: widget.onSlotTap,
    );
  }
}

class _DoubleEventsPlayers extends ConsumerStatefulWidget {
  const _DoubleEventsPlayers(
      {required this.service,
      required this.id,
      required this.players,
      required this.onSlotTap,
      required this.isWaitingList,
      required this.onRelease,
      this.textColor,
      this.bgColor,
      this.imageIconColor,
      required this.maxPlayers});

  final ServiceDetail service;
  final int id;
  final List<BookingPlayerBase> players;
  final Function(int, int?) onSlotTap;
  final int maxPlayers;
  final Color? textColor;
  final Color? bgColor;
  final Color? imageIconColor;
  final bool isWaitingList;
  final Function(int)? onRelease;

  @override
  ConsumerState<_DoubleEventsPlayers> createState() => __DoubleEventsState();
}

class __DoubleEventsState extends ConsumerState<_DoubleEventsPlayers> {
  int totalTeams = 0;
  List<BookingPlayerBase?> players = [];

  @override
  Widget build(BuildContext context) {
    final waitingList = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.id, RequestServiceType.event));
    return waitingList.when(
      data: (data) {
        setPlayers();
        return _doubleEvents(data);
      },
      loading: () => const CupertinoActivityIndicator(radius: 10),
      error: (error, stackTrace) => SecondaryText(text: error.toString()),
    );
  }

  setPlayers() {
    players.clear();
    totalTeams = widget.maxPlayers ~/ 2;

    int playersCount = math.min(widget.maxPlayers, widget.players.length);
    players = List.generate(
      widget.maxPlayers,
      (_) => null,
    );
    for (int i = 0; i < playersCount; i++) {
      final player = widget.players[i];
      int? pos = (player.position);
      int posIndex = (pos ?? (i + 1)) - 1;
      if (posIndex < players.length) {
        players[(pos ?? (i + 1)) - 1] = player;
      }
    }
  }

  _doubleEvents(List<ServiceWaitingPlayers> waitingList) {
    List<Widget> playersW =
        List.generate(widget.maxPlayers, (_) => Container());
    for (int i = 0; i < players.length; i += 2) {
      final firstPlayer = players[i];
      final secondPlayer = players[i + 1];
      playersW[i] = _processTeamsSlot(
        i,
        firstPlayer,
        otherTeamMemberID: secondPlayer?.id,
      );
      playersW[i + 1] = _processTeamsSlot(
        i + 1,
        secondPlayer,
        otherTeamMemberID: firstPlayer?.id,
      );
    }

    for (int i = 0; i < waitingList.length; i++) {
      final player = waitingList[i];
      bool showWaitingList = checkShowWaitingList(widget.service);

      final pos = (player.position ?? 1) - 1;
      final isCurrentPlayer =
          (player.customer?.id == ref.read(userProvider)?.user?.id);

      bool check = !(showWaitingList &&
          widget.isWaitingList &&
          (player.status == "waiting_approval" || player.status != "waiting"));
      bool check2 = !(!showWaitingList &&
          !widget.isWaitingList &&
          (player.status == "pending" || (player.status == "approved")));
      if (check2 && check) {
        continue;
      }
      if (pos >= players.length || (showWaitingList && !widget.isWaitingList)) {
        continue;
      }
      playersW[pos] = Expanded(
        // flex: !isCurrentPlayer ? 12 : 10,
        flex: 10,
        child: _ApplicantSlotWidget(
          text: "AVAILABLE".trU(context),
          textColor: widget.textColor,
          index: pos,
          otherTeamMemberID: player.otherPlayer,
          applicantsCount: getApplicants(waitingList).length,
          currentInWaitingList: isCurrentPlayer,
          iconColor: !isCurrentPlayer
              ? AppColors.darkGreen
              : (widget.textColor ?? AppColors.darkGreen),
          backGroundColor: !isCurrentPlayer
              ? (widget.bgColor ?? AppColors.darkGreen)
              : Colors.transparent,
          seeApplicants: () {
            seeApplicants(waitingList);
          },
        ),
      );
    }
    List<List<Widget>> teamRows = List.generate(
      totalTeams,
      (index) {
        return playersW.sublist(index * 2, index * 2 + 2);
      },
    );
    _addNumberToTeams(teamRows);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: teamRows.length,
      separatorBuilder: (context, index) => SizedBox(height: 15.h),
      itemBuilder: (context, index) {
        return Row(children: teamRows[index]);
      },
    );
  }

  List<ServiceWaitingPlayers> getApplicants(
      List<ServiceWaitingPlayers> waitingList) {
    List<ServiceWaitingPlayers> tempWaitingList = [...waitingList];
    if (widget.isWaitingList) {
      tempWaitingList.removeWhere(
          (e) => e.customer?.id == ref.read(userProvider)?.user?.id);
    } else {
      tempWaitingList.removeWhere(
          (e) => e.status == "waiting" || e.status == "waiting_approval");
    }
    return tempWaitingList;
  }

  ServiceDetail getTempService(List<ServiceWaitingPlayers> waitingList) {
    ServiceDetail tempService = ServiceDetail.fromJson(widget.service.toJson());
    List<ServiceWaitingPlayers> tempWaitingList = [...waitingList];

    if (widget.isWaitingList) {
      tempWaitingList.removeWhere(
          (e) => e.customer?.id != ref.read(userProvider)?.user?.id);
      tempService.players = tempWaitingList
          .map((e) => ServiceDetail_Players.fromJson(e.toJson()))
          .toList();
    } else {
      (tempService.players ?? []).removeWhere(
          (e) => e.customer?.id != ref.read(userProvider)?.user?.id);
    }

    return tempService;
  }

  Future<void> seeApplicants(List<ServiceWaitingPlayers> waitingList) async {
    ServiceDetail tempService = getTempService(waitingList);
    List<ServiceWaitingPlayers> tempWaitingList = getApplicants(waitingList);

    await showDialog(
      context: context,
      builder: (context) {
        return EventApplicantDialog(
          data: ApplicantSocketResponse(
            serviceBooking: tempService,
            waitingList: tempWaitingList,
          ),
        );
      },
    );
    ref.invalidate(
      fetchServiceWaitingPlayersProvider(widget.id, RequestServiceType.event),
    );
  }

  void _addNumberToTeams(List<List<Widget>> teamRows) {
    for (int i = 0; i < teamRows.length; i++) {
      teamRows[i].insert(0, _count(i));
      teamRows[i].insert(1, const Spacer());
      teamRows[i].insert(0, const Spacer());
    }
  }

  Widget _count(int i) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.oak50,
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
        boxShadow: const [
          kBoxShadow,
        ],
      ),
      width: 25.h,
      height: 25.h,
      child: Center(
        child: Text("${i + 1}", style: AppTextStyles.sansMedium14),
      ),
    );
  }

  Widget _processTeamsSlot(int index, BookingPlayerBase? player,
      {int? otherTeamMemberID}) {
    if (player != null) {
      return _addParticipantSlotDouble(
        index,
        player,
      );
    } else {
      return _addAvailableSlotDouble(
        index,
        otherTeamMemberID: otherTeamMemberID,
      );
    }
  }

  Widget _addAvailableSlotDouble(int index, {int? otherTeamMemberID}) {
    return Expanded(
      flex: 10,
      child: AvailableSlotWidget(
        text: "AVAILABLE".trU(context),
        index: index,
        onTap: widget.onSlotTap,
        isHorizontal: true,
        otherTeamMemberID: otherTeamMemberID,
        backgroundColor: widget.bgColor ?? Colors.transparent,
        iconColor: widget.imageIconColor ?? AppColors.darkGreen,
        textColor: widget.textColor ?? AppColors.darkGreen,
      ),
    );
  }

  Widget _addParticipantSlotDouble(int index, BookingPlayerBase player) {
    return Expanded(
      flex: 10,
      child: ParticipantSlot(
        onRelease: widget.onRelease,
        isHorizontal: true,
        showReleaseReserveButton: player.reserved ?? false,
        player: player,
        textColor: widget.textColor ?? AppColors.darkGreen,
        bgColor: widget.bgColor ?? AppColors.white,
        imageIconColor: AppColors.darkGreen,
      ),
    );
  }
}

class _SingleEventPlayers extends StatelessWidget {
  const _SingleEventPlayers({
    required this.maxPlayers,
    required this.players,
    required this.onSlotTap,
    this.textColor,
    this.imageIconColor,
    this.bgColor,
  });

  final List<BookingPlayerBase> players;
  final Function(int, int?) onSlotTap;
  final int maxPlayers;
  final Color? textColor;
  final Color? imageIconColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final int totalParticipants = players.length;
    final int totalRows = (maxPlayers / 4).ceil();
    int playerIndex = 0;

    List<Widget> rows = [];

    for (int rowIndex = 0; rowIndex < totalRows; rowIndex++) {
      List<Widget> participantsRow = [];

      int limit = math.min(4, maxPlayers - 4 * rowIndex);
      for (int colIndex = 0; colIndex < limit; colIndex++) {
        if (playerIndex < totalParticipants) {
          participantsRow.add(
            ParticipantSlot(
              player: players[playerIndex++],
              textColor: textColor ?? AppColors.darkGreen,
              bgColor: AppColors.darkGreen,
              imageIconColor: AppColors.darkGreen,
            ),
          );
        } else {
          participantsRow.add(
            AvailableSlotWidget(
              text: "AVAILABLE".trU(context),
              index: colIndex,
              onTap: (index, _) => onSlotTap(index, null),
              backgroundColor: bgColor ?? Colors.transparent,
              iconColor: imageIconColor ?? AppColors.darkGreen,
              textColor: textColor ?? AppColors.darkGreen,
            ),
          );
        }
      }

      while (participantsRow.length < 4) {
        participantsRow.add(
          Opacity(
            opacity: 0,
            child: AvailableSlotWidget(
              text: "AVAILABLE".tr(context),
              index: -1,
              backgroundColor: Colors.transparent,
              iconColor: imageIconColor ?? AppColors.darkGreen,
              textColor: textColor ?? AppColors.darkGreen,
            ),
          ),
        );
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: participantsRow,
        ),
      );

      if (rowIndex < totalRows - 1) {
        rows.add(SizedBox(height: 10.h));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class ApplicantSlotWidget extends StatelessWidget {
  const ApplicantSlotWidget({
    super.key,
    required this.text,
    required this.index,
    this.backGroundColor = AppColors.green5,
    this.seeApplicants,
    this.otherTeamMemberID,
    required this.applicantsCount,
    required this.currentInWaitingList,
  });

  final String text;
  final Color backGroundColor;
  final Function()? seeApplicants;
  final int index;
  final int? otherTeamMemberID;
  final int applicantsCount;
  final bool currentInWaitingList;

  @override
  Widget build(BuildContext context) {
    return _horizontal(context);
  }

  _horizontal(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(width: 6.h),
          Column(
            children: [
              _text(),
              SizedBox(height: 1.5.h),
              if (!currentInWaitingList) ...[
                SecondaryButton(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  onTap: seeApplicants,
                  child: Text(
                      "${applicantsCount > 1 ? "SEE_APPLICANTS".tr(context) : "SEE_APPLICANT".tr(context)} ($applicantsCount)",
                      style: AppTextStyles.gothamLight12
                          .copyWith(color: AppColors.darkGreen)),
                ),
              ] else ...[
                SecondaryButton(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  borderRadius: 0,
                  child: Text(
                    "YOU_APPLIED".tr(context),
                    style: AppTextStyles.gothamLight12,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  AutoSizeText _text() {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      maxFontSize: 12.sp,
      minFontSize: 8.sp,
      maxLines: 1,
      stepGranularity: 1.sp,
      style: AppTextStyles.gothamBold12,
    );
  }

  Container _circle() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: backGroundColor,
        shape: BoxShape.circle,
      ),
      child: DottedBorder(
        borderType: BorderType.Circle,
        dashPattern: const [5, 4],
        color: AppColors.green5,
        strokeWidth: 1.h,
        child: Container(
          height: 40.w,
          width: 40.w,
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: AppColors.green5,
            size: 20.h,
          ),
        ),
      ),
    );
  }
}

class _ApplicantSlotWidget extends StatelessWidget {
  const _ApplicantSlotWidget({
    required this.text,
    required this.index,
    this.seeApplicants,
    this.otherTeamMemberID,
    this.textColor,
    required this.applicantsCount,
    required this.currentInWaitingList,
    this.backGroundColor = AppColors.darkBlue,
    this.iconColor = AppColors.darkBlue,
  });

  final String text;
  final Color backGroundColor;
  final Function()? seeApplicants;
  final int index;
  final int? otherTeamMemberID;
  final int applicantsCount;
  final bool currentInWaitingList;
  final Color iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return _horizontal(context);
  }

  _horizontal(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circle(),
          SizedBox(width: 6.h),
          Column(
            children: [
              _text(),
              SizedBox(height: 1.5.h),
              if (!currentInWaitingList) ...[
                SecondaryButton(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  onTap: seeApplicants,
                  child: Text(
                      "${applicantsCount > 1 ? "SEE_APPLICANTS".tr(context) : "SEE_APPLICANT".tr(context)} ($applicantsCount)",
                      style: AppTextStyles.gothamLight12
                          .copyWith(color: AppColors.darkGreen)),
                ),
              ] else ...[
                SecondaryButton(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  borderRadius: 0,
                  child: Text(
                    "YOU_APPLIED".tr(context),
                    style: AppTextStyles.gothamLight12,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  AutoSizeText _text() {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      maxFontSize: 12.sp,
      minFontSize: 8.sp,
      maxLines: 1,
      stepGranularity: 1.sp,
      style: AppTextStyles.balooMedium12,
    );
  }

  Container _circle() {
    return Container(
      width: 37.w,
      height: 37.w,
      decoration: BoxDecoration(
        color: backGroundColor,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(2.w),
      child: DottedBorder(
        borderType: BorderType.Circle,
        dashPattern: const [5, 4],
        color: iconColor,
        strokeWidth: 1.h,
        child: Container(
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 20.h,
          ),
        ),
      ),
    );
  }
}

class _WaitingPlayersSlots extends ConsumerStatefulWidget {
  const _WaitingPlayersSlots({
    required this.players,
    required this.maxPlayers,
    required this.onSlotTap,
    required this.service,
    required this.isInWaitingList,
    required this.id,
    required this.onRelease,
    required this.onWithdraw,
    this.isDoubleEvents = false,
  });

  final List<BookingPlayerBase> players;
  final int maxPlayers;
  final Function(int, int?) onSlotTap;
  final Function onWithdraw;

  final bool isDoubleEvents;
  final ServiceDetail service;
  final int id;
  final bool isInWaitingList;
  final Function(int)? onRelease;

  @override
  ConsumerState<_WaitingPlayersSlots> createState() =>
      _WaitingPlayersSlotsState();
}

class _WaitingPlayersSlotsState extends ConsumerState<_WaitingPlayersSlots> {
  @override
  Widget build(BuildContext context) {
    int maxPlayers = widget.isDoubleEvents
        ? (widget.maxPlayers.isEven ? widget.maxPlayers : widget.maxPlayers - 1)
        : widget.maxPlayers;
    bool showWaitingList = checkShowWaitingList(widget.service);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // const Icon(Icons.info_outline, color: AppColors.black, size: 16),
            Image.asset(AppImages.infoIcon.path, width: 12.w, height: 12.h,color: AppColors.darkBlue,),
            SizedBox(width: 10.w),
            Text("WAITING_LIST".trU(context),
                style: AppTextStyles.balooMedium17)
          ],
        ),
        SizedBox(height: 6.h),
        showWaitingList
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.clay05),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: widget.isDoubleEvents
                    ? _DoubleEventsPlayers(
                        onRelease: widget.onRelease,
                        isWaitingList: true,
                        textColor: AppColors.darkBlue,
                        bgColor: AppColors.darkBlue,
                        imageIconColor: AppColors.white,
                        id: widget.id,
                        service: widget.service,
                        players: widget.players,
                        onSlotTap: widget.onSlotTap,
                        maxPlayers: maxPlayers,
                      )
                    : _SingleEventPlayers(
                        textColor: AppColors.darkGreen,
                        imageIconColor: AppColors.white,
                        bgColor: AppColors.darkBlue,
                        maxPlayers: maxPlayers - 2,
                        players: widget.players,
                        onSlotTap: widget.onSlotTap,
                      ),
              )
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text("THERE_IS_NO_WAITING_LIST".tr(context),
                  style: AppTextStyles.sansRegular13),
            ),
        SizedBox(height: 15.h),
        if (showWaitingList && widget.isInWaitingList)
          SecondaryButton(
            onTap: () {
              widget.onWithdraw();
            },
            color: AppColors.darkGreen5,
            borderRadius: 10,
            applyShadow: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, color: AppColors.darkGreen, size: 18.h),
                SizedBox(width: 5.w),
                Text(
                  "LEAVE_WAITING_LIST".tr(context),
                  style: AppTextStyles.sansRegular13
                      .copyWith(color: AppColors.darkGreen),
                ),
              ],
            ),
          ),
        SizedBox(height: 15.h),
      ],
    );
  }
}

bool checkShowWaitingList(ServiceDetail service) {
  var servicePlayers = [...(service.players ?? [])];
  servicePlayers
      .removeWhere((e) => (e.isCanceled ?? false) || (e.isWaiting ?? false));

  int maxCount = service.getMaximumCapacity;

  return (service.service?.isDoubleEvent ?? false)
      ? (servicePlayers.length >= (maxCount))
      : (servicePlayers.length == maxCount);
}
