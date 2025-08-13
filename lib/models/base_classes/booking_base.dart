import 'package:acepadel/models/lesson_model_new.dart';
import 'package:acepadel/utils/dubai_date_time.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/globals/utils.dart';

import '../service_detail_model.dart';

class BookingBase {
  String? startTime;
  String? endTime;
  String? date;
  int? id;
  bool? isFriendlyMatch;
  int? minimumCapacity;
  int? maximumCapacity;
  bool? approveBeforeJoin;
  String? organizerNote;
  OpenMatchOptions? options;
  List<ServiceDetail_Coach>? coaches;

  BookingBase(
      {this.date,
      this.startTime,
      this.endTime,
      this.id,
      this.minimumCapacity,
      this.maximumCapacity,
      this.approveBeforeJoin,
      this.coaches,
      this.organizerNote,
      this.isFriendlyMatch});

  String get openMatchLevelRange {
    if (options != null) {
      return "${options!.minLevel} - ${options!.maxLevel}";
    }
    return '';
  }

  bool get isPast {
    final now = DubaiDateTime.now().dateTime;

    return now.isAfter(bookingStartTime);
  }

  DateTime get bookingDate {
    if (date == null) {
      return DubaiDateTime.now().dateTime;
    }
    return DubaiDateTime.parse(date!).dateTime;
  }

  String get formatBookingDate {
    return bookingDate.format("EEE dd MMM");
  }

  String get formatBookingDate2 {
    return bookingDate.format("EEEE dd MMM");
  }

  DateTime get bookingStartTime {
    if (this.date == null) {
      return DubaiDateTime.now().dateTime;
    }
    final date = DubaiDateTime.parse(this.date!).dateTime;
    return Utils.serverTimeToDateTime(startTime!, date);
  }

  DateTime get bookingEndTime {
    if (this.date == null) {
      return DubaiDateTime.now().dateTime;
    }
    final date = DubaiDateTime.parse(this.date!).dateTime;
    return Utils.serverTimeToDateTime(endTime!, date);
  }

  String get duration {
    int dif = bookingEndTime.difference(bookingStartTime).inMinutes;
    if (dif < 0) {
      return "";
    }
    if (dif < 60) {
      return "$dif min";
    }
    // return "${dif ~/ 60} hr ${dif % 60} min";
    double hours = dif / 60;
    double minutes = dif % 60;
    if (minutes == 0) {
      return "${hours.toInt()} hr";
    }
    return "${hours.toInt()} hr ${minutes.toInt()} min";
  }

  int get duration2 {
    DateTime tempBookingEndTime = DateTime.parse(bookingEndTime.toString());
    final dif = tempBookingEndTime.difference(bookingStartTime).inMinutes;
    if (dif < 0) {
      tempBookingEndTime = DateTime.parse(
          tempBookingEndTime.add(const Duration(days: 1)).toString());
      final dif2 = tempBookingEndTime.difference(bookingStartTime).inMinutes;
      if (dif2 < 0) {
        return 0;
      }
      return dif2;
    }
    return dif;
  }

  String get formattedDateStartEndTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm")}";
  }

  String get formattedDateStartEndTimeAm {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("h:mm")} - ${bookingEndTime.format("h:mm a").toLowerCase()}";
  }

  String get formattedDateStartEndTimeForShare {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")}, ${bookingStartTime.format("HH:mm")} ($duration)";
  }

  String get formattedDateStartTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingDate.format("EEE dd MMM")} | ${bookingStartTime.format("HH:mm")}";
  }

  int get calculatedDuration{
    return bookingEndTime.difference(bookingStartTime).inMinutes;
  }

  String get formatStartEndTime {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("HH:mm")} - ${bookingEndTime.format("HH:mm")}";
  }
  String get formatStartEndTimeAm {
    if (startTime == null) {
      return '';
    }
    return "${bookingStartTime.format("h:mm")} - ${bookingEndTime.format("h:mm a").toLowerCase()}";
  }

  String get formatStartTime {
    if (startTime == null) {
      return '';
    }
    return bookingStartTime.format("HH:mm");
  }

  BookingBase.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    id = json['id'];
    isFriendlyMatch = json['friendly_match'];
    approveBeforeJoin = json['approve_before_join'];
    organizerNote = json['organizer_notes'];
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    if (json['openMatchOptions'] != null) {
      options = OpenMatchOptions.fromJson(json['openMatchOptions']);
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetail_Coach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetail_Coach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['approve_before_join'] = approveBeforeJoin;
    data['organizer_notes'] = organizerNote;

    return data;
  }
}

class OpenMatchOptions {
  double? maxLevel;
  double? minLevel;

  OpenMatchOptions({this.maxLevel, this.minLevel});

  OpenMatchOptions.fromJson(Map<String, dynamic> json) {
    maxLevel = double.tryParse(json['max_level']?.toString() ?? '');
    minLevel = double.tryParse(json['min_level']?.toString() ?? '');
  }
}
