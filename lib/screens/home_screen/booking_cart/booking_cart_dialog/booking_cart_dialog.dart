import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/selected_tag.dart';
import 'package:acepadel/models/multi_booking_model.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_textfield.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import '../../../../components/multi_booking_info_card.dart';
import '../../../../components/secondary_text.dart';
import '../../../../globals/utils.dart';
import '../../../../repository/payment_repo.dart';
import '../../../payment_information/payment_information.dart';
import '../../tabs/play_match_tab/play_match_tab.dart';
import '../cart_booked_dialog.dart';

part 'components.dart';

part 'providers.dart';

class BookingCartDialog extends ConsumerStatefulWidget {
  const BookingCartDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookCourtDialogState();
}

class _BookCourtDialogState extends ConsumerState<BookingCartDialog> {
  @override
  Widget build(BuildContext context) {
    final bookingCartList = ref.watch(fetchBookingCartListProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        maxHeight: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "BOOKING_INFORMATION".tr(context),
              style: AppTextStyles.popupHeaderTextStyle,
            ),
            SizedBox(height: 5.h),
            Text(
              "CANCELLATION_POLICY".tr(context),
              textAlign: TextAlign.center,
              style: AppTextStyles.popupBodyTextStyle,
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${"YOUR_BOOKING_CART_DETAILS".tr(context)}:",
                style: AppTextStyles.popupHeaderTextStyle,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 15.h),
            bookingCartList.when(
              data: (data) {
                Future(() {
                  ref.read(totalMultiBookingAmount.notifier).state =
                      calculateAmountPayable(
                          ref,
                          data.fold(0.0,
                              (sum, item) => sum + (item.totalPrice ?? 0)));
                });
                if (data.isEmpty) {
                  return SecondaryText(
                      text: "NO_BOOKING_CART_FOUND".trU(context));
                }
                return Column(
                  children: [
                    MultiBookingCourtInfoCard(
                        bookings: data, onTapDeleteBooking: _deleteBooking),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "BOOKING_PAYMENT".trU(context),
                        style: AppTextStyles.balooMedium15.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    MainButton(
                      label: "PAY_ALL_BOOKINGS".tr(context),
                      isForPopup: true,
                      onTap: () {
                        _payCourt(data);
                      },
                    )
                  ],
                );
              },
              error: (error, stackTrace) {
                Future(() {
                  ref.read(totalMultiBookingAmount.notifier).state = 0;
                });
                return SecondaryText(
                    text: error.toString(), textColor: AppColors.white);
              },
              loading: () {
                return const CupertinoActivityIndicator(radius: 10);
              },
            ),
          ],
        ),
      ),
    );
  }

  _payCourt(List<MultipleBookings> data) async {
    double price = data.fold(0.0, (sum, item) => sum + (item.totalPrice ?? 0));

    List<MultipleBookings>? multiBookingList = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
          serviceID: data.first.bookingId,
          type: PaymentDetailsRequestType.booking,
          allowMembership: false,
          isMultiBooking: true,
          transactionRequestType: TransactionRequestType.cart,
          locationID: data.first.locationId ?? 0,
          requestType: PaymentProcessRequestType.courtBooking,
          price: price,
          startDate: data.first.bookingStartTime,
          duration: data.first.duration2,
        );
      },
    );
    ref.invalidate(fetchBookingCartListProvider);

    if (multiBookingList != null && mounted) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return CartBookedDialog(
              bookings: multiBookingList.isEmpty ? data : multiBookingList);
        },
      );
    }
  }

  _deleteBooking(MultipleBookings data) async {
    final provider = deleteCartProvider(data.sId ?? "");
    final bool? check = await Utils.showLoadingDialog(context, provider, ref);
    if (!mounted) {
      return;
    }
    if (check == null) {
      return;
    }
    ref.invalidate(fetchBookingCartListProvider);
  }
}
