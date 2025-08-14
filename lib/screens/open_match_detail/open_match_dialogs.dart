part of 'open_match_detail.dart';

class _ChooseSpotDialog extends StatelessWidget {
  const _ChooseSpotDialog({required this.players});

  final List<BookingPlayerBase> players;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "CHOOSE_YOUR_SPOT".trU(context),
          style: AppTextStyles.popupHeaderTextStyle,
        ),
        SizedBox(height: 20.h),
        OpenMatchParticipantRowWithBG(
          availableSlotbackGroundColor: AppColors.darkBlue,
          availableSlotIconColor: AppColors.white,
          bgColor: AppColors.white25,
          textColor: AppColors.white,
          padding: EdgeInsets.only(top: 15.h,left: 10.w,right: 10.w),
          textForAvailableSlot: "RESERVE".trU(context),
          players: players,
          onTap: (index, playerID) {
            Navigator.pop(context, (index, playerID));
          },
        ),
      ],
    ));
  }
}

class _WaitingForApprovalDialog extends ConsumerStatefulWidget {
  const _WaitingForApprovalDialog({required this.serviceID});

  final int serviceID;

  @override
  ConsumerState<_WaitingForApprovalDialog> createState() =>
      _WaitingForApprovalDialogState();
}

class _WaitingForApprovalDialogState
    extends ConsumerState<_WaitingForApprovalDialog> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.serviceID, RequestServiceType.booking));
    return CustomDialog(
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "YOU_ARE_NOW_WAITING_FOR_APPROVAL".trU(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.popupHeaderTextStyle,
          ),
          provider.when(
            data: (data) {
              final currentPlayerID = ref.read(userProvider)?.user?.id;
              data.removeWhere(
                  (element) => element.customer?.id == currentPlayerID);
              if (data.isEmpty) {
                return Container();
              }
              return Column(
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    "HERE_ARE_OTHER_PLAYERS_WAITING_FOR_APPROVAL".tr(context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.balooBold10,
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < min(data.length, 4); i++) ...[
                        Column(
                          children: [
                            NetworkCircleImage(
                                path: data[i].customer?.profileUrl,
                                width: 40.w,
                                height: 40.w),
                            Text(
                              data[i].getCustomerName,
                              style: AppTextStyles.balooBold26.copyWith(),
                            ),
                            Text(
                              "6.5 •  Right",
                              style: AppTextStyles.balooBold26.copyWith(
                                height: 0.9,
                              ),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              );
            },
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
          ),
        ],
      ),
    );
  }
}

enum ConfirmationDialogType {
  join,
  reserve,
  leave,
  cancel,
  approvalNeeded,
  approveConfirm,
  releaseReserve,
  withdraw,
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.type, this.policy});

  final ConfirmationDialogType type;
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
          if (type != ConfirmationDialogType.withdraw) ...[
            SizedBox(height: 20.h),
            Text(
              _descText(context),
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.popupBodyTextStyle,
            ),
          ],
          if (type == ConfirmationDialogType.join ||
              type == ConfirmationDialogType.leave ||
              type == ConfirmationDialogType.cancel) ...[
            RefundDescriptionComponent(
                policy: policy,
                text: type == ConfirmationDialogType.join
                    ? "CANCELLATION_POLICY".tr(context)
                    : null,
                style: AppTextStyles.popupBodyTextStyle)
          ],
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
      case ConfirmationDialogType.cancel:
        return "ARE_YOU_SURE_YOU_WANT_TO_CANCEL_THIS_MATCH".trU(context);
      case ConfirmationDialogType.join:
        return "ARE_YOU_SURE_YOU_WANT_TO_JOIN_THE_MATCH".trU(context);
      case ConfirmationDialogType.reserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RESERVE_THIS_SPOT".trU(context);
      case ConfirmationDialogType.leave:
        return "ARE_YOU_SURE_YOU_WANT_TO_LEAVE_THIS_OPEN_MATCH".trU(context);
      case ConfirmationDialogType.approvalNeeded:
        return "NEEDS_ORGANIZER_APPROVAL".trU(context);
      case ConfirmationDialogType.approveConfirm:
        return "ARE_YOU_SURE_YOU_WANT_TO_APPROVE_THIS_PLAYER".trU(context);
      case ConfirmationDialogType.releaseReserve:
        return "ARE_YOU_SURE_YOU_WANT_TO_RELEASE_THIS_RESERVED_SPOT"
            .trU(context);
      case ConfirmationDialogType.withdraw:
        return "ARE_YOU_SURE_YOU_WANT_TO_WITHDRAW_FROM_THE_MATCH".trU(context);
    }
  }

  _buttonText(BuildContext context) {
    switch (type) {
      case ConfirmationDialogType.cancel:
        return "CANCEL_MATCH".trU(context);
      case ConfirmationDialogType.join:
        return "JOIN_PAY_MY_SHARE".trU(context);
      case ConfirmationDialogType.reserve:
        return "RESERVE_PAY_SLOT".trU(context);
      case ConfirmationDialogType.leave:
        return "LEAVE_OPEN_MATCH".trU(context);
      case ConfirmationDialogType.approvalNeeded:
        return "APPLY_TO_OPEN_MATCH".trU(context);
      case ConfirmationDialogType.approveConfirm:
        return "APPROVE_PLAYER".trU(context);
      case ConfirmationDialogType.releaseReserve:
        return "RELEASE_THIS_SPOT".trU(context);
      case ConfirmationDialogType.withdraw:
        return "YES_WITHDRAW".trU(context);
    }
  }

  _descText(BuildContext context) {
    switch (type) {
      case ConfirmationDialogType.join:
        return "IF_YOU_JOIN_DESC".tr(context);
      case ConfirmationDialogType.leave:
        return "IF_YOU_LEAVE_DESC".tr(context);
      case ConfirmationDialogType.cancel:
        return "IF_YOU_CANCEL_DESC".tr(context);
      case ConfirmationDialogType.approvalNeeded:
        return "NEEDS_ORGANIZER_APPROVAL_DESC".tr(context);
      case ConfirmationDialogType.approveConfirm:
      case ConfirmationDialogType.releaseReserve:
        return "THIS_ACTION_CANNOT_BE_UNDONE".tr(context);
      case ConfirmationDialogType.reserve:
        return "YOU_WONT_BE_ABLE_TO_EDIT_THIS_LATER".tr(context);
      case ConfirmationDialogType.withdraw:
        return "";
    }
  }
}
