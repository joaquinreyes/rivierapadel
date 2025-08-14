import 'package:acepadel/components/changes_cancelled_listing_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class UserBookingCard extends StatelessWidget {
  const UserBookingCard({super.key, required this.booking});
  final UserBookings booking;
  @override
  Widget build(BuildContext context) {
    bool isCancelled = booking.isCancelled ?? false;
    final color = isCancelled ? AppColors.darkBlue : AppColors.clay05;
    final textColor = isCancelled ? AppColors.white : AppColors.darkBlue;
    final dividerColor = isCancelled ? AppColors.white25 : AppColors.darkBlue.withOpacity(0.05);
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
                    "${"PRICE".tr(context)} ${Utils.formatPrice(booking.service?.price?.toDouble())}",
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
