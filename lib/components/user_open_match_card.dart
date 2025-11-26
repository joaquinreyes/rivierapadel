import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/waiting_for_approval.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/models/court_booking.dart' as bookingModel;
import '../managers/user_manager.dart';
import '../models/court_booking.dart';
import '../models/lesson_model_new.dart';
import '../repository/booking_repo.dart';
import '../repository/user_repo.dart';
import '../screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
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
    final isPlayerPendingPayment = widget.booking.isPlayerPendingPayment(ref);
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
    final color = isCancelled || isPlayerPendingPayment
        ? AppColors.darkBlue
        : AppColors.clay05;
    final textColor = isCancelled || isPlayerPendingPayment
        ? AppColors.white
        : AppColors.darkBlue;
    final dividerColor = isCancelled || isPlayerPendingPayment
        ? AppColors.white25
        : AppColors.darkBlue.withOpacity(0.05);
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
          if (isPlayerPendingPayment)
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangesCancelledListingCard(
                    color: AppColors.white,
                    isUpperCase: false,
                    iconColor: AppColors.darkBlue,
                    textColor: AppColors.darkBlue,
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.w),
                    style: AppTextStyles.balooMedium13
                        .copyWith(color: AppColors.darkBlue),
                    text: "BOOKING_UNPAID".tr(context),
                  ),
                  MainButton(
                    label: "PAY_NOW".tr(context),
                    onTap: () async {
                      String sportName = "";
                      if ((widget.booking.players ?? []).isNotEmpty &&
                          widget.booking.players!.first.customer!.sportsLevel
                              .isNotEmpty) {
                        sportName = widget.booking.players!.first.customer!.sportsLevel
                            .first.sportName ??
                            "";
                      }

                      List<Courts> listCourts = [];

                      (widget.booking.courts ?? []).map((e) {
                        listCourts.add(
                             Courts.fromJson(e.toJson()));
                      }).toList();

                      dynamic paid = await showDialog(
                        context: context,
                        builder: (context) {
                          return BookCourtDialog(
                            getPendingPayment: true,
                            allowPayLater: false,
                            showRefund: true,
                            coachId: null,
                            defaultOpenMatch: true,
                            courtPriceRequestType: CourtPriceRequestType.join,
                            bookings: bookingModel.Bookings(
                                id: widget.booking.id,
                                price: widget.booking.service!.price,
                                duration: widget.booking.duration2,
                                isOpenMatch: true,
                                sport: bookingModel.Sport(sportName: sportName),
                                location: bookingModel.Location(
                                    id: widget.booking.service!.location!.id,
                                    courts: listCourts,
                                    location: widget.booking
                                        .service!.location!.locationName)),
                            bookingTime: widget.booking.bookingStartTime,
                            court: {
                              (widget.booking.courts ?? []).first.id ?? 0:
                              (widget.booking.courts ?? []).first.courtName ?? ""
                            },
                          );
                        },
                      );

                      if (paid is bool && paid) {
                        Utils.showMessageDialog(
                            context, "YOU_HAVE_PAID_SUCCESSFULLY".tr(context));
                        ref.invalidate(fetchUserAllBookingsProvider);
                        ref.invalidate(walletInfoProvider);
                      }
                    },
                    width: 85.w,
                    height: 30.h,
                    isForPopup: true,
                    labelStyle: AppTextStyles.balooMedium14
                        .copyWith(color: AppColors.white),
                    padding: EdgeInsets.zero,
                  )
                ],
              ),
            ),
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
          CDivider(
            color: dividerColor,
          ),
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
                style: AppTextStyles.sansRegular13.copyWith(color: textColor),
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
                style: AppTextStyles.sansRegular13.copyWith(color: textColor),
              ),
              const Spacer(),
              Text(
                typeLevel,
                style: AppTextStyles.sansRegular13.copyWith(color: textColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
