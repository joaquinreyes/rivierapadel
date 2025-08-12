import 'dart:io';

import 'package:flutter/foundation.dart';

class AppUpdateModel {
  int? id;
  int? clubId;
  String? iosUrl;
  String? androidUrl;
  String? iosVersion;
  String? androidVersion;
  bool? iosForceUpdate;
  bool? androidForceUpdate;

  AppUpdateModel({
    this.id,
    this.clubId,
    this.iosUrl,
    this.androidUrl,
    this.iosVersion,
    this.androidVersion,
    this.iosForceUpdate,
    this.androidForceUpdate,
  });

  String get url {
    if (Platform.isIOS) {
      return iosUrl ?? '';
    } else {
      return androidUrl ?? '';
    }
  }

  bool showUpdate(String currentVersion) {
    if (kIsWeb) {
      return false;
    }

    if (currentVersion.isEmpty ||
        (iosVersion ?? "").isEmpty ||
        (androidVersion ?? "").isEmpty) {
      return false;
    }

    if (Platform.isIOS) {
      if (compareVersions(currentVersion, iosVersion ?? "") < 0 &&
          iosForceUpdate == true) {
        return true;
      }
    } else {
      if (compareVersions(currentVersion, androidVersion ?? "") < 0 &&
          androidForceUpdate == true) {
        return true;
      }
    }

    return false;
  }

  int compareVersions(String v1, String v2) {
    List<String> v1Parts = v1.split('.');
    List<String> v2Parts = v2.split('.');
    int length =
        v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

    for (int i = 0; i < length; i++) {
      int part1 = i < v1Parts.length ? int.tryParse(v1Parts[i]) ?? 0 : 0;
      int part2 = i < v2Parts.length ? int.tryParse(v2Parts[i]) ?? 0 : 0;

      if (part1 < part2) return -1;
      if (part1 > part2) return 1;
    }
    return 0;
  }

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    iosUrl = json['ios_url'];
    androidUrl = json['android_url'];
    iosVersion = json['ios_version'];
    androidVersion = json['android_version'];
    iosForceUpdate = json['ios_force_update'];
    androidForceUpdate = json['android_force_update'];
  }
}
