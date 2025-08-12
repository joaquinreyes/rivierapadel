import 'package:acepadel/models/service_detail_model.dart';

class ApprovedRequest_SocketResponse {
  // ServiceBooking? serviceBooking;
  ServiceDetail? serviceBooking;
  ApprovedRequest_WaitingList? waitingList;

  ApprovedRequest_SocketResponse({this.serviceBooking, this.waitingList});

  ApprovedRequest_SocketResponse.fromJson(Map<String, dynamic> json) {
    serviceBooking = json['serviceBooking'] != null
        ? ServiceDetail.fromJson(json['serviceBooking'])
        : null;
    waitingList = json['waitingList'] != null
        ? ApprovedRequest_WaitingList.fromJson(json['waitingList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceBooking != null) {
      data['serviceBooking'] = serviceBooking!.toJson();
    }
    if (waitingList != null) {
      data['waitingList'] = waitingList!.toJson();
    }
    return data;
  }
}

class ApprovedRequest_WaitingList {
  int? id;
  int? serviceBookingId;
  int? customerId;
  int? playerId;
  int? requestedPlayerId;
  int? position;
  String? status;

  ApprovedRequest_WaitingList(
      {this.id,
      this.serviceBookingId,
      this.customerId,
      this.playerId,
      this.requestedPlayerId,
      this.position,
      this.status});

  ApprovedRequest_WaitingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceBookingId = json['service_booking_id'];
    customerId = json['customer_id'];
    playerId = json['player_id'];
    requestedPlayerId = json['requested_player_id'];
    position = json['position'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_booking_id'] = serviceBookingId;
    data['customer_id'] = customerId;
    data['player_id'] = playerId;
    data['requested_player_id'] = requestedPlayerId;
    data['position'] = position;
    data['status'] = status;
    return data;
  }
}
