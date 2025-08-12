import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/models/service_waiting_players.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import '../screens/home_screen/tabs/play_match_tab/play_match_tab.dart';

class ApprovedListUserJoin extends ConsumerStatefulWidget {
  const ApprovedListUserJoin({
    super.key,
    required this.data,
  });

  final List<ServiceWaitingPlayers> data;

  @override
  ConsumerState<ApprovedListUserJoin> createState() =>
      _ApprovedListUserJoinState();
}

class _ApprovedListUserJoinState extends ConsumerState<ApprovedListUserJoin> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGreen5,
        borderRadius: BorderRadius.circular(7.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.black, size: 20),
              SizedBox(width: 5.h),
              Text(
                "APPROVED_PLAYERS".trU(context),
                style: AppTextStyles.balooBold13,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const CDivider(),
          SizedBox(height: 2.h),
          for (int i = 0; i < widget.data.length; i++) ...[
            Builder(builder: (context) {
              final player = widget.data[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            final id = player.customer?.id ?? -1;
                            if (player.reserved ?? false) {
                              return;
                            }
                            if (id != -1) {
                              ref.read(goRouterProvider).push(
                                    "${RouteNames.rankingProfile}/$id",
                                  );
                            }
                          },
                          child: Column(
                            children: [
                              // Text(
                              //   "SEE_PROFILE".trU(context),
                              //   style: AppTextStyles.helveticaLightItalic14,
                              // ),
                              // SizedBox(height: 5.h),
                              NetworkCircleImage(
                                path: player.customer?.profileUrl,
                                width: 40.w,
                                height: 40.h,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                player.getCustomerName,
                                style: AppTextStyles.balooBold9.copyWith(),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            SizedBox(height: 15.h),
                            Text(
                              "${"LEVEL".tr(context)} ${player.customer?.level(getSportsName(ref))} ", //•  Right",
                              style: AppTextStyles.gothamLight11.copyWith(
                                height: 0.9,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              player.customer?.playingSide ?? "",
                              style: AppTextStyles.gothamLight11.copyWith(
                                height: 0.9,
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              "STATUS".trU(context),
                              style: AppTextStyles.gothamRegular12,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "WAITING_FOR_PLAYER_TO_JOIN".trU(context),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.gothamBold12
                                  .copyWith(height: 1.3),
                            )
                          ],
                        ))
                  ],
                ),
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
    );
  }
}
