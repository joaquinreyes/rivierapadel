import 'package:acepadel/models/base_classes/booking_base.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class OpenMatchModel extends BookingBase {
  OpenMatchService? service;
  List<OpenMatchCourts>? courts;
  List<OpenMatchPlayers>? players;

  get court => (courts?.isNotEmpty ?? false) ? courts?.first.courtName : '';
  bool get isFull => players?.length == service?.booking?.maximumCapacity;
  OpenMatchModel(
      {super.id,
      super.date,
      super.startTime,
      super.endTime,
      this.service,
      this.courts,
      this.players});

  OpenMatchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    isFriendlyMatch = json['friendly_match'];
    endTime = json['end_time'];
    service = json['service'] != null
        ? OpenMatchService.fromJson(json['service'])
        : null;
    if (json['courts'] != null) {
      courts = <OpenMatchCourts>[];
      json['courts'].forEach((v) {
        courts!.add(OpenMatchCourts.fromJson(v));
      });
    }
    if (json['players'] != null) {
      players = <OpenMatchPlayers>[];
      json['players'].forEach((v) {
        players!.add(OpenMatchPlayers.fromJson(v));
      });
    }
    if (json['openMatchOptions'] != null) {
      options = OpenMatchOptions.fromJson(json['openMatchOptions']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class OpenMatchService {
  double? price;
  OpenMatchLocation? location;
  OpenMatchBooking? booking;

  OpenMatchService({this.price, this.location, this.booking});

  OpenMatchService.fromJson(Map<String, dynamic> json) {
    price = double.tryParse(json['price'].toString());
    location = json['location'] != null
        ? OpenMatchLocation.fromJson(json['location'])
        : null;
    booking = json['booking'] != null
        ? OpenMatchBooking.fromJson(json['booking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    return data;
  }
}

class OpenMatchLocation {
  int? id;
  String? _locationName;
  String? currency;

  String get locationName => _locationName?.capitalizeFirst ?? '';

  OpenMatchLocation({this.id, String? locationName, this.currency})
      : _locationName = locationName;

  OpenMatchLocation.fromJson(Map<String, dynamic> json) {
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

class OpenMatchBooking {
  int? id;
  int? maximumCapacity;
  int? minimumCapacity;

  OpenMatchBooking({this.id, this.maximumCapacity, this.minimumCapacity});

  OpenMatchBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maximumCapacity = json['maximum_capacity'];
    minimumCapacity = json['minimum_capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maximum_capacity'] = maximumCapacity;
    data['minimum_capacity'] = minimumCapacity;
    return data;
  }
}

class OpenMatchCourts {
  int? id;
  String? courtName;

  OpenMatchCourts({this.id, this.courtName});

  OpenMatchCourts.fromJson(Map<String, dynamic> json) {
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

class OpenMatchPlayers extends BookingPlayerBase {
  OpenMatchPlayers(
      {super.reservedPlayersCount,
      super.isWaiting,
      super.customer,
      super.otherPlayer,
      super.id,
      super.position});

  OpenMatchPlayers.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customer = json['customer'] != null
        ? BookingCustomerBase.fromJson(json['customer'])
        : null;
  }
}
