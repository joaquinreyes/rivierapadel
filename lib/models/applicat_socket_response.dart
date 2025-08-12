import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/models/service_waiting_players.dart';

class ApplicantSocketResponse {
  ServiceDetail? serviceBooking;
  List<ServiceWaitingPlayers>? waitingList;

  ApplicantSocketResponse({this.serviceBooking, this.waitingList});

  ApplicantSocketResponse.fromJson(Map<String, dynamic> json) {
    serviceBooking = json['serviceBooking'] != null
        ? ServiceDetail.fromJson(json['serviceBooking'])
        : null;
    if (json['waitingList'] != null) {
      waitingList = <ServiceWaitingPlayers>[];
      json['waitingList'].forEach((v) {
        waitingList!.add(ServiceWaitingPlayers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceBooking != null) {
      data['serviceBooking'] = serviceBooking!.toJson();
    }
    if (waitingList != null) {
      data['waitingList'] = waitingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
