import 'package:acepadel/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      showCloseIcon: false,
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PLEASE_UPDATE_THE_APP".tr(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          Text(
            "UPDATE_DESC".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "UPDATE_NOW".tr(context),
            isForPopup: true,
            onTap: () {
              launchUrl(Uri.parse(url));
            },
          )
        ],
      ),
    );
  }
}
