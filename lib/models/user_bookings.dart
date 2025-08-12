import 'package:acepadel/models/base_classes/booking_base.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class UserBookings extends BookingBase {
  bool? isCancelled;
  Service? service;
  List<Courts>? courts;
  List<Players>? players;
  List<RequestWaitingList>? requestWaitingList;

  List<ServiceDetail_Coach> get getCoaches {
    final seenIds = <dynamic>{};
    final allCoaches = [
      if (coaches != null) ...coaches!,
      if (service?.coaches != null) ...service!.coaches!,
    ];

    return allCoaches.where((coach) {
      final id = coach.id;
      if (seenIds.contains(id)) return false;
      seenIds.add(id);
      return true;
    }).toList();
  }

  String? get coachName {
    if (getCoaches.isNotEmpty) {
      return getCoaches.first.fullName;
    }
    return '';
  }

  UserBookings(
      {super.id,
      super.date,
      super.startTime,
      super.endTime,
      this.isCancelled,
      this.service,
      this.courts,
      this.players,
      this.requestWaitingList});

  String get courtName {
    if (courts != null && (courts?.isNotEmpty ?? true)) {
      return courts!.first.courtName!;
    }
    return '';
  }

  UserBookings.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isCancelled = json['is_cancelled'];
    isFriendlyMatch = json['friendly_match'];
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(Courts.fromJson(v));
      });
    } else {
      courts = null;
    }
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(Players.fromJson(v));
      });
    } else {
      players = null;
    }
    if (json['requestWaitingList'] != null) {
      requestWaitingList = <RequestWaitingList>[];
      json['requestWaitingList'].forEach((v) {
        requestWaitingList!.add(RequestWaitingList.fromJson(v));
      });
    } else {
      requestWaitingList = null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_cancelled'] = isCancelled;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    super.toJson().forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class Service {
  double? price;
  String? serviceType;
  String? eventType;
  String? bookingType;
  Location? location;
  ServiceDetail_Event? event;
  ServiceDetail_Lesson? lesson;
  List<ServiceDetail_Coach>? coaches;

  bool get isOpenMatch =>
      bookingType?.toLowerCase() == 'Open Match'.toLowerCase();

  bool get isEvent => serviceType?.toLowerCase() == 'Event'.toLowerCase();

  bool get isLesson => serviceType?.toLowerCase() == 'Lesson'.toLowerCase();

  bool get isSingleEvent => eventType?.toLowerCase() == 'Single'.toLowerCase();

  String get eventLessonName =>
      (isEvent ? event?.eventName ?? '' : lesson?.lessonName ?? '')
          .capitalizeFirst;

  Service(
      {this.price,
      this.serviceType,
      this.eventType,
      this.bookingType,
      this.location,
      this.event,
      this.lesson});

  Service.fromJson(Map<String, dynamic> json) {
    price = double.tryParse(json['price'].toString());
    serviceType = json['service_type'];
    eventType = json['event_type'];
    bookingType = json['booking_type'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    event = json['event'] != null
        ? ServiceDetail_Event.fromJson(json['event'])
        : null;
    lesson = json['lesson'] != null
        ? ServiceDetail_Lesson.fromJson(json['lesson'])
        : null;
    if (json['coaches'] != null) {
      coaches = <ServiceDetail_Coach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetail_Coach.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['service_type'] = serviceType;
    data['event_type'] = eventType;
    data['booking_type'] = bookingType;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (event != null) {
      data['event'] = event!.toJson();
    }
    if (lesson != null) {
      data['lesson'] = lesson!.toJson();
    }
    if (coaches != null) {
      data['coaches'] = coaches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  int? id;
  String? _locationName;
  String? currency;

  String get locationName => _locationName?.capitalizeFirst ?? '';

  Location({this.id, String? location, this.currency})
      : _locationName = location;

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _locationName = json['location_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_name'] = locationName;
    data['currency'] = currency;
    return data;
  }
}

class Players extends BookingPlayerBase {
  Players({
    super.id,
    super.isWaiting,
    super.reservedPlayersCount,
    super.isOrganizer,
    super.otherPlayer,
    super.isCanceled,
    super.position,
    super.customer,
  });

  Players.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customer = json['customer'] != null
        ? BookingCustomerBase.fromJson(json['customer'])
        : null;
  }
}

class Courts {
  int? id;
  String? courtName;

  Courts({this.id, this.courtName});

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courtName = json['court_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['court_name'] = courtName;
    return data;
  }
}

class RequestWaitingList {
  final int? id;
  final String? status;

  RequestWaitingList({required this.id, required this.status});

  RequestWaitingList.fromJson(Map<String, dynamic> json)
      : id = json['customer_id'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    return {
      'customer_id': id,
      'status': status,
    };
  }
}
