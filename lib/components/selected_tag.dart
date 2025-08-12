import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/globals/images.dart';

class SelectedTag extends StatelessWidget {
  SelectedTag(
      {super.key, required this.isSelected, double? width, double? height, this.selectedTag, this.unSelectedTag})
      : width = width ?? 15.w,
        height = height ?? 18.w;
  final bool isSelected;
  final double width;
  final double height;
  final String? selectedTag;
  final String? unSelectedTag;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isSelected ? selectedTag ?? AppImages.selectedTag.path : unSelectedTag ?? AppImages.unselectedTag.path,
      width: 20,
      height: 20,
    );
  }
}
