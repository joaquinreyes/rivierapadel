class AssessmentResModel {
  TeamA? teamA;
  TeamA? teamB;

  AssessmentResModel({this.teamA, this.teamB});

  AssessmentResModel.fromJson(Map<String, dynamic> json) {
    teamA = json['teamA'] != null ? TeamA.fromJson(json['teamA']) : null;
    teamB = json['teamB'] != null ? TeamA.fromJson(json['teamB']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teamA != null) {
      data['teamA'] = teamA!.toJson();
    }
    if (teamB != null) {
      data['teamB'] = teamB!.toJson();
    }
    return data;
  }
}

class TeamA {
  int? id;
  int? serviceBookingId;
  String? team;
  int? score1;
  int? score2;
  int? score3;

  TeamA(
      {this.id,
      this.serviceBookingId,
      this.team,
      this.score1,
      this.score2,
      this.score3});

  TeamA.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceBookingId = json['service_booking_id'];
    team = json['team'];
    score1 = json['score1'];
    score2 = json['score2'];
    score3 = json['score3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_booking_id'] = serviceBookingId;
    data['team'] = team;
    data['score1'] = score1;
    data['score2'] = score2;
    data['score3'] = score3;
    return data;
  }
}
