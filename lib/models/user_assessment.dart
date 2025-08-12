import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/models/service_detail_model.dart';
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

  Assessments({
    this.id,
    this.date,
    this.service,
    this.players,
    this.openMatchScores,
  });

  Assessments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
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
}

class Service {
  String? bookingType;
  Booking? booking;

  Service({this.bookingType, this.booking});

  Service.fromJson(Map<String, dynamic> json) {
    bookingType = json['booking_type'];
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_type'] = bookingType;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    return data;
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
