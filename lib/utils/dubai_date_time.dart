import 'package:acepadel/utils/custom_extensions.dart';
import 'package:intl/intl.dart';

class DubaiDateTime {
  late DateTime _dateTime;

  DubaiDateTime(String? formattedString,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    if (formattedString == null) {
      _dateTime = DateTime.now();
      return;
    }
    _dateTime = DateFormat(format).parse(formattedString, true);
  }

  DubaiDateTime.parse(String formattedString) {
    _dateTime = DateTime.parse(formattedString);
  }

  DateTime get dateTime {
    return _dateTime;
  }

  @override
  String toString() {
    return _dateTime.format('yyyy-MM-dd HH:mm:ss');
  }

  DubaiDateTime.now() {
    _dateTime = DateTime.now();
    // .toUtc()
    // .add(const Duration(hours: 8)); // Convert to Singapore time (UTC+8)
  }

  DubaiDateTime.custom(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    _dateTime = DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }
}
