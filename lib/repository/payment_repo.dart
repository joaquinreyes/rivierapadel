import 'package:acepadel/models/coupon_model.dart';
import 'package:acepadel/models/multi_booking_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/user_manager.dart';

import 'package:acepadel/models/payment_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../globals/constants.dart';

part 'payment_repo.g.dart';

enum PaymentProcessRequestType {
  join,
  reserved,
  courtBooking;

  String get value {
    switch (this) {
      case join:
        return "Join";
      case reserved:
        return "Reserved";
      case courtBooking:
        return "Court Booking";
    }
  }
}

enum PaymentDetailsRequestType {
  booking,
  lesson,
  join;

  String get value {
    switch (this) {
      case join:
        return "Join";
      case lesson:
        return "Lesson";
      case booking:
        return "Booking";
    }
  }
}

class PaymentRepo {
  Future<PaymentDetails> fetchPaymentDetails(
      int locationID,
      Ref ref,
      PaymentDetailsRequestType type,
      int id,
      DateTime? startDate,
      int? duration) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final Map<String, dynamic> queryParams = {
        "booking_type": type.value,
        "booking_id": id,
      };

      if (startDate != null) {
        queryParams["date"] = startDate.format(kFormatForAPI);
        queryParams["start_time"] = startDate.format("HH:mm:ss");
        if (duration != null) {
          final endTime =
              startDate.add(Duration(minutes: duration)).format("HH:mm:ss");
          queryParams["end_time"] =
              endTime == "00:00:00" ? "24:00:00" : endTime;
        }
      }

      final response = await ref.read(apiManagerProvider).get(
        ref,
        isV2Version: true,
        ApiEndPoint.paymentDetails,
        token: token,
        queryParams: queryParams,
        pathParams: [locationID.toString()],
      );
      return PaymentDetails.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<(int?, String?, double?)> paymentProcess(Ref ref,
      {required PaymentProcessRequestType requestType,
      bool? payLater,
      List<AppPaymentMethods>? paymentMethod,
      double? totalAmount,
      int? serviceID,
      bool isJoiningApproval = false,
      int? couponID}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final Map<String, dynamic> data = {};
      data['total_amount'] = totalAmount;
      if (payLater == true && paymentMethod != null) {
        throw 'Can not use pay later with other payment methods';
      }
      if (payLater == true) {
        data['pay_on_arrival'] = true;
      } else if (paymentMethod != null) {
        data["payments"] =
            paymentMethod.map((e) => e.toJsonForProcess()).toList();
      }
      if (couponID != null) {
        data['coupon_id'] = couponID;
      }
      final Map<String, dynamic> queryParams = {};
      if (requestType != PaymentProcessRequestType.courtBooking) {
        queryParams['request_type'] = requestType.value;
        queryParams['service_booking_id'] = serviceID;
        if (isJoiningApproval) {
          queryParams['joninning_approval'] = isJoiningApproval;
        }
      }

      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.paymentsProcess,
            data,
            isV2Version: true,
            token: token,
            queryParams: queryParams,
          );
      // final id = response['data']['service']['serviceBookings'][0]['id'];
      if (payLater == true || paymentMethod?.last.methodType == kWalletMethod) {
        final id =
            response['data']['service']['serviceBookings'][0]['id'] as int;
        return (id, null, _extractServiceBookingID(response));
      } else if (paymentMethod
              ?.indexWhere((e) => e.methodType == kMembershipMethod) !=
          -1) {
        final id =
            response['data']['service']['serviceBookings'][0]['id'] as int;
        return (id, null, _extractServiceBookingID(response));
      } else {
        final redirectURL = response['data']['gatewayUrl'] as String;
        return (null, redirectURL, null);
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  // Helper method to extract service booking ID
  double? _extractServiceBookingID(dynamic response) {
    double? amount;
    if (response['data']['service']['serviceBookings'][0]["players"] is List) {
      amount = response['data']['service']['serviceBookings'][0]["players"]
          .fold(
              0,
              (previousValue, element) =>
                  (double.parse((previousValue ?? 0).toString())) +
                  (element["paid_price"] ?? 0));
    }
    return amount;
  }

  Future<(List<MultipleBookings>?, String?)> multiBookingPaymentProcess(Ref ref,
      {required PaymentProcessRequestType requestType,
      bool? payLater,
      AppPaymentMethods? paymentMethod,
      double? totalAmount,
      int? serviceID,
      bool isJoiningApproval = false,
      int? couponID}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final Map<String, dynamic> data = {};
      data['total_amount'] = totalAmount;
      if (payLater == true && paymentMethod != null) {
        throw 'Can not use pay later with other payment methods';
      }
      if (payLater == true) {
        data['pay_on_arrival'] = true;
      } else if (paymentMethod != null) {
        data["payments"] = paymentMethod.toJsonForProcess();
      }
      if (couponID != null) {
        data['coupon_id'] = couponID;
      }
      final Map<String, dynamic> queryParams = {};
      if (requestType != PaymentProcessRequestType.courtBooking) {
        queryParams['request_type'] = requestType.value;
        queryParams['service_booking_id'] = serviceID;
        if (isJoiningApproval) {
          queryParams['joninning_approval'] = isJoiningApproval;
        }
      }

      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.multiBookingPaymentsProcess,
            data,
            token: token,
            queryParams: queryParams,
          );
      if (payLater == true || paymentMethod?.methodType == kWalletMethod) {
        List<MultipleBookings> list = [];
        if (response['data'] != null && response['data'] is List) {
          response['data']
              .map((e) => list.add(MultipleBookings.fromJson(e)))
              .toList();
        }
        return (list, null);
      } else {
        final redirectURL = response['data'] as String;
        return (null, redirectURL);
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<(bool, String)> purchaseVoucherAPI(Ref ref,
      {required AppPaymentMethods paymentMethod,
      required double totalAmount,
      required int voucherId,
      required int locationId}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final Map<String, dynamic> data = {};
      data['total_amount'] = totalAmount;
      data["payments"] = paymentMethod.toJsonForProcess();
      final response = await ref.read(apiManagerProvider).post(
        ref,
        ApiEndPoint.purchaseVoucherProcess,
        data,
        token: token,
        pathParams: [voucherId.toString(), locationId.toString()],
      );
      return (true, response['data']['gatewayUrl'] as String);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<CouponModel> verifyCoupon(Ref ref, String coupon, double price) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.couponsVerify,
            {'coupon_name': coupon, 'price': price},
            token: token,
          );
      return CouponModel.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@riverpod
PaymentRepo paymentRepo(Ref ref) => PaymentRepo();

@riverpod
Future<PaymentDetails> fetchPaymentDetails(
    FetchPaymentDetailsRef ref,
    int locationID,
    PaymentDetailsRequestType type,
    int id,
    DateTime? startDate,
    int? duration) {
  return ref
      .read(paymentRepoProvider)
      .fetchPaymentDetails(locationID, ref, type, id, startDate, duration);
}

@riverpod
Future<(int?, String?, double?)> paymentProcess(
  PaymentProcessRef ref, {
  required PaymentProcessRequestType requestType,
  bool? payLater,
  double? totalAmount,
  List<AppPaymentMethods>? paymentMethod,
  int? serviceID,
  bool isJoiningApproval = false,
  int? couponID,
}) {
  return ref.read(paymentRepoProvider).paymentProcess(ref,
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      serviceID: serviceID,
      paymentMethod: paymentMethod,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID);
}

@riverpod
Future<(List<MultipleBookings>?, String?)> multiBookingPaymentProcess(
  MultiBookingPaymentProcessRef ref, {
  required PaymentProcessRequestType requestType,
  bool? payLater,
  double? totalAmount,
  AppPaymentMethods? paymentMethod,
  int? serviceID,
  bool isJoiningApproval = false,
  int? couponID,
}) {
  return ref.read(paymentRepoProvider).multiBookingPaymentProcess(ref,
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      serviceID: serviceID,
      paymentMethod: paymentMethod,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID);
}

@riverpod
Future<(bool, String)> purchaseVoucherAPI(PurchaseVoucherAPIRef ref,
    {required AppPaymentMethods paymentMethod,
    required double totalAmount,
    required int voucherId,
    required int locationId}) {
  return ref.read(paymentRepoProvider).purchaseVoucherAPI(ref,
      locationId: locationId,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      voucherId: voucherId);
}

@riverpod
Future<CouponModel> verifyCoupon(
  VerifyCouponRef ref, {
  required String coupon,
  required double price,
}) {
  return ref.read(paymentRepoProvider).verifyCoupon(ref, coupon, price);
}
