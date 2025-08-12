class ChatSocketChatMessageModel {
  Message? message;

  ChatSocketChatMessageModel({this.message});

  ChatSocketChatMessageModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? matchId;
  String? message;
  int? adminId;
  int? customerId;
  String? createdAt;
  String? sId;
  int? iV;

  Message(
      {this.matchId,
      this.message,
      this.adminId,
      this.customerId,
      this.createdAt,
      this.sId,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    matchId = int.tryParse(json['match_id'].toString());
    message = json['message'];
    adminId = int.tryParse(json['admin_id'].toString());
    customerId = int.tryParse(json['customer_id'].toString());
    createdAt = json['created_at'];
    sId = json['_id'];
    iV = int.tryParse(json['__v'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['match_id'] = matchId;
    data['message'] = message;
    data['admin_id'] = adminId;
    data['customer_id'] = customerId;
    data['created_at'] = createdAt;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}
