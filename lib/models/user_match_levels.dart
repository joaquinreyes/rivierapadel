class UserMatchLevelsResponse {
  String? status;
  String? message;
  List<MatchLevel>? data;

  UserMatchLevelsResponse({this.status, this.message, this.data});

  UserMatchLevelsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MatchLevel>[];
      json['data'].forEach((v) {
        data!.add(MatchLevel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchLevel {
  double? level;
  String? sportName;

  MatchLevel({this.level, this.sportName});

  MatchLevel.fromJson(Map<String, dynamic> json) {
    level = json['level']?.toDouble();
    sportName = json['sport_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['level'] = level;
    data['sport_name'] = sportName;
    return data;
  }
}