import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/models/base_classes/booking_base.dart';
import '../utils/dubai_date_time.dart';

class UserAssessment {
  List<Assessments>? assessments;
  User? customer;

  UserAssessment({this.assessments, this.customer});

  UserAssessment.fromJson(Map<String, dynamic> json) {
    if (json['assessments'] != null) {
      assessments = <Assessments>[];
      json['assessments'].forEach((v) {
        assessments!.add(Assessments.fromJson(v));
      });
    }
    customer =
        json['customer'] != null ? User.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessments != null) {
      data['assessments'] = assessments!.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Assessments {
  int? id;
  String? date;
  Service? service;
  List<ServiceDetail_Players>? players;
  List<OpenMatchScores>? openMatchScores;
  OpenMatchOptions? options;
  String? startTime;
  String? endTime;
  bool? rankedEvent;
  bool? scoreSubmitted;
  int? maximumCapacity;
  int? minimumCapacity;

  DateTime get bookingDate {
    if (date == null) {
      return DubaiDateTime.now().dateTime;
    }
    return DubaiDateTime.parse(date ?? "").dateTime;
  }

  List<int?> get teamAScore {
    OpenMatchScores? teamA =
        openMatchScores?.firstWhere((element) => element.team == "A");
    return [teamA?.score1, teamA?.score2, teamA?.score3];
  }

  List<int?> get teamBScore {
    OpenMatchScores? teamB =
        openMatchScores?.firstWhere((element) => element.team == "B");
    return [teamB?.score1, teamB?.score2, teamB?.score3];
  }

  List<ServiceDetail_Players> get teamAPlayers {
// first two players are from team A
    List<ServiceDetail_Players> listA = [];
    try {
      var a1 = players?.lastWhere((element) => element.position == 1);
      var a2 = players?.lastWhere((element) => element.position == 2);
      if (a1 != null) {
        listA.add(a1);
      }
      if (a2 != null) {
        listA.add(a2);
      }
      // players?.where((element) => element.position == 1);
      return listA;
    } catch (e) {
      return players?.sublist(0, 2) ?? [];
    }
  }

  List<ServiceDetail_Players> get teamBPlayers {
// last two players are from team B
//     return players?.sublist(2, 4) ?? [];
    List<ServiceDetail_Players> listB = [];
    try {
      var b1 = players?.lastWhere((element) => element.position == 3);
      var b2 = players?.lastWhere((element) => element.position == 4);
      if (b1 != null) {
        listB.add(b1);
      }
      if (b2 != null) {
        listB.add(b2);
      }
      // players?.where((element) => element.position == 1);
      return listB;
    } catch (e) {
      return players?.sublist(0, 2) ?? [];
    }
  }

  bool get isEvent {
    return service?.event != null;
  }

  String get openMatchLevelRange {
    String minLevel = options?.minLevel?.toString() ?? "";
    String maxLevel = options?.maxLevel?.toString() ?? "";
    if (minLevel.isEmpty || maxLevel.isEmpty) {
      return "";
    }
    return "$minLevel - $maxLevel";
  }

  Assessments({
    this.id,
    this.date,
    this.service,
    this.players,
    this.openMatchScores,
    this.options,
    this.startTime,
    this.endTime,
    this.rankedEvent,
    this.scoreSubmitted,
    this.maximumCapacity,
    this.minimumCapacity,
  });

  Assessments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    rankedEvent = json['ranked_event'];
    scoreSubmitted = json['score_submitted'];
    minimumCapacity = json['minimum_capacity'];
    maximumCapacity = json['maximum_capacity'];
    options = json['openMatchOptions'] != null
        ? OpenMatchOptions.fromJson(json['openMatchOptions'])
        : null;
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    if (json['players'] != null) {
      players = <ServiceDetail_Players>[];
      json['players'].forEach((v) {
        players!.add(ServiceDetail_Players.fromJson(v));
      });
    }
    if (json['openMatchScores'] != null) {
      openMatchScores = <OpenMatchScores>[];
      json['openMatchScores'].forEach((v) {
        openMatchScores!.add(OpenMatchScores.fromJson(v));
      });
    }
    if (isEvent) {
      service?.serviceType = "Event";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['end_time'] = endTime;
    data['start_time'] = startTime;
    data['minimum_capacity'] = minimumCapacity;
    data['maximum_capacity'] = maximumCapacity;
    data['score_submitted'] = scoreSubmitted;
    data['ranked_event'] = rankedEvent;
    data['openMatchOptions'] = options;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    if (openMatchScores != null) {
      data['openMatchScores'] =
          openMatchScores!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  UserBookings toUserBookings() {
    return UserBookings(
      id: id,
      date: date,
      startTime: startTime,
      endTime: endTime,
      service: service,
      rankedEvent: rankedEvent,
      minimumCapacity: maximumCapacity,
      maximumCapacity: maximumCapacity,
      scoreSubmitted: scoreSubmitted,
      openMatchOptions: options,
      players: players?.map((p) => Players.fromServiceDetailPlayer(p)).toList(),
      coaches: service?.coaches,
    );
  }
}


class Booking {
  int? id;
  int? maximumCapacity;

  Booking({this.id, this.maximumCapacity});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maximumCapacity = json['maximum_capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maximum_capacity'] = maximumCapacity;
    return data;
  }
}

class OpenMatchScores {
  int? id;
  String? team;
  int? score1;
  int? score2;
  int? score3;

  OpenMatchScores({this.id, this.team, this.score1, this.score2, this.score3});

  OpenMatchScores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    team = json['team'];
    score1 = json['score1'];
    score2 = json['score2'];
    score3 = json['score3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['team'] = team;
    data['score1'] = score1;
    data['score2'] = score2;
    data['score3'] = score3;
    return data;
  }
}
