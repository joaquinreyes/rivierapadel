part of 'payment_information.dart';

class _AmountPayable extends ConsumerWidget {
  const _AmountPayable({
    required this.originalAmount,
  });

  final double originalAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mdr = ref.watch(_selectedMDR);
    double payableAmount = ref.watch(totalMultiBookingAmount);
    if (payableAmount == 0) {
      ref.read(goRouterProvider).pop();
    }
    if (mdr != null) {
      payableAmount += Utils.calculateMDR(payableAmount, mdr);
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            "AMOUNT_PAYABLE".tr(context),
            style: AppTextStyles.gothamRegular14,
          ),
          const Spacer(),
          if (originalAmount > payableAmount) ...[
            Text(
              Utils.formatPrice(originalAmount),
              style: AppTextStyles.gothamRegular12.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
            SizedBox(width: 4.h),
          ],
          Text(
            Utils.formatPrice(payableAmount),
            style: AppTextStyles.gothamRegular14,
          ),
        ],
      ),
    );
  }
}

class _PaymentButton extends ConsumerStatefulWidget {
  const _PaymentButton({
    required this.locationID,
    required this.price,
    required this.requestType,
    required this.isVoucherPurchase,
    required this.transactionRequestType,
    required this.isMultiBooking,
    this.serviceID,
    required this.isJoiningApproval,
  });

  final int locationID;
  final bool isMultiBooking;
  final bool isVoucherPurchase;
  final double price;
  final int? serviceID;
  final PaymentProcessRequestType requestType;
  final TransactionRequestType transactionRequestType;
  final bool isJoiningApproval;

  @override
  ConsumerState<_PaymentButton> createState() => __PaymentButtonState();
}

class __PaymentButtonState extends ConsumerState<_PaymentButton> {
  bool get isButtonEnabled {
    final selectedMethod = ref.watch(_selectedPaymentMethod);
    final isRedeemSelected = ref.watch(_selectedRedeem) != null;
    if (selectedMethod == null) {
      return false;
    }
    if (isRedeemSelected &&
        (selectedMethod.methodType == kPayLaterMethod ||
            selectedMethod.methodType == kWalletMethod)) {
      return false;
    }
    if (selectedMethod.methodType == kWalletMethod) {
      return getAmountByCoupon(ref, widget.price) <=
          (selectedMethod.walletBalance ?? 0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MainButton(
      enabled: isButtonEnabled,
      label: "PROCEED_WITH_PAYMENT".tr(context).capitalEnabled(context, canProceed: isButtonEnabled),
      isForPopup: true,
      onTap: () {
        if (widget.isMultiBooking) {
          _onPayMultiBookingTap();
        } else if (widget.isVoucherPurchase) {
          _onPayVoucherTap();
        } else {
          _onPayTap();
        }
      },
    );
  }

  void _onPayVoucherTap() async {
    final selectedPaymentType = ref.read(_selectedPaymentMethod);
    if (selectedPaymentType == null) return;
    selectedPaymentType.amountToPay = widget.price;
    PurchaseVoucherAPIProvider provider = purchaseVoucherAPIProvider(
      totalAmount: widget.price,
      voucherId: widget.serviceID ?? 0,
      locationId: widget.locationID,
      paymentMethod: selectedPaymentType,
    );
    final data = await Utils.showLoadingDialog(context, provider, ref);
    if (data == null) {
      return;
    }
    if (data is! (bool, String)) {
      return;
    }
    final (check, redirectURL) = data;
    if (check && mounted) {
      await _midTranProcess(redirectURL);
    }
  }

  void _onPayTap() async {
    late PaymentProcessProvider provider;
    final selectedPaymentType = ref.read(_selectedPaymentMethod);
    if (selectedPaymentType == null) return;
    if (selectedPaymentType.methodType == kPayLaterMethod) {
      provider = _payLaterProvider();
    } else {
      provider = _normalPaymentProvider(selectedPaymentType);
    }
    final data = await Utils.showLoadingDialog(context, provider, ref);
    if (data == null) {
      return;
    }
    final (id, redirectURL, amount) = data;
    if (redirectURL != null && id == null && mounted) {
      await _midTranProcess(redirectURL);
    }
    if (id != null && redirectURL == null && mounted) {
      Navigator.pop(context, (id, amount));
    }
  }

  void _onPayMultiBookingTap() async {
    late MultiBookingPaymentProcessProvider provider;
    final selectedPaymentType = ref.read(_selectedPaymentMethod);
    if (selectedPaymentType == null) return;
    if (selectedPaymentType.methodType == kPayLaterMethod) {
      provider = _payLaterProvider();
    } else {
      provider = _normalPaymentProvider(selectedPaymentType);
    }
    final data = await Utils.showLoadingDialog(context, provider, ref,
        barrierDismissible: false);
    if (data == null) {
      ref.invalidate(fetchBookingCartListProvider);
      return;
    }
    if (data is String &&
        data == "Oops! One Of Your Selected Bookings Was Taken") {
      ref.read(goRouterProvider).pop();
      return;
    }
    final (id, redirectURL) = data;
    if (redirectURL != null && id == null && mounted) {
      await _midTranProcess(redirectURL);
    }
    if (id != null && redirectURL == null && mounted) {
      Navigator.pop(context, id);
    }
  }

  dynamic _payLaterProvider() {
    final couponID = ref.read(_appliedCoupon)?.couponId;
    if (widget.isMultiBooking) {
      return multiBookingPaymentProcessProvider(
        totalAmount: widget.price,
        payLater: true,
        requestType: widget.requestType,
        serviceID: widget.serviceID,
        isJoiningApproval: widget.isJoiningApproval,
        couponID: couponID,
      );
    }
    return paymentProcessProvider(
      totalAmount: widget.price,
      payLater: true,
      requestType: widget.requestType,
      serviceID: widget.serviceID,
      isJoiningApproval: widget.isJoiningApproval,
      couponID: couponID,
    );
  }

  dynamic _normalPaymentProvider(AppPaymentMethods selectedPaymentType) {
    final redeemMethod = ref.read(_selectedRedeem);
    final appliedCoupon = ref.read(_appliedCoupon);
    final List<AppPaymentMethods> paymentMethods = [];

    if (redeemMethod != null) {
      paymentMethods.add(AppPaymentMethods(
        id: redeemMethod.id,
        methodType: kWalletMethod,
        amountToPay: (redeemMethod.walletBalance ?? 0.0),
      ));
      selectedPaymentType.amountToPay =
          widget.price - (redeemMethod.walletBalance ?? 0.0);
    } else {
      selectedPaymentType.amountToPay = widget.price;
    }

    paymentMethods.add(selectedPaymentType);

    if (widget.isMultiBooking && paymentMethods.isNotEmpty) {
      return multiBookingPaymentProcessProvider(
        totalAmount: widget.price,
        paymentMethod: paymentMethods.first,
        requestType: widget.requestType,
        serviceID: widget.serviceID,
        isJoiningApproval: widget.isJoiningApproval,
        couponID: appliedCoupon?.couponId,
      );
    }
    if (widget.isVoucherPurchase && paymentMethods.isNotEmpty) {
      return multiBookingPaymentProcessProvider(
        totalAmount: widget.price,
        paymentMethod: paymentMethods.first,
        requestType: widget.requestType,
        serviceID: widget.serviceID,
        isJoiningApproval: widget.isJoiningApproval,
        couponID: appliedCoupon?.couponId,
      );
    }

    return paymentProcessProvider(
      totalAmount: widget.price,
      paymentMethod: paymentMethods,
      requestType: widget.requestType,
      serviceID: widget.serviceID,
      isJoiningApproval: widget.isJoiningApproval,
      couponID: appliedCoupon?.couponId,
    );
  }

  Future<void> _midTranProcess(String redirectURL) async {
    MidtransHelper midTransHelper = MidtransMobilePaymentHelper();

    Map<String, dynamic>? params = await midTransHelper.handleRedirectURL(
      url: redirectURL,
      context: context,
      ref: ref,
    );
    if (params != null && mounted) {
      final provider = fetchServiceIDWithTransactionIDProvider(
          orderID: params["order_id"],
          statusCode: params["status_code"],
          requestType: widget.transactionRequestType,
          transactionStatus: params["transaction_status"]);
      final int? id = await Utils.showLoadingDialog(context, provider, ref);
      if (id != null && mounted) {
        if (widget.isMultiBooking && id == -1) {
          Navigator.pop(context, <MultipleBookings>[]);
        } else if (widget.isVoucherPurchase && id == -1) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, id);
        }
      }
    } else {
      if (mounted) {
        Utils.showMessageDialog(
          context,
          "Payment failed or canceled".tr(context),
        );
      }
    }
  }
}

class _CouponApplyButton extends ConsumerWidget {
  const _CouponApplyButton({
    required this.price,
    required this.couponController,
  });

  final double price;
  final TextEditingController couponController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInvalidCoupon = ref.watch(_invalidCoupon);
    return InkWell(
      onTap: () async {
        if (couponController.text.isEmpty) {
          return;
        }
        final done = await Utils.showLoadingDialog(
          context,
          verifyCouponProvider(
            coupon: couponController.text,
            price: price,
          ),
          ref,
        );
        if (done is CouponModel) {
          done.coupon = couponController.text;
          ref.read(_appliedCoupon.notifier).state = done;
          ref.read(_invalidCoupon.notifier).state = false;
        } else {
          ref.read(_invalidCoupon.notifier).state = true;
        }
        ref.read(totalMultiBookingAmount.notifier).state =
            calculateAmountPayable(ref, price);
      },
      child: isInvalidCoupon
          ? Image.asset(
              AppImages.crossIcon.path,
              width: 18.w,
              height: 18.w,
              color: AppColors.errorColor,
            )
          : Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.unselectedTag.path,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
    );
  }
}
