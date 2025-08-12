// import 'package:acepadel/models/base_classes/booking_player_base.dart';
//
// class ServiceWaitingPlayers {
//   int? id;
//   BookingCustomerBase? customer;
//   String? status;
//
//   bool get isApproved => status?.toLowerCase() == 'approved';
//
//   ServiceWaitingPlayers({this.id, this.customer, this.status});
//
//   ServiceWaitingPlayers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     status = json['status'];
//     customer = json['customer'] != null
//         ? BookingCustomerBase.fromJson(json['customer'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['status'] = status;
//     if (customer != null) {
//       data['customer'] = customer!.toJson();
//     }
//     return data;
//   }
// }

import 'package:acepadel/models/base_classes/booking_player_base.dart';

class ServiceWaitingPlayers extends BookingPlayerBase {
  String? status;

  bool get isApproved => status?.toLowerCase() == 'approved';

  ServiceWaitingPlayers({
    super.reservedPlayersCount,
    super.isWaiting,
    super.customer,
    super.otherPlayer,
    super.id,
    super.position,
    this.status,
  });

  ServiceWaitingPlayers.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['status'];
    customer = json['customer'] != null
        ? BookingCustomerBase.fromJson(json['customer'])
        : null;
  }
}
