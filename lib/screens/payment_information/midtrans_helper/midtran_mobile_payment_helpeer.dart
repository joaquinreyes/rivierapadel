import 'package:acepadel/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/routes/app_routes.dart';

import 'midtrans_helper.dart';

class MidtransMobilePaymentHelper extends MidtransHelper {
  @override
  Future<Map<String, dynamic>?> handleRedirectURL(
      {required String url,
      required BuildContext context,
      required WidgetRef ref}) async {
    final String encodedUrl = Uri.encodeComponent(url);
    Map<String, dynamic>? params = await ref
        .read(goRouterProvider)
        .push("${RouteNames.midTranWebView}/$encodedUrl");
    return params;
  }
}
