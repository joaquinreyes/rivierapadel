import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/waiting_for_approval.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/models/user_bookings.dart';
import '../managers/user_manager.dart';
import 'changes_cancelled_listing_card.dart';

class UserOpenMatchCard extends ConsumerStatefulWidget {
  const UserOpenMatchCard({super.key, required this.booking});
  final UserBookings booking;

  @override
  ConsumerState<UserOpenMatchCard> createState() => _UserOpenMatchCardState();
}

class _UserOpenMatchCardState extends ConsumerState<UserOpenMatchCard> {
  @override
  Widget build(BuildContext context) {
    bool leftMatch = false;
    bool isApproved = false;

    final user = ref.watch(userManagerProvider).user;
    if (user != null) {
      int? uid = user.user?.id;
      if (uid != null) {
        (widget.booking.requestWaitingList ?? []).map((e) {
          if (!isApproved && e.id == uid && e.status == "approved") {
            isApproved = true;
          }
        }).toList();

        (widget.booking.players ?? []).map((e) {
          if (e.customer != null &&
              e.customer!.id == uid &&
              (e.isCanceled ?? false) &&
              !(e.reserved ?? true)) {
            leftMatch = true;
          }
        }).toList();
      }
    }
    bool isCancelled = widget.booking.isCancelled ?? false;
    final color = isCancelled ? AppColors.darkBlue : AppColors.clay05;
    final textColor = isCancelled ? AppColors.white : AppColors.darkBlue;
    final dividerColor = isCancelled ? AppColors.white25 : AppColors.darkBlue.withOpacity(0.05);
    bool isWaiting = widget.booking.requestWaitingList?.isNotEmpty ?? false;
    String typeLevel = (widget.booking.isFriendlyMatch ?? true)
        ? "FRIENDLY".tr(context)
        : "RANKED".tr(context);
    final price = widget.booking.service?.price != null
        ? Utils.formatPrice(widget.booking.service?.price?.toDouble())
        : "-";
    final levelRange = widget.booking.openMatchLevelRange;
    if (levelRange.isNotEmpty) {
      // typeLevel = "$typeLevel | ${"LEVEL".tr(context)} $levelRange";
      typeLevel = "${"LEVEL".tr(context)} $levelRange";
    }

    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWaiting && !isCancelled) ...[
            isApproved
                ? ChangesCancelledListingCard(
                    text: "Approved_To_Join_Join_Now".tr(context))
                : const WaitingForApproval(),
            SizedBox(height: 5.h)
          ],
          if (isCancelled) ...[
            ChangesCancelledListingCard(
              text: "OPEN_MATCH_CANCELLED".tr(context),
            ),
            SizedBox(height: 10.h),
          ],
          if (leftMatch && !isCancelled && !isWaiting) ...[
            ChangesCancelledListingCard(
              text: "YOU_LEFT_THE_MATCH".trU(context),
            ),
            SizedBox(height: 10.h),
          ],
          Row(
            children: [
              Text(
                "OPEN_MATCH".tr(context),
                style: AppTextStyles.sansMedium16.copyWith(color: textColor),
              ),
              const Spacer(),
              Text(
                (widget.booking.service?.location?.locationName ?? "")
                    .capitalizeFirst,
                style: AppTextStyles.sansMedium16.copyWith(color: textColor),
              ),
            ],
          ),
          // SizedBox(height: 1.h),
          CDivider(color: dividerColor,),
          10.verticalSpace,
          OpenMatchParticipantRow(
            textForAvailableSlot: "RESERVE".trU(context),
            players: widget.booking.players ?? [],
            availableSlotbackGroundColor: AppColors.darkBlue,
            availableSlotIconColor: AppColors.white,
            textColor: textColor,
          ),
          // SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                widget.booking.courtName.capitalizeFirst,
                style:
                AppTextStyles.sansRegular13.copyWith(color: textColor),
              ),
              const Spacer(),
              Text(
                widget.booking.formattedDateStartEndTimeAm,
                style: AppTextStyles.sansRegular13.copyWith(color: textColor),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                "${"PRICE".tr(context)} $price",
                style:
                    AppTextStyles.sansRegular13.copyWith(color: textColor),
              ),
              const Spacer(),
              Text(
                typeLevel,
                style:
                    AppTextStyles.sansRegular13.copyWith(color: textColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
