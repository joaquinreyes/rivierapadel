import 'package:acepadel/models/base_classes/booking_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'lesson_model_new.dart';

class LessonsModel {
  int? id;
  int? locationId;
  String? lessonName;
  int? duration;
  double? price;
  String? eventInfo;
  bool? appAvailable;
  double? minLevelRestriction;
  double? maxLevelRestriction;
  String? shortDescription;
  Sport? sport;
  Location? location;
  List<LessonServices>? services;
  List<CoachesTeaching>? coachesTeachings;

  int? selectedCoach;

  LessonsModel(
      {this.id,
      this.locationId,
      this.lessonName,
      this.duration,
      this.price,
      this.eventInfo,
      this.appAvailable,
      this.minLevelRestriction,
      this.maxLevelRestriction,
      this.shortDescription,
      this.sport,
      this.location,
      this.services,
      this.selectedCoach,
      required this.coachesTeachings});

  LessonsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationId = json['location_id'];
    lessonName = json['lesson_name'];
    duration = json['duration'];
    price = double.tryParse(json['price'].toString());
    eventInfo = json['event_info'];
    appAvailable = json['app_available'];
    minLevelRestriction =
        double.tryParse(json['min_level_restrication'].toString());
    maxLevelRestriction =
        double.tryParse(json['max_level_restrication'].toString());
    shortDescription = json['short_description'];
    sport = json['sport'] != null ? Sport.fromJson(json['sport']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    if (json['services'] != null) {
      services = <LessonServices>[];
      json['services'].forEach((v) {
        services!.add(LessonServices.fromJson(v));
      });

      (services ?? []).sort((a, b) {
        DateTime? aTime = (a.serviceBookings?.isNotEmpty ?? false)
            ? a.serviceBookings!.first.bookingStartTime
            : null;
        DateTime? bTime = (b.serviceBookings?.isNotEmpty ?? false)
            ? b.serviceBookings!.first.bookingStartTime
            : null;

        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1; // Null values go to the end
        if (bTime == null) return -1;

        return aTime.compareTo(bTime);
      });
    }
    if (json['caochesteachings'] != null) {
      coachesTeachings = <CoachesTeaching>[];
      json['caochesteachings'].forEach((v) {
        coachesTeachings!.add(CoachesTeaching.fromJson(v));
      });
    }
    if (coaches.isNotEmpty && selectedCoach == null) {
      selectedCoach = coaches.first.id;
    }
  }

  List<ServiceDetail_Coach> get coaches {
    final List<ServiceDetail_Coach> coaches = <ServiceDetail_Coach>[];
    services?.forEach((element) {
      element.serviceBookings?.forEach((value) {
        coaches.addAll(value.coaches ?? []);
      });
      coaches.addAll(element.coaches ?? []);
    });
    return coaches;
  }

  String? get levelRestriction {
    if (minLevelRestriction == null && maxLevelRestriction == null) {
      return null;
    }
    if (minLevelRestriction == 0.0 && maxLevelRestriction == 0.0) {
      return null;
    }
    return '$minLevelRestriction - $maxLevelRestriction';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['lesson_name'] = lessonName;
    data['duration'] = duration;
    data['price'] = price;
    data['event_info'] = eventInfo;
    data['app_available'] = appAvailable;
    data['min_level_restrication'] = minLevelRestriction;
    data['max_level_restrication'] = maxLevelRestriction;
    data['short_description'] = shortDescription;
    if (sport != null) {
      data['sport'] = sport!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (coachesTeachings != null) {
      data['caochesteachings'] =
          coachesTeachings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LessonSport {
  int? id;
  String? sportName;

  LessonSport({this.id, this.sportName});

  LessonSport.fromJson(Map<String, dynamic> json) {
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

class CoachesTeaching {
  int? coachId;
  double? price;

  CoachesTeaching({this.coachId, this.price});

  CoachesTeaching.fromJson(Map<String, dynamic> json) {
    coachId = json['coach_id'];
    price = double.tryParse(json['price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coach_id'] = coachId;
    data['price'] = price;
    return data;
  }
}

class LessonLocation {
  int? id;
  String? _locationName;
  String? currency;

  String get locationName => _locationName?.capitalizeFirst ?? '';

  LessonLocation({this.id, String? locationName, this.currency})
      : _locationName = locationName;

  LessonLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _locationName = json['location_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_name'] = _locationName;
    data['currency'] = currency;
    return data;
  }
}

class LessonServices {
  int? id;
  List<LessonServiceBookings>? serviceBookings;
  List<ServiceDetail_Coach>? coaches;

  LessonServices({this.id, this.serviceBookings});

  LessonServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['serviceBookings'] != null) {
      serviceBookings = <LessonServiceBookings>[];
      json['serviceBookings'].forEach((v) {
        serviceBookings!.add(LessonServiceBookings.fromJson(v));
      });
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
    if (serviceBookings != null) {
      data['serviceBookings'] =
          serviceBookings!.map((v) => v.toJson()).toList();
    }
    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LessonServiceBookings extends BookingBase {
  List<LessonPlayers>? players;
  List<Courts>? courts;

  int get courtId {
    if ((courts ?? []).isNotEmpty) {
      return courts?.first.id ?? 0;
    }
    return 0;
  }

  int get coachesId {
    if ((coaches ?? []).isNotEmpty) {
      return coaches?.first.id ?? 0;
    }
    return 0;
  }

  LessonServiceBookings(
      {super.id,
      super.date,
      super.startTime,
      super.endTime,
      this.players,
      this.courts,
      super.coaches});

  LessonServiceBookings.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isFriendlyMatch = json['friendly_match'];
    if (json['players'] != null) {
      players = <LessonPlayers>[];
      json['players'].forEach((v) {
        players!.add(LessonPlayers.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetail_Coach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetail_Coach.fromJson(v));
      });
    }
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(Courts.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    super.toJson().forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class LessonPlayers {
  int? id;

  LessonPlayers({this.id});

  LessonPlayers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
