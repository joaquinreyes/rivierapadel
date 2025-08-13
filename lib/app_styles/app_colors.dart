import 'package:acepadel/globals/utils.dart';
import 'package:flutter/material.dart';

// https://www.figma.com/community/plugin/1267503782684933309/export-colors-as-dart
class AppColors {
  // static const blue = Color(0xFF0078A9);
  static const blue60 = Color(0x990078A9);
  static const darkGreen = Color(0xFF15261D);
  static const darkGreen5 = Color(0x0C15261D);
  static const darkGreen25 = Color(0x3F15261D);
  static const darkGreen70 = Color(0xB215261D);
  static const darkGreen90 = Color(0xE515261D);
  static const darkBlue = Color(0xFF193250);
  static const darkBlue50 = Color(0xFF97B8C0);
  static const clay70 = Color(0xFF5E7085);
  static const green5 = Color(0xff15261d0d);
  static const green70 = Color(0xFF15261D);
  static const white = Color(0xFFFFFFFF);
  static const gallery = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const blue35 = Color(0x590078A9);
  static const green25 = Color(0x3F006447);
  static const backgroundColor = Color(0xFFFFFFFF);
  static const white25 = Color(0x3FFFFFFF);
  static const white55 = Color(0x8CFFFFFF);
  static const white95 = Color(0xF2FFFFFF);
  static const yellow = Color(0xFFF7EE72);
  static const yellow50 = Color(0x7FF7EE72);
  static const errorColor = Color(0xFFD32F2F);
  static const lightGrey = Color(0xFFF5F5F5);
  static const oak = Color(0xFF78A6B1);
  static Color oak35 = Color(0xFF78A6B1).withOpacity(0.35);
  static const oak50 = Color(0xFFBBD2D8);
  static Color optionBgColor05 = Color(0xFF051A0E).withOpacity(0.05);
  static Color clay05 = Color(0xFFF4F5F6);
  static Color greenNew = Color(0xFF595E49);

  static Color get yellow50Popup => Utils.calculateColorOverBackground(
      AppColors.yellow, "7F", AppColors.white);

  static Color get white25Popup => Utils.calculateColorOverBackground(
      AppColors.white, "3F", AppColors.white);
  static Color get darkGreen25Popup => Utils.calculateColorOverBackground(
      AppColors.darkGreen, "3F", AppColors.white);
}
