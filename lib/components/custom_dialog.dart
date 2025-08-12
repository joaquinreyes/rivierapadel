import 'package:acepadel/globals/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog(
      {super.key,
      required this.child,
      this.height,
      this.color = AppColors.darkBlue,
      EdgeInsets? contentPadding,
      this.showCloseIcon = true,
      this.physics,
      this.closeIconColor = AppColors.white,
      this.maxHeight})
      : _contentPadding = contentPadding ??
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 30.h);
  final Widget child;
  final double? height;
  final Color color;
  final Color closeIconColor;
  final EdgeInsets _contentPadding;
  final bool showCloseIcon;
  final double? maxHeight;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: 350.w,
            constraints: maxHeight != null
                ? BoxConstraints(maxHeight: maxHeight!)
                : null,
            height: height,
            padding: _contentPadding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: SingleChildScrollView(
              primary: false,
              physics: physics ?? const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showCloseIcon) ...[
                    SizedBox(height: 10.h),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          AppImages.closeIcon.path,
                          width: 12.w,
                          height: 12.w,
                          color: closeIconColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
