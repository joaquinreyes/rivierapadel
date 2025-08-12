import 'package:acepadel/models/multi_booking_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import '../../../app_styles/app_text_styles.dart';
import '../../../repository/booking_repo.dart';
import 'booking_cart_dialog/booking_cart_dialog.dart';

class BookingCart extends ConsumerStatefulWidget {
  const BookingCart({super.key});

  @override
  ConsumerState<BookingCart> createState() => BookingCartState();
}

class BookingCartState extends ConsumerState<BookingCart> {
  @override
  Widget build(BuildContext context) {
    List<MultipleBookings> bookingCartList = [];
    ref
        .watch(fetchBookingCartListProvider)
        .whenData((e) => bookingCartList = e);
    if (bookingCartList.isEmpty) {
      return const SizedBox();
    }
    final count =
        // bookingCartList.length > 9 ? "9+" :
        bookingCartList.length.toString();
    return InkWell(
      onTap: () {
        _onTap(bookingCartList);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: AppColors.yellow,
          boxShadow: [
            BoxShadow(
              color: AppColors.green25.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("BOOKING_CART".tr(context),
                style: AppTextStyles.panchangBold12.copyWith(
                  color: AppColors.green,
                )),
            SizedBox(width: 5.w),
            Container(
              // width: 20.w,
              // height: 20.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.green, shape: BoxShape.circle),
              padding: EdgeInsets.all(6.w),
              child: Text(count,
                  style: AppTextStyles.panchangBold10.copyWith(
                    color: AppColors.yellow,
                  )),
            ),
            SizedBox(width: 10.w),
            const Icon(Icons.keyboard_arrow_up, color: AppColors.green)
          ],
        ),
      ),
    );
  }

  _onTap(List<MultipleBookings> list) {
    showDialog(
      context: context,
      builder: (context) {
        return const BookingCartDialog();
      },
    );
  }
}
