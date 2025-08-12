import 'package:acepadel/models/base_classes/booking_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class EventsModel extends BookingBase {
  EventsService? service;
  List<EventsPlayers>? players;

  bool get isFull => players?.length == getMaximumCapacity;

  int get getMinimumCapacity =>
      minimumCapacity ?? service?.event?.minimumCapacity ?? 0;

  int get getMaximumCapacity =>
      maximumCapacity ?? service?.event?.maximumCapacity ?? 0;

  EventsModel(
      {super.id,
      super.date,
      super.startTime,
      super.endTime,
      super.coaches,
      this.service,
      this.players});

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

  EventsModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isFriendlyMatch = json['friendly_match'];
    service = json['service'] != null
        ? EventsService.fromJson(json['service'])
        : null;
    if (json['players'] != null) {
      players = <EventsPlayers>[];
      json['players'].forEach((v) {
        players!.add(EventsPlayers.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <ServiceDetail_Coach>[];
      json['coaches'].forEach((v) {
        coaches!.add(ServiceDetail_Coach.fromJson(v));
      });
    }
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (service != null) {
      data['service'] = service!.toJson();
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

class EventsService {
  double? price;
  String? additionalService;
  EventsLocation? location;
  Event? event;
  List<ServiceDetail_Coach>? coaches;

  EventsService(
      {this.price, this.additionalService, this.location, this.event});

  EventsService.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    additionalService = json['additional_service'];
    location = json['location'] != null
        ? EventsLocation.fromJson(json['location'])
        : null;
    event = json['event'] != null ? Event.fromJson(json['event']) : null;
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
    data['additional_service'] = additionalService;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (event != null) {
      data['event'] = event!.toJson();
    }
    return data;
  }
}

class EventsLocation {
  int? id;
  String? _locationName;
  String? currency;

  String get locationName => _locationName?.capitalizeFirst ?? '';

  EventsLocation({this.id, String? locationName, this.currency})
      : _locationName = locationName;

  EventsLocation.fromJson(Map<String, dynamic> json) {
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

class Event {
  int? minimumCapacity;
  int? maximumCapacity;
  String? eventName;
  double? minLevelRestriction;
  double? maxLevelRestriction;

  Event(
      {this.minimumCapacity,
      this.maximumCapacity,
      this.eventName,
      this.minLevelRestriction,
      this.maxLevelRestriction});

  String? get levelRestriction {
    if (minLevelRestriction == null && maxLevelRestriction == null) {
      return null;
    }
    if (minLevelRestriction == 0.0 && maxLevelRestriction == 0.0) {
      return null;
    }
    return '$minLevelRestriction - $maxLevelRestriction';
  }

  Event.fromJson(Map<String, dynamic> json) {
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    eventName = json['event_name'];
    minLevelRestriction = json['min_level_restrication']?.toDouble();
    maxLevelRestriction = json['max_level_restrication']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minimum_capacity'] = minimumCapacity;
    data['maximum_capacity'] = maximumCapacity;
    data['event_name'] = eventName;
    data['min_level_restriction'] = minLevelRestriction;
    data['max_level_restriction'] = maxLevelRestriction;
    return data;
  }
}

class EventsPlayers {
  int? id;

  EventsPlayers({this.id});

  EventsPlayers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
