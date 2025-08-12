import 'dart:async';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtranWebview extends ConsumerStatefulWidget {
  const MidtranWebview({super.key, required this.url});
  final String url;
  @override
  ConsumerState<MidtranWebview> createState() => _MidtranWebviewState();
}

class _MidtranWebviewState extends ConsumerState<MidtranWebview> {
  late WebViewController controller;

  bool canPop = true;
  bool deepLinkHandled = false;
  bool loadingPopupShown = false;
  late AppLinks _appLinks;

  StreamSubscription<Uri?>? _uriLinkSubscription;

  @override
  void initState() {
    _appLinks = AppLinks();
    initDeepLinks();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (change) async {
            final url = change.url;
            if (url == null) return;
          },
          onNavigationRequest: _handleNavReq,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  FutureOr<NavigationDecision> _handleNavReq(NavigationRequest request) async {
    final url = request.url;
    if (url.startsWith("https://gojek.link") ||
        url.startsWith("gojek://") ||
        url.startsWith("https://gopay.co.id") ||
        url.startsWith("gopay://") ||
        url.startsWith("https://wsa.wallet.airpay.co.id") ||
        url.startsWith("shopeeid://") ||
        url.startsWith("https://tmrwbyuobid.page.link") ||
        url.startsWith("https://simulator.midtrans.com") ||
        url.startsWith("https://simulator.sandbox.midtrans.com") ||
        !url.startsWith("http")) {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        await controller.goBack();
        return NavigationDecision.prevent;
      }
    }
    if (request.url.contains("/api/v1/apps/transaction") && mounted) {
      if (loadingPopupShown) {
        Navigator.of(context).pop();
        loadingPopupShown = false;
      }
      final Map<String, dynamic> params = {};
      request.url.split("?")[1].split("&").forEach((element) {
        final List<String> keyValue = element.split("=");
        params[keyValue[0]] = keyValue[1];
      });
      if (!params.containsKey("status_code") ||
          !params.containsKey("transaction_status")) {
        return NavigationDecision.navigate;
      }
      if (params["status_code"] != "200") {
        ref.read(goRouterProvider).pop(null);
        return NavigationDecision.navigate;
      }
      if (params["status_code"] == "200" &&
          (params["transaction_status"] == "settlement" ||
              params["transaction_status"] == "capture")) {
        ref.read(goRouterProvider).pop(params);
        return NavigationDecision.prevent;
      }
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment"),
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }

  Future<void> initDeepLinks() async {
    _uriLinkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    if ((uri.scheme == "acepadel" || uri.scheme == "delhistar") &&
        (uri.host == "gopay_done" || uri.host == "shopee_done")) {
      if (deepLinkHandled) {
        return;
      }
      deepLinkHandled = true;
      canPop = false;
      loadingPopupShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: CustomDialog(
              showCloseIcon: false,
              contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(
                    radius: 20.r,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "PAYMENT_PROCESSING".tr(context),
                    style: AppTextStyles.popupHeaderTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
