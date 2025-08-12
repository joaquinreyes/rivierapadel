import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'midtran_mobile_payment_helpeer.dart'
    if (dart.library.js) 'midtran_web_payment_helper.dart';
// export 'dart:js' if (dart.library.js) '';

abstract class MidtransHelper {
  Future<Map<String, dynamic>?> handleRedirectURL(
      {required String url,
      required BuildContext context,
      required WidgetRef ref});
}
