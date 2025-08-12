import 'package:acepadel/globals/constants.dart';

class RegisterModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneCode;
  String? phoneNumber;
  String? password;
  List<double?> levelAnswers = [];

  // bool? isOptInForMarketing;
  Map<String, dynamic> customFields = {kPositionID: ""};

  set playingSide(String? value) {
    customFields[kPositionID] = value;
  }

  String? get playingSide => customFields[kPositionID];

  // String? get playingSide => customFields[kPositionID];

  RegisterModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.password,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    password = json['password'];

    customFields = json['custom_fields'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneCode! + phoneNumber!;
    data['password'] = password;
    data['custom_fields'] = customFields;
    data['quiz_answers'] = levelAnswers;
    return data;
  }
}
