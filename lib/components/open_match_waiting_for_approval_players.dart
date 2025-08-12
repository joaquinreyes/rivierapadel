import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/models/service_waiting_players.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../screens/home_screen/tabs/play_match_tab/play_match_tab.dart';

class OpenMatchWaitingForApprovalPlayers extends ConsumerStatefulWidget {
  const OpenMatchWaitingForApprovalPlayers(
      {super.key,
      required this.data,
      required this.onApprove,
      this.isForPopUp = false});

  final List<ServiceWaitingPlayers> data;
  final Function(int) onApprove;
  final bool isForPopUp;

  @override
  ConsumerState<OpenMatchWaitingForApprovalPlayers> createState() =>
      _OpenMatchWaitingForApprovalPlayersState();
}

class _OpenMatchWaitingForApprovalPlayersState
    extends ConsumerState<OpenMatchWaitingForApprovalPlayers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PLAYERS_WAITING_FOR_YOUR_APPROVAL".tr(context),
          style: widget.isForPopUp
              ? AppTextStyles.panchangMedium12.copyWith(color: AppColors.white)
              : AppTextStyles.panchangBold14,
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: widget.isForPopUp ? AppColors.white25 : AppColors.green5,
            borderRadius: BorderRadius.circular((widget.isForPopUp ? 5 : 15).r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
          child: Column(
            children: [
              for (int i = 0; i < widget.data.length; i++) ...[
                Builder(builder: (context) {
                  final player = widget.data[i];
                  final subTitle =
                      "${player.customer?.level(getSportsName(ref))} • ${player.customer?.playingSide ?? ""}";

                  return Row(
                    children: [
                      NetworkCircleImage(
                          path: player.customer?.profileUrl,
                          width: 40.w,
                          height: 40.h),
                      SizedBox(width: 15.w),
                      Column(
                        children: [
                          Text(
                            player.getCustomerName,
                            style: AppTextStyles.panchangBold9.copyWith(
                                color: widget.isForPopUp
                                    ? AppColors.white
                                    : AppColors.black),
                          ),
                          if (subTitle.trim().length > 1)
                            Text(
                              subTitle,
                              style: AppTextStyles.helveticaLight13.copyWith(
                                  height: 0.9,
                                  color: widget.isForPopUp
                                      ? AppColors.white
                                      : AppColors.black),
                            ),
                        ],
                      ),
                      const Spacer(),
                      MainButton(
                        label: "APPROVE".tr(context),
                        width: 100.w,
                        height: 32.h,
                        color: AppColors.yellow,
                        labelStyle: AppTextStyles.panchangMedium9
                            .copyWith(color: AppColors.darkGreen),
                        applySize: false,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        onTap: () {
                          widget.onApprove(player.id!);
                        },
                      )
                    ],
                  );
                }),
                if (i < widget.data.length - 1) ...[
                  SizedBox(height: 5.h),
                  const CDivider(),
                  SizedBox(height: 5.h),
                ]
              ]
            ],
          ),
        ),
      ],
    );
  }
}
