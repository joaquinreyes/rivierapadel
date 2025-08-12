import 'package:acepadel/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/open_match_waiting_for_approval_players.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/applicat_socket_response.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/screens/open_match_detail/open_match_detail.dart';
import 'package:acepadel/utils/custom_extensions.dart';
part 'components.dart';

class EventApplicantDialog extends ConsumerStatefulWidget {
  const EventApplicantDialog({
    super.key,
    required this.data,
  });
  final ApplicantSocketResponse data;

  @override
  ConsumerState<EventApplicantDialog> createState() => _ApplicantDialogState();
}

class _ApplicantDialogState extends ConsumerState<EventApplicantDialog> {
  @override
  void initState() {
    if (widget.data.waitingList == null || widget.data.waitingList!.isEmpty) {
      return;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("PLAYERS_WAITING_TO_ENTER_YOUR_MATCH".tr(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.panchangBold15
                  .copyWith(color: AppColors.white)),
          SizedBox(height: 20.h),
          ApplicantEventInfoCard(service: widget.data.serviceBooking!),
          SizedBox(height: 15.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "CURRENT_TEAM".tr(context),
              style: AppTextStyles.panchangMedium12
                  .copyWith(color: AppColors.white),
            ),
          ),
          SizedBox(height: 5.h),
          OpenMatchParticipantRowWithBG(
            textForAvailableSlot: "AVAILABLE".tr(context),
            players: widget.data.serviceBooking?.players ?? [],
            showReserveReleaseButton: false,
            maxPlayers: 2,
            bgColor: AppColors.white25,
            availableSlotbackGroundColor: AppColors.blue35,
            availableSlotIconColor: AppColors.white,
            textColor: AppColors.white,
          ),
          SizedBox(height: 15.h),
          OpenMatchWaitingForApprovalPlayers(
            isForPopUp: true,
            data: widget.data.waitingList ?? [],
            onApprove: _approve,
          )
        ],
      ),
    );
  }

  _approve(int id) async {
    bool? approve = await showDialog(
      context: context,
      builder: (context) {
        return const ConfirmationDialog(
          type: ConfirmationDialogType.approveConfirm,
        );
      },
    );
    if (approve != null && approve && mounted) {
      final provider = approvePlayerProvider(
          serviceID: widget.data.serviceBooking!.id!, playerID: id);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }
      setState(() {
        int index = widget.data.waitingList
                ?.indexWhere((element) => element.id == id) ??
            -1;
        if (index != -1) {
          final waitingPlayer = widget.data.waitingList![index];
          widget.data.serviceBooking!.players!.add(ServiceDetail_Players(
            id: waitingPlayer.id,
            customer:
                BookingCustomerBase.fromJson(waitingPlayer.customer!.toJson()),
          ));

          widget.data.waitingList!.removeAt(index);
        }
      });
      if (widget.data.waitingList!.isEmpty && mounted) {
        Navigator.pop(context);
      }
    }
  }
}
