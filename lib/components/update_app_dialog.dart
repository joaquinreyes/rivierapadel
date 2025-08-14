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
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PLEASE_UPDATE_THE_APP".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            "UPDATE_DESC".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: MainButton(
              label: "UPDATE_NOW".trU(context),
              isForPopup: true,
              onTap: () {
                launchUrl(Uri.parse(url));
              },
            ),
          )
        ],
      ),
    );
  }
}
