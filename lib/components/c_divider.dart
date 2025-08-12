import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';

class CDivider extends StatelessWidget {
  const CDivider({super.key, Color? color, this.thickness})
      : color = color ?? AppColors.darkGreen5;
  final Color color;
  final double? thickness;
  @override
  Widget build(BuildContext context) {
    return Divider(thickness: (thickness ?? 1).h, color: color);
  }
}
