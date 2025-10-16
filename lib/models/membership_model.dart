import 'membership_list_category_model.dart';

class MembershipModel {
  int? id;
  int? clubId;
  String? membershipName;
  String? duration;
  int? usesLimit;
  double? price;
  int? totalUses;
  String? currency;
  bool? appAvailable;
  int? membershipCategoryId;
  MembershipCategory? membershipCategory;
  String? description;
  List<Locations>? locations;

  int get locationId {
    if (locations != null && locations!.isNotEmpty) {
      return locations!.first.id ?? 0;
    }
    return 0;
  }

  String? get categoryName {
    return membershipCategory?.categoryName;
  }

  MembershipModel(
      {this.id,
      this.clubId,
      this.membershipName,
      this.duration,
      this.usesLimit,
      this.price,
      this.totalUses,
      this.currency,
      this.appAvailable,
      this.membershipCategory,
      this.membershipCategoryId,
      this.description,
      this.locations});

  MembershipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    membershipName = json['membership_name'];
    duration = json['duration'];
    usesLimit = json['uses_limit'];
    price = double.tryParse(json['price'].toString());
    totalUses = json['totalUses'];
    currency = json['currency'];
    appAvailable = json['app_available'];
    membershipCategory = json['membershipCategory'] != null
        ? MembershipCategory.fromJson(json['membershipCategory'])
        : null;
    membershipCategoryId = json['membership_category_id'];
    description = json['description'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['club_id'] = clubId;
    data['membership_name'] = membershipName;
    data['duration'] = duration;
    data['uses_limit'] = usesLimit;
    data['price'] = price;
    data['totalUses'] = totalUses;
    data['currency'] = currency;
    data['app_available'] = appAvailable;
    data['membership_category_id'] = membershipCategoryId;
    if (membershipCategory != null) {
      data['membershipCategory'] = membershipCategory!.toJson();
    }
    data['description'] = description;
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  int? id;
  String? locationName;

  Locations({this.id, this.locationName});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_name'] = locationName;
    return data;
  }
}
