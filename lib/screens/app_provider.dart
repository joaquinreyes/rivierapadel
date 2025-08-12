import 'package:acepadel/models/club_locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseCrashlytics crashlytics(Ref ref) {
  return FirebaseCrashlytics.instance;
}

@riverpod
PageController pageController(Ref ref) {
  return PageController(
      initialPage: ref.read(pageIndexProvider.notifier).index);
}

@Riverpod(keepAlive: true)
class PageIndex extends _$PageIndex {
  @override
  int build() {
    // initial value de type int
    return 1;
  }

  set index(int index) {
    state = index;
  }

  int get index => state;
}

@Riverpod(keepAlive: true)
class SelectedSport extends _$SelectedSport {
  @override
  ClubLocationSports? build() {
    return null;
  }

  set sport(ClubLocationSports? sport) {
    state = sport;
  }

  ClubLocationSports? get sport => state;

  String get name => state?.sportName ?? "";
}

@Riverpod(keepAlive: true)
class SelectedSportLesson extends _$SelectedSportLesson {
  @override
  ClubLocationSports? build() {
    return null;
  }

  set sport(ClubLocationSports? sport) {
    state = sport;
  }

  ClubLocationSports? get sport => state;

  String get name => state?.sportName ?? "";
}
