import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class WaitingForApproval extends StatelessWidget {
  const WaitingForApproval({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(100.r)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 4.h,
        ),
        child: Text(
          "WAITING_FOR_APPROVAL".tr(context),
          style: AppTextStyles.panchangBold10,
        ),
      ),
    );
  }
}
