import 'chat_socket_chat_message_model.dart';

class ChatSocketJoinModel {
  List<Message>? chats;
  List<Admin>? admin;
  List<Users>? users;

  ChatSocketJoinModel({this.chats, this.admin, this.users});

  ChatSocketJoinModel.fromJson(Map<String, dynamic> json) {
    if (json['chats'] != null) {
      chats = <Message>[];
      json['chats'].forEach((v) {
        chats!.add(Message.fromJson(v));
      });
    }
    if (json['admin'] != null) {
      admin = <Admin>[];
      json['admin'].forEach((v) {
        admin!.add(Admin.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    if (admin != null) {
      data['admin'] = admin!.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Admin {
  int? id;
  String? fullName;
  int? roleId;

  Admin({this.id, this.fullName, this.roleId});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['role_id'] = roleId;
    return data;
  }
}

class Users {
  int? id;
  bool? isCanceled;
  bool? isOrganizer;
  Customer? customer;

  Users({this.id, this.isOrganizer, this.isCanceled, this.customer});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isCanceled = json['is_canceled'];
    isOrganizer = json['is_organizer'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_canceled'] = isCanceled;
    data['is_organizer'] = isOrganizer;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;

  Customer({this.id, this.firstName, this.lastName});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
