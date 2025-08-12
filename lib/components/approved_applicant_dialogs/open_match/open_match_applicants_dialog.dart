import 'package:acepadel/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/open_match_waiting_for_approval_players.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/applicat_socket_response.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/screens/open_match_detail/open_match_detail.dart';
import 'package:acepadel/utils/custom_extensions.dart';
part 'components.dart';

class OpenMatchApplicantDialog extends ConsumerStatefulWidget {
  const OpenMatchApplicantDialog({
    super.key,
    required this.data,
  });
  final ApplicantSocketResponse data;

  @override
  ConsumerState<OpenMatchApplicantDialog> createState() =>
      _ApplicantDialogState();
}

class _ApplicantDialogState extends ConsumerState<OpenMatchApplicantDialog> {
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
          Text(
            "PLAYERS_WAITING_FOR_YOUR_APPROVAL".trU(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.panchangBold9,
          ),
          SizedBox(height: 20.h),
          ApplicantOpenMatchInfoCard(
            service: widget.data.serviceBooking!,
          ),
          SizedBox(height: 20.h),
          Text("CURRENT_PLAYERS".tr(context),
              style: AppTextStyles.panchangBold10),
          SizedBox(height: 5.h),
          OpenMatchParticipantRowWithBG(
            textForAvailableSlot: "AVAILABLE".tr(context),
            players: widget.data.serviceBooking?.players ?? [],
            showReserveReleaseButton: false,
            bgColor: AppColors.yellow,
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
