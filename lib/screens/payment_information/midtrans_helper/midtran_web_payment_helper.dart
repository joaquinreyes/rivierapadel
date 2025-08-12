import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'midtrans_helper.dart';
import 'dart:js' as js;

class MidtransMobilePaymentHelper extends MidtransHelper {
  Completer<Map<String, dynamic>?>? _paymentCompleter;
  @override
  Future<Map<String, dynamic>?> handleRedirectURL(
      {required String url,
      required BuildContext context,
      required WidgetRef ref}) async {
    String token = url.split("/").last;
    _paymentCompleter = Completer<Map<String, dynamic>?>();
    _showPaymentModal(token);
    return _paymentCompleter!.future;
  }

  Future<void> handlePaymentSuccess(params) async {
    final p = {
      "order_id": params["order_id"],
      "status_code": params["status_code"],
      "transaction_status": params["transaction_status"]
    };
    _paymentCompleter?.complete(p);
  }

  void handlePaymentPending(result) {
    _paymentCompleter?.complete(null);
  }

  void handlePaymentError(result) {
    _paymentCompleter?.complete(null);
  }

  void handlePaymentOnClose() {
    _paymentCompleter?.complete(null);
  }

  void _showPaymentModal(String token) {
    js.context.callMethod('setPaymentCallbacks', [
      js.allowInterop(handlePaymentSuccess), // Pass the Dart function
      js.allowInterop(handlePaymentPending), // Pass the Dart function
      js.allowInterop(handlePaymentError),
      js.allowInterop(handlePaymentOnClose) // Pass the Dart function
    ]);

    // Call the JavaScript function defined in index.html
    js.context.callMethod('showPaymentModal', [token]);
  }
}
