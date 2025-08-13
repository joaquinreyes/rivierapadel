import 'package:acepadel/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../../../components/multi_booking_info_card.dart';
import '../../../models/multi_booking_model.dart';

class CartBookedDialog extends ConsumerStatefulWidget {
  const CartBookedDialog({super.key, required this.bookings});
  final List<MultipleBookings> bookings;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CourtBookedDialogState();
}

class _CourtBookedDialogState extends ConsumerState<CartBookedDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "BOOKING_CONFIRMED".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "CANCELLATION_POLICY".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          MultiBookingCourtInfoCard(
            bookings: widget.bookings,
            color: AppColors.oak,
            textColor: AppColors.white,
            dividerColor: AppColors.white25,
            showDelete: false,
          ),
          SizedBox(height: 20.h),
          SecondaryImageButton(
            label: "SEE_MY_MATCHES".tr(context),
            image: AppImages.tennisBall.path,
            imageHeight: 13.h,
            imageWidth: 13.h,
            isForPopup: true,
            onTap: () {
              Future(() {
                ref.read(pageControllerProvider).animateToPage(
                      2,
                      duration: kAnimationDuration,
                      curve: Curves.linear,
                    );
                ref.read(pageIndexProvider.notifier).index = 2;
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
