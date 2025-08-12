import 'dart:convert';

import 'package:acepadel/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'shared_pref_manager.g.dart';

@Riverpod(keepAlive: true)
SharedPrefManager sharedPrefManager(SharedPrefManagerRef ref) {
  throw UnimplementedError();
}

class SharedPrefManager {
  static const String prefix = 'ace_padel';
  static const String userKey = "${prefix}_user";
  SharedPreferences prefs;
  SharedPrefManager(this.prefs);

  saveUser(AppUser user) async {
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  AppUser? fetchUser() {
    String? encodedString = prefs.getString(userKey);

    return encodedString != null
        ? AppUser.fromJson(jsonDecode(encodedString))
        : null;
  }

  clearUser() async {
    await prefs.remove(userKey);
  }
}
