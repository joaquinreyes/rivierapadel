import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/utils/dubai_date_time.dart';

import 'lesson_model_new.dart';

class CourtBookingData {
  List<Bookings>? bookings;

  List<int> get durationsToShow {
    final locationIDs = bookings!.map((e) => e.location!.id).toSet().toList();
    List<int> durations = [];
    for (final id in locationIDs) {
      final locationBookings =
          bookings!.where((e) => e.location!.id == id).toList();
      if (locationBookings.length > durations.length) {
        durations.clear();
        for (final item in locationBookings) {
          durations.add(item.duration!);
        }
      }
    }
    durations.sort();
    return durations;
  }

  List<int> get locations {
    return bookings!.map((e) => e.location!.id!).toSet().toList();
  }

  List<DateTime> getTimeSlots(int duration, int locationID, DateTime date) {
    List<String> timeSlots = [];
    List<Bookings> booking = bookings!
        .where((element) =>
            element.duration == duration && locationID == element.location!.id)
        .toList();
    for (final booking in booking) {
      for (final court in booking.location!.courts!) {
        for (final timing in court.timings!) {
          timeSlots.addAll(timing.availableTimeSlots!);
          timeSlots = timeSlots.toSet().toList();
        }
      }
    }
    List<DateTime> timeSlotsDateTime = [];
    for (final time in timeSlots) {
      DateTime dateTime = Utils.serverTimeToDateTime(time, date);
      timeSlotsDateTime.add(dateTime);
    }
    //REMOVE PAST TIME SLOTS
    final now = DubaiDateTime.now().dateTime;
    timeSlotsDateTime =
        timeSlotsDateTime.where((element) => element.isAfter(now)).toList();
    timeSlotsDateTime.sort((a, b) => a.compareTo(b));

    return timeSlotsDateTime;
  }

  bool isAllTimeSlotsEmpty(int duration, DateTime date) {
    final locationIDs = bookings!.map((e) => e.location!.id).toSet().toList();
    for (final id in locationIDs) {
      final locationBookings = bookings!
          .where((e) => e.location!.id == id && duration == e.duration)
          .toList();
      if (locationBookings.isNotEmpty) {
        final booking =
            locationBookings.firstWhere((e) => e.duration == duration);
        List<Courts>? futureCourts = [];
        for (final court in booking.location!.courts!) {
          for (final timing in court.timings!) {
            final availableSLots = timing.availableTimeSlots!.map((e) {
              final dateTime = Utils.serverTimeToDateTime(e, date);
              return dateTime;
            }).toList();
            final now = DubaiDateTime.now().dateTime;
            availableSLots.removeWhere((element) => element.isBefore(now));
            if (availableSLots.isNotEmpty) {
              futureCourts.add(court);
            }
          }
        }
        if (futureCourts.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  Map<int, String> getCourt(
      int duration, int locationID, DateTime time, DateTime date) {
    final bookings = this
        .bookings!
        .where((e) => e.duration == duration && e.location!.id == locationID)
        .toList();
    final Map<int, String> courts = {};
    for (final booking in bookings) {
      for (final court in booking.location!.courts!) {
        for (final timing in court.timings!) {
          final availableSLots = timing.availableTimeSlots!.map((e) {
            final dateTime = Utils.serverTimeToDateTime(e, date);
            return dateTime;
          }).toList();
          if (availableSLots.contains(time)) {
            // courts.add(court.courtName!.capitalizeFirst);
            courts[court.id!] = court.courtName!.capitalizeFirst;
          }
        }
      }
    }
    return sortCourts(courts);
  }

  Map<int, String> sortCourts(Map<int, String> map) {
    int? extractNumber(String value) {
      final match = RegExp(r'(\d+)').firstMatch(value);
      return match != null ? int.tryParse(match.group(1)!) : null;
    }

    List<MapEntry<int, String>> numberedEntries = [];
    List<MapEntry<int, String>> otherEntries = [];

    for (var entry in map.entries) {
      final number = extractNumber(entry.value);
      if (number != null) {
        numberedEntries.add(entry);
      } else {
        otherEntries.add(entry);
      }
    }

    numberedEntries.sort((a, b) {
      final aNumber = extractNumber(a.value) ?? 0;
      final bNumber = extractNumber(b.value) ?? 0;
      return aNumber.compareTo(bNumber);
    });

    List<MapEntry<int, String>> sortedEntries = [
      ...numberedEntries,
      ...otherEntries
    ];

    return Map.fromEntries(sortedEntries);
  }

  Bookings? getBooking(
      DateTime date, DateTime time, int locationID, int duration, int courtID) {
    final booking = bookings!
        .where((e) => e.location!.id == locationID && e.duration == duration)
        .toList();
    for (final book in booking) {
      for (final court in book.location!.courts!) {
        if (court.id == courtID) {
          for (final timing in court.timings!) {
            final availableSLots = timing.availableTimeSlots!.map((e) {
              final dateTime = Utils.serverTimeToDateTime(e, date);
              return dateTime;
            }).toList();
            if (availableSLots.contains(time)) {
              return book;
            }
          }
        }
      }
    }
    return null;
  }

  CourtBookingData({this.bookings});

  CourtBookingData.fromJson(Map<String, dynamic> json) {
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> courtBookingData = <String, dynamic>{};
    if (bookings != null) {
      courtBookingData['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return courtBookingData;
  }
}

class Bookings {
  int? id;
  int? duration;
  double? price;
  bool? isOpenMatch;
  double? openMatchPrice;
  int? minimumCapacity;
  int? maximumCapacity;
  Location? location;
  Sport? sport;

  Bookings(
      {this.id,
      this.duration,
      this.price,
      this.isOpenMatch,
      this.openMatchPrice,
      this.minimumCapacity,
      this.maximumCapacity,
      this.location,
      this.sport});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    price = double.tryParse(json['price'].toString());
    isOpenMatch = json['is_open_match'];
    openMatchPrice = double.tryParse(json['open_match_price'].toString());
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sport = json['sport'] != null ? Sport.fromJson(json['sport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> CourtBookingData = <String, dynamic>{};
    CourtBookingData['id'] = id;
    CourtBookingData['duration'] = duration;
    CourtBookingData['price'] = price;
    CourtBookingData['is_open_match'] = isOpenMatch;
    CourtBookingData['open_match_price'] = openMatchPrice;
    CourtBookingData['minimum_capacity'] = minimumCapacity;
    CourtBookingData['maximum_capacity'] = maximumCapacity;
    if (location != null) {
      CourtBookingData['location'] = location!.toJson();
    }
    if (sport != null) {
      CourtBookingData['sport'] = sport!.toJson();
    }
    return CourtBookingData;
  }
}

class Location {
  int? id;
  String? locationName;
  List<Courts>? courts;

  Location({this.id, this.locationName, this.courts});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationName = json['location_name'];
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(Courts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> courtBookingData = <String, dynamic>{};
    courtBookingData['id'] = id;
    courtBookingData['location_name'] = locationName;
    if (courts != null) {
      courtBookingData['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    return courtBookingData;
  }
}


class Sport {
  int? id;
  String? sportName;

  Sport({this.id, this.sportName});

  Sport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sportName = json['sport_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> CourtBookingData = <String, dynamic>{};
    CourtBookingData['id'] = id;
    CourtBookingData['sport_name'] = sportName;
    return CourtBookingData;
  }
}
