// import 'package:acepadel/models/app_user.dart';
//
// class BookingPlayerBase {
//   int? reservedPlayersCount;
//   bool? isWating;
//   BookingCustomerBase? customer;
//   int? otherPlayer;
//   int? id;
//   bool? isOrganizer;
//   bool? isCanceled;
//
//   bool? reserved = false;
//   int? position;
//   BookingPlayerBase(
//       {this.reservedPlayersCount,
//       this.isWating,
//       this.customer,
//       this.otherPlayer,
//       this.id,
//       this.isOrganizer,
//       this.isCanceled,
//       this.position});
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['reserved_players_count'] = reservedPlayersCount;
//     data['is_wating'] = isWating;
//     data['other_player'] = otherPlayer;
//     if (customer != null) {
//       data['customer'] = customer!.toJson();
//     }
//     data['is_organizer'] = isOrganizer ?? false;
//     data['is_canceled'] = isCanceled ?? false;
//     data['position'] = position;
//     data['reserved'] = reserved;
//     return data;
//   }
//
//   BookingPlayerBase.fromJson(Map<String, dynamic> json) {
//     reservedPlayersCount = json['reserved_players_count'];
//     isWating = json['is_wating'];
//     customer = json['customer'] != null
//         ? BookingCustomerBase.fromJson(json['customer'])
//         : null;
//     otherPlayer = json['other_player'];
//     id = json['id'];
//     isOrganizer = json['is_organizer'];
//     isCanceled = json['is_canceled'];
//     position = json['position'];
//     reserved = json['reserved'];
//   }
// }
//
// class BookingCustomerBase {
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? profileUrl;
//   double? _level;
//   List<UserSportsLevel> sportsLevel = [];
//
//   BookingCustomerBase(
//       {this.id, this.firstName, this.lastName, this.profileUrl});
//
//   String? level(String sportName) {
//     final dLevel = _level?.toString();
//     if (sportsLevel.isEmpty) {
//       return dLevel;
//     }
//     int indexOFSport = sportsLevel.indexWhere((element) =>
//         element.sportName?.toLowerCase() == sportName.toLowerCase());
//     if (indexOFSport == -1) {
//       return dLevel;
//     }
//     return sportsLevel[indexOFSport].level?.toString();
//   }
//
//   BookingCustomerBase.fromJson(Map<String, dynamic> json) {
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     profileUrl = json['profile_url'];
//     id = json['id'];
//     _level = json['level']?.toDouble();
//     if (json['sportsLevel'] != null) {
//       sportsLevel = <UserSportsLevel>[];
//       json['sportsLevel'].forEach((v) {
//         sportsLevel.add(UserSportsLevel.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['profile_url'] = profileUrl;
//     data['id'] = id;
//     if (sportsLevel.isNotEmpty) {
//       data['sportsLevel'] = sportsLevel.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

import 'package:acepadel/models/app_user.dart';

class BookingPlayerBase {
  int? reservedPlayersCount;
  bool? isWaiting;
  BookingCustomerBase? customer;
  int? otherPlayer;
  int? id;
  bool? isOrganizer;
  bool? isCanceled;

  bool? reserved = false;
  int? position;

  Guest? guest;

  String get getCustomerName {
    if (customer == null && guest == null) {
      return "";
    }
    if (customer?.firstName != null) {
      return customer?.firstName ?? "";
    }
    if (guest?.name != null) {
      return "${guest?.name ?? " "} (G)";
    }
    return customer?.firstName ?? guest?.name ?? "";
  }

  BookingPlayerBase(
      {this.guest,
      this.reservedPlayersCount,
      this.isWaiting,
      this.customer,
      this.otherPlayer,
      this.id,
      this.isOrganizer,
      this.isCanceled,
      this.position});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reserved_players_count'] = reservedPlayersCount;
    data['is_wating'] = isWaiting;
    data['other_player'] = otherPlayer;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['is_organizer'] = isOrganizer ?? false;
    data['is_canceled'] = isCanceled ?? false;
    data['position'] = position;
    data['reserved'] = reserved;
    if (guest != null) {
      data['guest'] = guest!.toJson();
    }
    return data;
  }

  BookingPlayerBase.fromJson(Map<String, dynamic> json) {
    reservedPlayersCount = json['reserved_players_count'];
    isWaiting = json['is_wating'];
    customer = json['customer'] != null
        ? BookingCustomerBase.fromJson(json['customer'])
        : null;
    otherPlayer = json['other_player'];
    id = json['id'];
    isOrganizer = json['is_organizer'];
    isCanceled = json['is_canceled'];
    position = json['position'];
    reserved = json['reserved'] ?? false;
    guest = json['guest'] != null ? Guest.fromJson(json['guest']) : null;
  }
}

class Guest {
  int? id;
  String? name;

  Guest({this.id, this.name});

  Guest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class BookingCustomerBase {
  int? id;
  String? firstName;
  String? lastName;
  String? profileUrl;
  double? last21Evaluation;
  int? rankedMatchesPlayed;
  double? winningStrike;
  double? _level;
  List<UserSportsLevel> sportsLevel = [];
  Map<String, dynamic> customFields = {};

  String get playingSide =>
      customFields['Prefered Side'] ?? customFields['Preferred Side'] ?? "";

  String? get startedPlaying => customFields['Started Playing'];

  BookingCustomerBase({
    this.id,
    this.firstName,
    this.lastName,
    this.profileUrl,
    this.customFields = const {},
    this.last21Evaluation,
    this.rankedMatchesPlayed,
    this.winningStrike,
  });

  String? level(String sportName) {
    final dLevel = _level?.toString();
    if (sportsLevel.isEmpty) {
      return dLevel ?? "";
    }
    int indexOFSport = sportsLevel.indexWhere((element) =>
        element.sportName?.toLowerCase() == sportName.toLowerCase());
    if (indexOFSport == -1) {
      return dLevel ?? "";
    }
    return sportsLevel[indexOFSport].level?.toString();
  }

  double levelD(String sportName) {
    final dLevel = _level;

    if (sportsLevel.isEmpty) {
      return dLevel ?? 0;
    }
    int indexOFSport = sportsLevel.indexWhere((element) =>
        element.sportName?.toLowerCase() == sportName.toLowerCase());
    if (indexOFSport == -1) {
      return dLevel ?? 0;
    }

    return sportsLevel[indexOFSport].level ?? 0;
  }

  BookingCustomerBase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
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
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['last21Evaluation'] = last21Evaluation;
    data['rankedMatchesPlayed'] = rankedMatchesPlayed;
    data['winningStrike'] = winningStrike;
    data['profile_url'] = profileUrl;
    data['custom_fields'] = customFields;
    data['level'] = _level;
    if (sportsLevel.isNotEmpty) {
      data['sportsLevel'] = sportsLevel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
