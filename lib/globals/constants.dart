import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

const currency = "IDR";
const kAppName = 'Ace Padel';
const kWhatsAppContact = "+6281110508077";
const kWhatsAppLink = "https://api.whatsapp.com/send";

const double kDesignHeight = 844;
const double kDesignWidth = 390;
const int kMidtransPaymentID = 1;

String kFormatForAPI = "yyyy-MM-dd";

final kComponentWidthConstraint = BoxConstraints(maxWidth: 450.w);
const kAnimationDuration = Duration(milliseconds: 250);
const kStartedPlayindCustomID = "66d6e16ad47a858077f7a7ff";
const kPositionID = "66d6dfcdd47a858077f7a7e8";

final kInsetShadow = [
  inset.BoxShadow(
    offset: const Offset(-4, -4),
    blurRadius: 60,
    color: const Color(0xff000000).withOpacity(.20),
    inset: true,
  ),
  inset.BoxShadow(
    offset: const Offset(4, 4),
    blurRadius: 4,
    color: const Color(0xFFBEBEBE).withOpacity(.55),
    inset: true,
  ),
];

final kInsetShadow2 = [
  inset.BoxShadow(
    offset: const Offset(-4, -4),
    blurRadius: 60,
    // color: const Color(0xff000000).withOpacity(.20),
    color: const Color(0xFFBEBEBE).withOpacity(.20),
    inset: true,
  ),
  inset.BoxShadow(
    offset: const Offset(4, 4),
    blurRadius: 4,
    color: const Color(0xff000000).withOpacity(.55),
    inset: true,
  ),
];

const kBoxShadow = BoxShadow(
  color: Color(0x0C000000),
  blurRadius: 4,
  offset: Offset(0, 4),
  spreadRadius: 0,
);

List<double> levelsList = List.generate(15, (index) => index * 0.5);

void myPrint(dynamic value) {
  if (kDebugMode) {
    if (kIsWeb) {
      print(value.toString());
    } else {
      log(value.toString());
    }
  }
}

const chatRoles = {
  1: "SUPER_ADMIN",
  2: "CLUB_ADMIN",
  3: "LOCATION_OWNER",
  4: "STAFF_MANAGER",
  5: "STAFF"
};
