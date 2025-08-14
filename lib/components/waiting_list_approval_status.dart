import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/models/service_waiting_players.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../screens/home_screen/tabs/play_match_tab/play_match_tab.dart';

class WaitingListApprovalStatus extends ConsumerStatefulWidget {
  const WaitingListApprovalStatus({
    super.key,
    required this.data,
    required this.onJoin,
    required this.onWithdraw,
    required this.isForEvent,
  });

  final ServiceWaitingPlayers data;
  final Function(int) onJoin;
  final Function(int) onWithdraw;
  final bool isForEvent;

  @override
  ConsumerState<WaitingListApprovalStatus> createState() =>
      _WaitingListApprovalStatusState();
}

class _WaitingListApprovalStatusState
    extends ConsumerState<WaitingListApprovalStatus> {
  String get acceptedHeader {
    return widget.isForEvent
        ? "YOU_HAVE_BEEN_ACCEPTED_INTO_THE_TEAM".tr(context)
        : ("YOU_HAVE_BEEN_ACCEPTED_INTO_THE_MATCH".tr(context));
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.data;
    final playerSide = player.customer?.playingSide ?? "";
    final subTitle =
        "${player.customer?.level(getSportsName(ref))}${playerSide.isNotEmpty ? " • $playerSide" : ""}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          player.isApproved
              ? acceptedHeader
              : "YOU_ARE_WAITING_FOR_APPROVAL".trU(context),
          style: AppTextStyles.balooMedium17,
        ),
        SizedBox(height: 5.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.clay05,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
          child: Row(
            children: [
              NetworkCircleImage(
                  path: player.customer?.profileUrl, width: 37.w, height: 37.h,scale: 1,reservedLogo: true,),
              SizedBox(width: 10.w),
              Column(
                children: [
                  Text(
                    player.getCustomerName.toUpperCase(),
                    style: AppTextStyles.balooMedium12.copyWith(),
                  ),
                  if (subTitle.trim().length > 1)
                    Text(
                      subTitle,
                      style: AppTextStyles.sansRegular12.copyWith(
                        height: 0.9,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              MainButton(
                color: AppColors.oak,
                label: player.isApproved
                    ? "PAY_MY_SHARE".tr(context)
                    : "WITHDRAW".tr(context),
                labelStyle: AppTextStyles.balooMedium13
                    .copyWith(color: AppColors.white),
                applySize: false,
                padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 10.w),
                onTap: () {
                  if (player.isApproved) {
                    widget.onJoin(player.customer!.id!);
                  } else {
                    widget.onWithdraw(player.id!);
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
