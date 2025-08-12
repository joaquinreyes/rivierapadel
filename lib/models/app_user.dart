class AppUser {
  String? accessToken;
  User? user;

  AppUser({this.accessToken, this.user});

  AppUser.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? phoneNumber;
  String? email;
  String? firstName;
  String? lastName;
  int? clubId;
  String? profileUrl;

  double? last21Evaluation;
  int? rankedMatchesPlayed;
  double? winningStrike;

  Map<String, dynamic> customFields = {};

  List<UserSportsLevel> sportsLevel = [];

  String get playingSide =>
      customFields['Prefered Side'] ?? customFields['Preferred Side'] ?? "-";

  String? get startedPlaying => customFields['Started Playing'];
  double? _level;

  double? level(String sportName) {
    if (sportsLevel.isEmpty) {
      return _level;
    }
    int indexOFSport = sportsLevel.indexWhere((element) =>
        element.sportName?.toLowerCase() == sportName.toLowerCase());
    if (indexOFSport == -1) {
      return _level;
    }
    return sportsLevel[indexOFSport].level;
  }

  User(
      {this.id,
      this.phoneNumber,
      this.email,
      this.firstName,
      this.lastName,
      this.clubId,
      this.last21Evaluation,
      this.rankedMatchesPlayed,
      this.winningStrike,
      this.profileUrl,
      this.customFields = const {}});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    clubId = json['club_id'];
    profileUrl = json['profile_url'];
    last21Evaluation = double.tryParse(json['last21Evaluation'].toString());
    rankedMatchesPlayed = json['rankedMatchesPlayed'];
    winningStrike = double.tryParse(json['winningStrike'].toString());
    _level = json['level']?.toDouble();
    if (json['custom_fields'] != null) {
      customFields = json['custom_fields'];
    } else if (json['customFields'] != null) {
      customFields = json['customFields'];
    }

    if (json['levels'] != null) {
      sportsLevel = <UserSportsLevel>[];
      json['levels'].forEach((v) {
        sportsLevel.add(UserSportsLevel.fromJson(v));
      });
    } else if (json['sportsLevel'] != null) {
      sportsLevel = <UserSportsLevel>[];
      json['sportsLevel'].forEach((v) {
        sportsLevel.add(UserSportsLevel.fromJson(v));
      });
    }

    if (json['customerDetails'] != null) {
      id = json['customerDetails']['id'];
      firstName = json['customerDetails']['first_name'];
      lastName = json['customerDetails']['last_name'];
      profileUrl = json['customerDetails']['profile_url'];
      if (json['customerDetails']['sportsLevel'] != null) {
        sportsLevel = <UserSportsLevel>[];
        json['customerDetails']['sportsLevel'].forEach((v) {
          sportsLevel.add(UserSportsLevel.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['last21Evaluation'] = last21Evaluation;
    data['rankedMatchesPlayed'] = rankedMatchesPlayed;
    data['winningStrike'] = winningStrike;
    data['club_id'] = clubId;
    data['profile_url'] = profileUrl;
    data['custom_fields'] = customFields;
    data['level'] = _level;
    if (sportsLevel.isNotEmpty) {
      data['sportsLevel'] = sportsLevel.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String get fullName => '$firstName $lastName';

  copyWithForUpdate({
    String? phoneNumber,
    String? email,
    String? firstName,
    String? lastName,
    Map<String, dynamic> customFields = const {},
  }) {
    return User(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      customFields: customFields.isEmpty ? this.customFields : customFields,
    );
  }

  copy(User? other) {
    id = other?.id ?? id;
    phoneNumber = other?.phoneNumber ?? phoneNumber;
    email = other?.email ?? email;
    firstName = other?.firstName ?? firstName;
    lastName = other?.lastName ?? lastName;
    clubId = other?.clubId ?? clubId;
    profileUrl = other?.profileUrl ?? profileUrl;
    customFields = (other?.customFields.isEmpty ?? false)
        ? customFields
        : (other?.customFields ?? customFields);
    _level = other?._level ?? _level;
    sportsLevel = (other?.sportsLevel.isEmpty ?? true)
        ? sportsLevel
        : (other?.sportsLevel ?? sportsLevel);
  }
}

class UserSportsLevel {
  String? sportName;
  double? level;

  UserSportsLevel({this.sportName, this.level});

  UserSportsLevel.fromJson(Map<String, dynamic> json) {
    sportName = json['sport_name'];
    level = double.tryParse(json['level'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sport_name'] = sportName;
    data['level'] = double.tryParse(level.toString());
    return data;
  }
}
