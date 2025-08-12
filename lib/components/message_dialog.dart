import 'package:acepadel/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      contentPadding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 45.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
