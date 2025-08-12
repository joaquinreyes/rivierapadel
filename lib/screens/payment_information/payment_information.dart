import 'dart:developer';

import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/secondary_textfield.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/models/coupon_model.dart';
import 'package:acepadel/models/multi_booking_model.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:acepadel/screens/payment_information/midtrans_helper/midtrans_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/payment_methods.dart';
import 'package:acepadel/repository/payment_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../home_screen/booking_cart/booking_cart_dialog/booking_cart_dialog.dart';

part 'components.dart';

final _selectedPaymentMethod = StateProvider<AppPaymentMethods?>((ref) => null);
final _selectedRedeem = StateProvider<AppPaymentMethods?>((ref) => null);
final _selectedWalelt = StateProvider<Wallets?>((ref) => null);
final _appliedCoupon = StateProvider<CouponModel?>((ref) => null);
final _invalidCoupon = StateProvider<bool>((ref) => false);
final _selectedMDR = StateProvider<MDRRates?>((ref) => null);

class PaymentInformation extends ConsumerStatefulWidget {
  const PaymentInformation({
    super.key,
    required this.type,
    required this.locationID,
    required this.price,
    required this.requestType,
    required this.serviceID,
    required this.transactionRequestType,
    this.isVoucherPurchase = false,
    required this.duration,
    required this.startDate,
    this.isJoiningApproval = false,
    this.allowMembership = true,
    this.allowCoupon = true,
    this.allowPayLater = true,
    this.allowWallet = true,
    this.isMultiBooking = false,
  });

  final int locationID;
  final PaymentDetailsRequestType type;
  final bool isVoucherPurchase;
  final bool isMultiBooking;
  final TransactionRequestType transactionRequestType;

  final bool allowCoupon;
  final bool allowWallet;
  final bool allowPayLater;
  final double price;
  final int? serviceID;
  final PaymentProcessRequestType requestType;
  final bool isJoiningApproval;
  final DateTime? startDate;
  final int? duration;
  final bool allowMembership;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentInformationState();
}

class _PaymentInformationState extends ConsumerState<PaymentInformation> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    Future(() {
      ref.read(_selectedPaymentMethod.notifier).state = null;
      ref.read(_selectedRedeem.notifier).state = null;
      ref.read(_selectedWalelt.notifier).state = null;
      ref.read(_appliedCoupon.notifier).state = null;
      ref.read(_invalidCoupon.notifier).state = false;
      ref.read(_selectedMDR.notifier).state = null;
      ref.read(totalMultiBookingAmount.notifier).state =
          calculateAmountPayable(ref, widget.price);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paymentDetails = ref.watch(fetchPaymentDetailsProvider(
        widget.locationID,
        widget.type,
        widget.serviceID ?? 0,
        widget.startDate,
        widget.duration));

    return CustomDialog(
      maxHeight: MediaQuery.of(context).size.height,
      child: Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PAYMENT_INFORMATION".tr(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Text(
              "PAYMENT_INFORMATION_TEXT".tr(context),
              style: AppTextStyles.popupBodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            paymentDetails.when(
              data: (data) => Flexible(
                child: _body(data),
              ),
              error: (error, stackTrace) => SecondaryText(
                  text: error.toString(), textColor: AppColors.white),
              loading: () => const Center(
                  child: CupertinoActivityIndicator(color: AppColors.white25)),
            ),
          ],
        ),
      ),
    );
  }

  Column _body(PaymentDetails data) {
    final appliedCoupon = ref.watch(_appliedCoupon);
    ref.watch(_selectedRedeem);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isMultiBooking && widget.allowCoupon)
          Column(children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: RichText(
                text: TextSpan(
                  text: "COUPON".tr(context),
                  style: AppTextStyles.panchangMedium12.copyWith(
                    color: AppColors.white,
                  ),
                  children: [
                    TextSpan(
                      text: " ${"OPTIONAL".tr(context)}",
                      style: AppTextStyles.helveticaLight13.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            SecondaryTextField(
              hintText: "ENTER_COUPON_HERE".tr(context),
              // isEnabled,
              controller: _couponController,
              onChanged: (_) {
                setState(() {});
                ref.read(_appliedCoupon.notifier).state = null;
                ref.read(_invalidCoupon.notifier).state = false;
                ref.read(totalMultiBookingAmount.notifier).state =
                    calculateAmountPayable(ref, widget.price);
              },
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (appliedCoupon == null ||
                      _couponController.text != appliedCoupon.coupon) ...[
                    _CouponApplyButton(
                      price: widget.price,
                      couponController: _couponController,
                    ),
                  ] else ...[
                    Image.asset(
                      AppImages.checkMark.path,
                      width: 18.w,
                      height: 18.w,
                    ),
                  ],
                  SizedBox(width: 4.w),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ]),
        _AmountPayable(
          originalAmount: widget.price,
          // payableAmount: _calculateAmountPayable(),
        ),
        SizedBox(height: 20.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "PAYMENT_METHOD".tr(context),
            style: AppTextStyles.panchangMedium12.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Flexible(
          child: _buildPaymentMethodCard(data),
        ),
        SizedBox(height: 5.h),
        Flexible(
          child: _PaymentButton(
            transactionRequestType: widget.transactionRequestType,
            isVoucherPurchase: widget.isVoucherPurchase,
            isMultiBooking: widget.isMultiBooking,
            price: widget.price,
            requestType: widget.requestType,
            serviceID: widget.serviceID,
            locationID: widget.locationID,
            isJoiningApproval: widget.isJoiningApproval,
          ),
        )
      ],
    );
  }

  _buildPaymentMethodCard(PaymentDetails paymentDetails) {
    return Column(
      children: [
        if (widget.allowMembership)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentDetails.userMemberships?.length ?? 0,
            itemBuilder: (context, index) {
              final userMembership = paymentDetails.userMemberships?[index];
              if (userMembership == null) {
                return const SizedBox();
              }
              final paymentMethod = AppPaymentMethods(
                id: userMembership.membership?.id,
                membershipId: userMembership.id,
                methodType: kMembershipMethod,
                methodTypeText: userMembership.membership?.membershipName,
              );

              // if (!PlatformC().isCurrentDesignPlatformDesktop &&
              //     !PlatformC().isCurrentOSMobile) {
              //   if (paymentMethod.methodType == "gopay") {
              //     return Container();
              //   }
              // }
              // final mdr = paymentDetails.getMdr(paymentMethod.methodType ?? "");
              return _buildPaymentOption(paymentMethod);
            },
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paymentDetails.appPaymentMethods?.length ?? 0,
          itemBuilder: (context, index) {
            final paymentMethod = paymentDetails.appPaymentMethods?[index];
            if (paymentMethod == null) {
              return const SizedBox();
            }
            if (!PlatformC().isCurrentDesignPlatformDesktop &&
                !PlatformC().isCurrentOSMobile) {
              if (paymentMethod.methodType == "gopay") {
                return Container();
              }
            }
            final mdr = paymentDetails.getMdr(paymentMethod.methodType ?? "");
            return _buildPaymentOption(paymentMethod, mdr: mdr);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentOption(AppPaymentMethods paymentMethod, {MDRRates? mdr}) {
    final selectedPaymentMethod = ref.watch(_selectedPaymentMethod);
    final selectedRedeemMethod = ref.watch(_selectedRedeem);
    final isRedeemSelected = selectedRedeemMethod != null;

    String title = _getPaymentMethodTitle(paymentMethod, isRedeemSelected);
    bool isSelected = selectedPaymentMethod?.id == paymentMethod.id;
    bool isRedeemAvailable = _isRedeemAvailable(paymentMethod);

    if (isRedeemAvailable) {
      if (widget.isMultiBooking || !widget.allowWallet) {
        return const SizedBox();
      }
      return _buildRedeemOption(
        title: title,
        isSelected: isRedeemSelected,
        imagePath: AppImages.walletIcon.path,
        onTap: () => _toggleRedeemSelection(isRedeemSelected, paymentMethod),
      );
    }

    if (paymentMethod.methodType == kPayLaterMethod && isRedeemSelected) {
      return const SizedBox(); // Hide "Pay Later" if redeem is selected
    }
    if (paymentMethod.methodType == kPayLaterMethod && !widget.allowPayLater) {
      return const SizedBox(); // Hide "Pay Later" if redeem is selected
    }

    if (paymentMethod.methodType == kWalletMethod && !widget.allowWallet) {
      return const SizedBox(); // Hide "Pay Later" if redeem is selected
    }

    return _buildPaymentMethodOption(
      title: title,
      isSelected: isSelected,
      imagePath: AppImages.walletIcon.path,
      onTap: () => _selectPaymentMethod(paymentMethod, mdr: mdr),
      mdr: mdr,
    );
  }

  String _getPaymentMethodTitle(
      AppPaymentMethods paymentMethod, bool isRedeemSelected) {
    if (paymentMethod.methodType == kWalletMethod) {
      final walletBalance = paymentMethod.walletBalance ?? 0.0;
      return getAmountByCoupon(ref, widget.price) > walletBalance
          ? "${"REDEEM_CREDITS".tr(context)} ${Utils.formatPrice(walletBalance)}"
          : "${"WALLET".tr(context)} ${Utils.formatPrice(walletBalance)}";
    } else if (paymentMethod.methodType == kPayLaterMethod) {
      return "PAY_LATER".tr(context);
    } else {
      return (paymentMethod.methodTypeText ?? "").capitalizeFirst;
    }
  }

  bool _isRedeemAvailable(AppPaymentMethods paymentMethod) {
    final walletBalance = paymentMethod.walletBalance ?? 0.0;
    return paymentMethod.methodType == kWalletMethod &&
        getAmountByCoupon(ref, widget.price) > walletBalance;
  }

  void _toggleRedeemSelection(
      bool isRedeemSelected, AppPaymentMethods paymentMethod) {
    if ((paymentMethod.walletBalance ?? 0) == 0) {
      return;
    }
    ref.read(_selectedRedeem.notifier).state =
        isRedeemSelected ? null : paymentMethod;
  }

  void _selectPaymentMethod(AppPaymentMethods paymentMethod, {MDRRates? mdr}) {
    ref.read(_selectedPaymentMethod.notifier).state = paymentMethod;
    ref.read(_selectedMDR.notifier).state = mdr;
  }

  Widget _buildPaymentMethodOption({
    required String title,
    required bool isSelected,
    required String imagePath,
    required VoidCallback onTap,
    MDRRates? mdr,
  }) {
    return _buildOptionContainer(
      title: title,
      isSelected: isSelected,
      imagePath: imagePath,
      onTap: onTap,
      mdr: mdr,
    );
  }

  Widget _buildRedeemOption({
    required String title,
    required bool isSelected,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return _buildOptionContainer(
      title: title,
      isSelected: isSelected,
      imagePath: imagePath,
      onTap: onTap,
      showSwitch: true,
    );
  }

  Widget _buildOptionContainer({
    required String title,
    required bool isSelected,
    required String imagePath,
    required VoidCallback onTap,
    bool showSwitch = false,
    MDRRates? mdr,
  }) {
    double? payableAmount = calculateAmountPayable(ref, widget.price);

    if (mdr != null) {
      payableAmount = Utils.calculateMDR(payableAmount, mdr);
    } else {
      payableAmount = null;
    }
    String? imagePath = mdr?.iconUrl;
    final walletImage = Image.asset(
      AppImages.walletIcon.path,
      width: 26.w,
      height: 26.w,
      color: isSelected ? AppColors.darkGreen : Colors.white,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(5.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow50Popup : AppColors.white25,
          borderRadius: BorderRadius.circular(5.r),
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
          horizontal: 10.w,
        ),
        child: Row(
          children: [
            if (imagePath != null) ...[
              Image.network(
                imagePath,
                width: 34.w,
                height: 34.w,
                fit: BoxFit.fitWidth,
              ),
            ] else ...[
              walletImage,
            ],
            SizedBox(width: imagePath != null ? 8.w : 15.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.helveticaRegular14.copyWith(
                    color: isSelected ? AppColors.darkGreen : AppColors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (payableAmount != null) ...[
              Text(
                Utils.formatPrice(payableAmount),
                style: AppTextStyles.helveticaLight12.copyWith(
                  color: isSelected ? AppColors.darkGreen : AppColors.white,
                ),
              ),
            ],
            if (showSwitch)
              SizedBox(
                height: 22.h,
                child: CupertinoSwitch(
                  value: isSelected,
                  thumbColor: AppColors.white,
                  activeColor: AppColors.yellow,
                  trackColor: AppColors.white25,
                  onChanged: (_) => onTap(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

double getAmountByCoupon(WidgetRef ref, double price) {
  final coupon = ref.watch(_appliedCoupon);
  double payableAmount = price;
  if (coupon != null) {
    payableAmount -= coupon.discount ?? 0;
  }
  return payableAmount;
}

double calculateAmountPayable(WidgetRef ref, double price) {
  final coupon = ref.watch(_appliedCoupon);
  final redeem = ref.watch(_selectedRedeem);
  double payableAmount = price;
  if (coupon != null) {
    payableAmount -= coupon.discount ?? 0;
  }
  if (redeem != null) {
    payableAmount -= redeem.walletBalance ?? 0;
  }
  return payableAmount;
}
