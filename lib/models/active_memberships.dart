class ActiveMemberships {
  int? id;
  String? membershipName;

  ActiveMemberships({this.id, this.membershipName});

  ActiveMemberships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    membershipName = json['membership_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['membership_name'] = membershipName;
    return data;
  }
}
