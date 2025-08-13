import 'package:acepadel/app_styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:acepadel/globals/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkCircleImage extends StatelessWidget {
  const NetworkCircleImage({super.key,
    required this.path,
    required this.width,
    required this.height,
    this.isYellowBg = false,
    this.showBG = false,
    this.borderRadius,
    this.boxBorder,
    this.scale,
    this.reservedLogo,
  });

  final String? path;
  final double width;
  final double height;
  final bool isYellowBg;
  final bool showBG;
  final BoxBorder? boxBorder;
  final BorderRadius? borderRadius;
  final double? scale;
  final bool? reservedLogo;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: (showBG && (path?.isEmpty ?? true))
            ? (isYellowBg ? AppColors.green5 : AppColors.darkGreen90)
            : Colors.transparent,
        // shape: BoxShape.circle,
        boxShadow: showBG
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: path?.isEmpty ?? true
          ? Transform.scale(
              scale: scale ?? 0.78,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: Image.asset(
                  (reservedLogo ?? false) ? AppImages.reservedLogo.path : AppImages.logo.path,
                  fit: BoxFit.contain,
                  height: 36.w,
                  width: 64.w,
                ),
              ),
            )
          : Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: boxBorder,
          // shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: borderRadius ?? BorderRadius.circular(6.r),
          image: DecorationImage(
            image: NetworkImage(path!),
            fit: BoxFit.cover,
          ),
        ),
      )
      // CircleAvatar(
      //         foregroundImage: NetworkImage(
      //           path!,
      //         ),
      //       ),
    );
  }
}
