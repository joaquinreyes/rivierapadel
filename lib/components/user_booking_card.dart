import 'package:acepadel/components/changes_cancelled_listing_card.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/models/court_booking.dart' as bookingModel;
import '../repository/booking_repo.dart' show fetchUserAllBookingsProvider, CourtPriceRequestType;
import '../repository/user_repo.dart';
import '../screens/home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';

class UserBookingCard extends ConsumerWidget {
  const UserBookingCard({super.key, required this.booking});
  final UserBookings booking;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayerPendingPayment = booking.isPlayerPendingPayment(ref);
    bool isCancelled = booking.isCancelled ?? false;
    final color = isCancelled || isPlayerPendingPayment ? AppColors.darkBlue : AppColors.clay05;
    final textColor = isCancelled || isPlayerPendingPayment ? AppColors.white : AppColors.darkBlue;
    final dividerColor = isCancelled || isPlayerPendingPayment ? AppColors.white25 : AppColors.darkBlue.withOpacity(0.05);
    return Container(
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCancelled) ...[
            ChangesCancelledListingCard(
              text: "BOOKING_CANCELLED".tr(context),
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
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.w),
                    style: AppTextStyles.balooMedium13.copyWith(color: AppColors.darkBlue),
                    text: "BOOKING_UNPAID".tr(context),
                  ),
                  MainButton(
                    label: "PAY_NOW".tr(context),
                    onTap: () async {
                      String sportName = "";
                      if ((booking.players ?? []).isNotEmpty &&
                          booking.players!.first.customer!.sportsLevel
                              .isNotEmpty) {
                        sportName = booking.players!.first.customer!.sportsLevel
                            .first.sportName ??
                            "";
                      }

                      dynamic paid = await showDialog(
                        context: context,
                        builder: (context) {
                          return BookCourtDialog(
                            allowPayLater: false,
                            getPendingPayment: true,
                            showRefund: true,
                            coachId: null,
                            courtPriceRequestType: CourtPriceRequestType.join,
                            bookings: bookingModel.Bookings(
                                id: booking.id,
                                price: booking.service!.price,
                                duration: booking.duration2,
                                isOpenMatch: true,
                                sport: bookingModel.Sport(sportName: sportName),
                                location: bookingModel.Location(
                                    id: booking.service!.location!.id,
                                    location: booking
                                        .service!.location!.locationName)),
                            bookingTime: booking.bookingStartTime,
                            court: {
                              (booking.courts ?? []).first.id ?? 0:
                              (booking.courts ?? []).first.courtName ?? ""
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
                    labelStyle: AppTextStyles.balooMedium14.copyWith(color: AppColors.white),
                    padding: EdgeInsets.zero,
                  )
                ],
              ),
            ),
          Row(
            children: [
              Text(
                "BOOKING".tr(context),
                style: AppTextStyles.sansMedium16.copyWith(
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                (booking.service?.location?.locationName ?? "").toUpperCase(),
                style: AppTextStyles.balooMedium14.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
          // SizedBox(height: 1.h),
          CDivider(color: dividerColor,),
          SizedBox(height: 5.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.courtName.capitalizeFirst,
                    style: AppTextStyles.sansRegular13.copyWith(
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${"PRICE".tr(context)} ${Utils.formatPrice(booking.pricePaid(ref))}",
                    style: AppTextStyles.sansRegular13.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    booking.formatBookingDate,
                    style: AppTextStyles.sansRegular13.copyWith(
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    booking.formatStartEndTimeAm,
                    style: AppTextStyles.sansRegular13.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
