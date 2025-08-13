import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import '../screens/home_screen/tabs/play_match_tab/play_match_tab.dart';

class ParticipantSlot extends ConsumerWidget {
  const ParticipantSlot({
    super.key,
    required this.player,
    this.isHorizontal = false,
    this.onRelease,
    this.showReleaseReserveButton = false,
    this.textColor = AppColors.white,
    this.bgColor = AppColors.white,
    this.imageIconColor = AppColors.white,
    this.showLevel = true,
    this.onPlayerTap,
    // this.reservedImage,
  });

  final BookingPlayerBase player;
  final bool isHorizontal;
  final Function(int)? onRelease;
  final bool showReleaseReserveButton;
  final Color textColor;
  final Color bgColor;
  final Color imageIconColor;
  final Function(int, bool)? onPlayerTap;
  final bool showLevel;
  // final bool? reservedImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = player.customer?.level(getSportsName(ref)) ?? "";
    final side = player.customer?.playingSide ?? "SIDE";

    return GestureDetector(
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
        child: isHorizontal
            ? _horizontal(context, level, side)
            : _vertical(context, level, side));
  }

  _horizontal(BuildContext context, String level, String side) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _image(),
          SizedBox(width: 15.h),
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _text(context),
                  if (showLevel && (!(player.reserved ?? true))) ...[
                    SizedBox(height: 2.h),
                    _levelSideText(level, side),
                  ],
                  if (showReleaseReserveButton) ...[
                    SecondaryImageButton(
                      image: AppImages.crossIcon.path,
                      color: AppColors.white,
                      imageHeight: 10.w,
                      imageWidth: 10.w,
                      spacing: 3.w,
                      label: "RELEASE".tr(context),
                      onTap: () {
                        onRelease?.call(player.id ?? -1);
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    )
                  ]
                ]),
          ),
        ],
      ),
    );
  }

  Widget _vertical(BuildContext context, String level, String side) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      alignment: Alignment.center,
      width: 61.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _image(),
          // SizedBox(height: 5.h),
          _text(context),
          if ((!(player.reserved ?? true))) ...[
            _levelSideText(level, side),
          ],
          if (showReleaseReserveButton) ...[
            SecondaryImageButton(
              image: AppImages.crossIcon.path,
              color: AppColors.white,
              imageHeight: 10.w,
              imageWidth: 10.w,
              spacing: 3.w,
              textColor: AppColors.darkBlue,
              label: "RELEASE".tr(context),
              onTap: () {
                onRelease?.call(player.id ?? -1);
              },
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            )
          ]
        ],
      ),
    );
  }

  Column _levelSideText(String level, String side) {
    return Column(
      children: [
        if (level.trim().isNotEmpty)
          AutoSizeText(
            level,
            textAlign: TextAlign.center,
            maxFontSize: 12.sp,
            minFontSize: 8.sp,
            maxLines: 1,
            stepGranularity: 1.sp,
            style: AppTextStyles.sansRegular12
                .copyWith(height: 0.99, color: textColor),
          ),
        if (side != "SIDE" && side.trim().isNotEmpty)
          AutoSizeText(
            side,
            textAlign: TextAlign.center,
            maxFontSize: 12.sp,
            minFontSize: 8.sp,
            maxLines: 1,
            stepGranularity: 1.sp,
            style: AppTextStyles.sansRegular12
                .copyWith(height: 0.99, color: textColor),
          ),
      ],
    );
  }

  AutoSizeText _text(BuildContext context) {
    return AutoSizeText(
      (player.reserved == false)
          ? (player.getCustomerName)
          : "RESERVED".trU(context),
      textAlign: TextAlign.start,
      maxFontSize: 12.sp,
      minFontSize: 2.sp,
      maxLines: 1,
      stepGranularity: 1.sp,
      style: AppTextStyles.balooMedium11.copyWith(color: textColor),
    );
  }

  Widget _image() {
    return NetworkCircleImage(
      path: (player.reserved == false) ? player.customer?.profileUrl : null,
      width: isHorizontal ? 37.h : 37.h,
      height: isHorizontal ? 37.h : 37.h,
      scale: 1,
      reservedLogo: player.reserved,
      boxBorder: Border.all(color: ((player.customer?.profileUrl?.isNotEmpty ?? false) && (player.reserved == false)) ? AppColors.white25 : AppColors.darkBlue),
    );
  }
}
