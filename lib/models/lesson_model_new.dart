import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:intl/intl.dart';

import '../CustomDatePicker/src/date_format.dart';
import '../globals/utils.dart';
import '../utils/dubai_date_time.dart';
import 'club_locations.dart';

class LessonModelNew {
  String? status;
  String? message;
  LessonDataNew0? data;

  // List<Lessons> get durationsToShow {
  //   if (data != null && (data!.availableSlots ?? []).isNotEmpty) {
  //     final locationIDs =
  //         data!.availableSlots!.map((e) => e.location!.id).toSet().toList();
  //     List<Lessons> durations = [];
  //     for (final id in locationIDs) {
  //       final locationBookings =
  //           data!.availableSlots!.where((e) => e.location!.id == id).toList();
  //       if (locationBookings.length > durations.length) {
  //         durations.clear();
  //         for (final item in locationBookings) {
  //           durations.addAll(item.lessons ?? []);
  //         }
  //       }
  //     }
  //     final uniqueItems =
  //         durations.fold<List<Lessons>>([], (previous, current) {
  //       if (!previous.any((element) => element.id == current.id)) {
  //         previous.add(current);
  //       }
  //       return previous;
  //     });
  //     // uniqueItems
  //     //     .sort((a, b) => (a.duration ?? 0).compareTo((b.duration ?? 0)));
  //     return uniqueItems;
  //   }
  //   return [];
  // }

  List<LessonVariants> get durationsToShow {
    final tempLessonVariants = <LessonVariants>[];

    data?.availableSlots?.forEach((coach) {
      tempLessonVariants.addAll(coach.lessonVariants ?? []);
    });

    final seenDurations = <int>{};
    final uniqueByDuration = tempLessonVariants.where((variant) {
      final duration = variant.duration ?? 0;
      return seenDurations.add(duration); // only true if not already seen
    }).toList();

    uniqueByDuration
        .sort((a, b) => (a.duration ?? 0).compareTo(b.duration ?? 0));
    return uniqueByDuration;
  }

  List<Lessons> getLessonList(List<int> coachIds) {
    List<Lessons> tempList = [];
    data?.availableSlots?.map((e) {
      if (coachIds.isEmpty) {
        tempList.addAll(e.lessons ?? []);
      } else if (coachIds.contains(e.id ?? 0)) {
        tempList.addAll(e.lessons ?? []);
      }
    }).toList();
    return tempList;
  }

  LessonModelNew({this.status, this.message, this.data});

  LessonModelNew.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LessonDataNew0.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LessonDataNew0 {
  List<AvailableSlots>? availableSlots;

  LessonDataNew0({this.availableSlots});

  List<AvailableSlots> getAvailableSlotsByLocation(List<int> coachIds,
      bool dateBookableSelected, ClubLocationData clubLocationData) {
    List<AvailableSlots> tempAvailableSlots = coachIds.isEmpty
        ? (availableSlots ?? [])
        : availableSlots!
            .where((element) => coachIds.contains(element.id ?? 0))
            .toList();

    if (dateBookableSelected && (clubLocationData.id ?? -1) != -1) {
      final locationId = clubLocationData.id ?? -1;
      tempAvailableSlots = tempAvailableSlots.where((element) {
        return element.location?.id == locationId;
      }).toList();
    }

    return tempAvailableSlots;
  }

  LessonDataNew0.fromJson(Map<String, dynamic> json) {
    try {
      // Handle the case where availableSlots is a single object instead of a list
      if (json['availableSlots'] is Map<String, dynamic>) {
        availableSlots = [AvailableSlots.fromJson(json['availableSlots'])];
      } else if (json['availableSlots'] is List) {
        availableSlots = <AvailableSlots>[];
        json['availableSlots'].forEach((v) {
          availableSlots!.add(AvailableSlots.fromJson(v));
        });
      } else {
        // If it's neither, we can log or handle the error as needed
        myPrint(
            'Unexpected type for availableSlots: ${json['availableSlots'].runtimeType}');
      }
    } catch (e) {
      myPrint('Error for availableSlots: $e ');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (availableSlots != null) {
      data['availableSlots'] = availableSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<DateTime> getTimeSlots(
      int coachId, DateTime date, LessonVariants? lessonVariant) {
    if (lessonVariant == null) {
      return [];
    }
    List<String> timeSlots = [];
    List<AvailableSlots> booking =
        availableSlots!.where((element) => coachId == element.id).toList();
    for (final booking in booking) {
      final tempListLessonVariants = booking.lessonVariants
              ?.where((e) => e.duration == lessonVariant.duration)
              .toList() ??
          [];
      final lessonsId =
          tempListLessonVariants.map((e) => e.lessonId ?? 0).toSet().toList();
      final courtsValue = booking.courtsByDuration
          ?.where(
            (element) => element.duration == lessonVariant.duration,
          )
          .toList();
      for (final courts in (courtsValue ?? [])) {
        for (final court in (courts.courts ?? [])) {
          for (final timing in (court.timings ?? [])) {
            if (timing.date == date.format("yyyy-MM-dd") &&
                lessonsId.contains(timing.lessonId ?? 0)) {
              timeSlots.addAll(timing.availableTimeSlots!);
              timeSlots = timeSlots.toSet().toList();
            }
          }
        }
      }
    }
    List<DateTime> timeSlotsDateTime = [];
    for (final time in timeSlots) {
      DateTime dateTime = Utils.serverTimeToDateTime(time, date);
      timeSlotsDateTime.add(dateTime);
    }

    final now = DubaiDateTime.now().dateTime;
    timeSlotsDateTime =
        timeSlotsDateTime.where((element) => element.isAfter(now)).toList();
    timeSlotsDateTime.sort((a, b) => a.compareTo(b));

    return timeSlotsDateTime;
  }

  Map<int, String> getLessons(LessonVariants selectedLessonVariant, int coachId,
      DateTime time, DateTime date) {
    final bookings = availableSlots!.where((e) {
      return e.id == coachId;
    }).toList();
    final Map<int, String> lessonsValue = {};

    for (final booking in bookings) {
      final validVariants = booking.lessonVariants
              ?.where((v) => v.duration == selectedLessonVariant.duration)
              .toList() ??
          [];

      final lessonIds = validVariants.map((v) => v.lessonId ?? 0).toSet();

      for (final lesson in booking.lessons ?? []) {
        if (!lessonIds.contains(lesson.id)) continue;
        final courtsValue = booking.courtsByDuration
            ?.where(
              (element) => element.duration == selectedLessonVariant.duration,
            )
            .toList();
        final isAvailable = courtsValue?.any((courts) {
              return courts.courts?.any((court) {
                    return court.timings?.any((timing) {
                          final isSameDate =
                              timing.date == date.format("yyyy-MM-dd");
                          final isSameTime = (timing.availableTimeSlots ?? [])
                              .contains(time.format("HH:mm:ss"));
                          final isSameLesson = timing.lessonId == lesson.id;

                          return isSameDate && isSameTime && isSameLesson;
                        }) ??
                        false;
                  }) ??
                  false;
            }) ??
            false;

        if (isAvailable && lesson.id != null) {
          lessonsValue[lesson.id!] = lesson.lessons ?? "";
        }
      }
    }

    return sortCourts(lessonsValue);
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

  AvailableSlots? getBooking(int coachId) {
    try {
      return (availableSlots ?? []).firstWhere((e) => e.id == coachId);
    } catch (_) {
      return null;
    }
  }
}

class AvailableSlots {
  int? id;
  String? fullName;
  String? profileUrl;
  String? description;
  Location? location;
  Sport? sport;
  List<int>? lessonIds;
  List<Lessons>? lessons;
  List<CourtsByDuration>? courtsByDuration;
  List<LessonVariants>? lessonVariants;

  List<Courts> getCourts(
      int lessonId,
      DateTime bookingTime,
      LessonVariants selectedLessonVariant,
      ) {

    // Guard clause if courtsByDuration is null
    if (courtsByDuration == null) return [];

    final duration = selectedLessonVariant.duration;
    final formattedTime = bookingTime.format("HH:mm:ss");

    final courtsValue = courtsByDuration!
        .where((element) => element.duration == duration)
        .toList();

    final List<Courts> tempCourts = [];

    for (final e in courtsValue) {
      final availableCourts = (e.courts ?? []).where((court) {
        final timings = court.timings ?? [];
        return timings.any((timing) =>
        timing.lessonId == lessonId &&
            (timing.availableTimeSlots?.contains(formattedTime) ?? false));
      });

      tempCourts.addAll(availableCourts);
    }

    return tempCourts;
  }


  List<LessonVariants> getLessonVariantsByMaxCapacity(
      LessonVariants selectedLessonVariant, int lessonId) {
    final seenCapacities = <int?>{};
    final filteredVariants = (lessonVariants ?? []).where((element) {
      if (element.maximumCapacity == null ||
          seenCapacities.contains(element.maximumCapacity)) {
        return false;
      }
      if (selectedLessonVariant.duration != element.duration) {
        return false;
      }
      if (element.lessonId != lessonId) {
        return false;
      }

      seenCapacities.add(element.maximumCapacity);
      return true;
    }).toList();

    filteredVariants.sort(
        (a, b) => (a.maximumCapacity ?? 0).compareTo(b.maximumCapacity ?? 0));

    return filteredVariants;
  }

  String getDateCourt(LessonVariants? selectedLessonVariant) {
    if (selectedLessonVariant == null) {
      return "";
    }
    final courtsValue = courtsByDuration
        ?.firstWhere(
          (element) => element.duration == selectedLessonVariant.duration,
          orElse: () => CourtsByDuration(),
        )
        .courts;
    if (courtsValue != null &&
        courtsValue.isNotEmpty &&
        courtsValue.first.timings != null &&
        courtsValue.first.timings!.isNotEmpty &&
        courtsValue.first.timings!.first.date != null) {
      final parsedDate =
          DateTime.tryParse(courtsValue.first.timings!.first.date!);
      if (parsedDate != null) {
        return DateFormat('EEE d MMM').format(parsedDate);
      }
    }
    return "";
  }

  AvailableSlots(
      {this.id,
      this.fullName,
      this.profileUrl,
      this.description,
      this.location,
      this.sport,
      this.lessonIds,
      this.lessonVariants,
      this.courtsByDuration});

  AvailableSlots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    profileUrl = json['profile_url'];
    description = json['description'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sport = json['sport'] != null ? Sport.fromJson(json['sport']) : null;
    lessonIds = json['lesson_ids'].cast<int>();
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(Lessons.fromJson(v));
      });
    }
    if (json['courtsByDuration'] != null) {
      courtsByDuration = <CourtsByDuration>[];
      json['courtsByDuration'].forEach((v) {
        courtsByDuration!.add(CourtsByDuration.fromJson(v));
      });
    }
    if (json['lessonVariants'] != null) {
      lessonVariants = <LessonVariants>[];
      json['lessonVariants'].forEach((v) {
        if (v != null) {
          lessonVariants!.add(LessonVariants.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['profile_url'] = profileUrl;
    data['description'] = description;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (lessonVariants != null) {
      data['lessonVariants'] = lessonVariants!.map((v) => v.toJson()).toList();
    }
    if (sport != null) {
      data['sport'] = sport!.toJson();
    }
    data['lesson_ids'] = lessonIds;
    if (lessons != null) {
      data['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    if (courtsByDuration != null) {
      data['courtsByDuration'] =
          courtsByDuration!.map((v) => v.toJson()).toList();
    }
    return data;
  }

// List<DateTime> getTimeSlots( DateTime date) {
//   List<String> timeSlots = [];
//   List<Courts> courtsList = courts?.toList() ?? [];
//   for (final Courts courtElement in courtsList) {
//     for (final Timings? timingElement in courtElement.timings ?? []) {
//       timeSlots.addAll(timingElement?.availableTimeSlots ?? []);
//       timeSlots = timeSlots.toSet().toList();
//     }
//   }
//   List<DateTime> timeSlotsDateTime = [];
//   for (final time in timeSlots) {
//     DateTime dateTime = Utils.serverTimeToDateTime(time, date);
//     timeSlotsDateTime.add(dateTime);
//   }
//   //REMOVE PAST TIME SLOTS
//   final now = DubaiDateTime.now().dateTime;
//   timeSlotsDateTime =
//       timeSlotsDateTime.where((element) => element.isAfter(now)).toList();
//   timeSlotsDateTime.sort((a, b) => a.compareTo(b));
//
//   return timeSlotsDateTime;
// }
}

class CourtsByDuration {
  int? duration;
  List<Courts>? courts;
  String? date;

  CourtsByDuration({this.duration, this.courts, this.date});

  CourtsByDuration.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(Courts.fromJson(v));
      });
    }
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    data['date'] = date;
    return data;
  }
}

class LessonVariants {
  int? id;
  int? duration;
  int? maximumCapacity;
  int? price;
  int? lessonId;

  LessonVariants(
      {this.id,
      this.duration,
      this.maximumCapacity,
      this.price,
      this.lessonId});

  LessonVariants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    maximumCapacity = json['maximum_capacity'];
    price = json['price'];
    lessonId = json['lesson_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration;
    data['maximum_capacity'] = maximumCapacity;
    data['price'] = price;
    data['lesson_id'] = lessonId;
    return data;
  }
}

class Location {
  int? id;
  String? currency;
  String? locationName;

  Location({this.id, this.currency, this.locationName});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currency'] = currency;
    data['location_name'] = locationName;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sport_name'] = sportName;
    return data;
  }
}

class Lessons {
  int? id;
  int? duration;
  int? maximumCapacity;
  String? lessons;
  double? price;

  Lessons(
      {this.id, this.duration, this.maximumCapacity, this.lessons, this.price});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    maximumCapacity = json['maximum_capacity'];
    lessons = json['lessons'];
    price = double.tryParse(json['price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration;
    data['maximum_capacity'] = maximumCapacity;
    data['lessons'] = lessons;
    data['price'] = price;
    return data;
  }
}

class Courts {
  int? id;
  String? courtName;
  List<Timings>? timings;

  Courts({this.id, this.courtName, this.timings});

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courtName = json['court_name'];

    if (json['timings'] != null) {
      timings = <Timings>[];
      json['timings'].forEach((v) {
        timings!.add(Timings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['court_name'] = courtName;
    if (timings != null) {
      data['timings'] = timings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timings {
  String? startTime;
  String? endTime;
  String? date;
  int? lessonId;
  List<String>? availableTimeSlots;

  Timings(
      {this.startTime, this.lessonId, this.endTime, this.availableTimeSlots});

  Timings.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    lessonId = json['lesson_id'];
    date = json['date'];
    availableTimeSlots = json['available_time_slots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['lesson_id'] = lessonId;
    data['date'] = date;
    data['available_time_slots'] = availableTimeSlots;
    return data;
  }
}
