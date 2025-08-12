import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:acepadel/models/base_classes/booking_base.dart';
import 'package:acepadel/utils/dubai_date_time.dart';
import 'package:intl/intl.dart';

import '../models/open_match_model.dart';

extension CustomTranslations on String {
  String tr(BuildContext context, {Map<String, String>? params}) {
    if (params != null) {
      params.forEach((key, value) {
        params[key] = FlutterI18n.translate(context, value);
      });
    }
    return FlutterI18n.translate(context, this, translationParams: params);
  }

  String trU(BuildContext context, {Map<String, String>? params}) {
    if (params != null) {
      params.forEach((key, value) {
        params[key] = FlutterI18n.translate(context, value);
      });
    }
    return FlutterI18n.translate(context, this, translationParams: params)
        .toUpperCase();
  }

  String trL(BuildContext context, {Map<String, String>? params}) {
    if (params != null) {
      params.forEach((key, value) {
        params[key] = FlutterI18n.translate(context, value);
      });
    }
    return FlutterI18n.translate(context, this, translationParams: params)
        .toLowerCase();
  }
}

extension CustomDouble on num {
  formatString() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

    String s = toString().replaceAll(regex, '');
    return s;
  }
}

extension StringExtension on String {
  bool get isValidEmail {
    final exp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return exp.hasMatch(this);
  }

  String get capitalizeFirst {
    if (isEmpty) {
      return '';
    }
    var result = split(" ").map((e) {
      if (e.isNotEmpty) {
        return e[0].toUpperCase() + e.substring(1);
      } else {
        return e;
      }
    }).join(" ");
    return result;
  }
}

extension ListExtension on List {
  String? get(int index) {
    if (length > index) return this[index].toString();
    return null;
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension CustomDateProperties on DateTime {
  DateTime get withoutTime {
    final now = DubaiDateTime.now().dateTime;
    return DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
  }

  String format(String format) {
    return DateFormat(format).format(this);
  }

  bool get wasYesterday {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate
        .subtract(const Duration(days: 1))
        .isAtSameMomentAs(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isToday {
    final now = DubaiDateTime.now().dateTime;
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isTomorrow {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate
        .add(const Duration(days: 1))
        .isAtSameMomentAs(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isFutureDay {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate.isBefore(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isPastDay {
    final now = DubaiDateTime.now().dateTime;
    final nowDate = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    return nowDate.isAfter(DubaiDateTime.custom(year, month, day).dateTime);
  }

  bool get isPresentDay {
    final now = DubaiDateTime.now().dateTime;
    return now.year == year && now.month == month && now.day == day;
  }
}

extension BookingBaseExtension on List<BookingBase> {
  List<DateTime> get dateList {
    final dateList = map((e) => e.bookingDate).toSet().toList();
    dateList.sort((a, b) => a.compareTo(b));
    return dateList;
  }
}

extension OpenMatchBaseExtension on List<OpenMatchModel> {
  List<DateTime> dateList(List<int> locationIds) {
    List<DateTime> dateList = [];
    if (locationIds.isNotEmpty && locationIds.first != -1) {
      dateList = where((e) => locationIds.contains(e.service?.location?.id))
          .map((e) => e.bookingDate)
          .whereType<DateTime>() // Ensures null values are excluded
          .toSet()
          .toList();
    } else {
      dateList = map((e) => e.bookingDate).toSet().toList();
    }
    dateList.sort((a, b) => a.compareTo(b)); // Sort dates in ascending order
    return dateList;
  }
}
