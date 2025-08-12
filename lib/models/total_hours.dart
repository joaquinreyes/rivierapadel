class TotalHours {
  double? totalPaidBookings;
  double? totalBookedHours;
  List<SportBookings>? sportBookings;

  double get padelHrs {
    int index = sportBookings?.indexWhere(
            (element) => element.sportName?.toLowerCase() == 'padel') ??
        -1;
    if (index == -1) {
      return 0;
    }
    return sportBookings?[index].bookedHours ?? 0;
  }

  TotalHours(
      {this.totalPaidBookings, this.totalBookedHours, this.sportBookings});

  TotalHours.fromJson(Map<String, dynamic> json) {
    totalPaidBookings = json['totalPaidBookings']?.toDouble();
    totalBookedHours = json['totalBookedHours']?.toDouble();
    if (json['sportBookings'] != null) {
      sportBookings = <SportBookings>[];
      json['sportBookings'].forEach((v) {
        sportBookings!.add(new SportBookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPaidBookings'] = totalPaidBookings;
    data['totalBookedHours'] = totalBookedHours;
    if (sportBookings != null) {
      data['sportBookings'] = sportBookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SportBookings {
  String? sportName;
  double? bookedHours;

  SportBookings({this.sportName, this.bookedHours});

  SportBookings.fromJson(Map<String, dynamic> json) {
    sportName = json['sport_name'];
    bookedHours = json['booked_hours']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sport_name'] = sportName;
    data['booked_hours'] = bookedHours;
    return data;
  }
}
