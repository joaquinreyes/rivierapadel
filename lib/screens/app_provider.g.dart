// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$crashlyticsHash() => r'89f582b17599547f29e9c5587eb027fd25d7540f';

/// See also [crashlytics].
@ProviderFor(crashlytics)
final crashlyticsProvider = Provider<FirebaseCrashlytics>.internal(
  crashlytics,
  name: r'crashlyticsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$crashlyticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrashlyticsRef = ProviderRef<FirebaseCrashlytics>;
String _$pageControllerHash() => r'70956ab89652fc2f04e7208d78af4e30b77cda31';

/// See also [pageController].
@ProviderFor(pageController)
final pageControllerProvider = AutoDisposeProvider<PageController>.internal(
  pageController,
  name: r'pageControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pageControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PageControllerRef = AutoDisposeProviderRef<PageController>;
String _$pageIndexHash() => r'a03781324adfd37f4dd0417f78c1097140c6e36c';

/// See also [PageIndex].
@ProviderFor(PageIndex)
final pageIndexProvider = NotifierProvider<PageIndex, int>.internal(
  PageIndex.new,
  name: r'pageIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pageIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PageIndex = Notifier<int>;
String _$selectedSportHash() => r'b659e11d98098f56918756a00b02899c70feea22';

/// See also [SelectedSport].
@ProviderFor(SelectedSport)
final selectedSportProvider =
    NotifierProvider<SelectedSport, ClubLocationSports?>.internal(
  SelectedSport.new,
  name: r'selectedSportProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSportHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSport = Notifier<ClubLocationSports?>;
String _$selectedSportLessonHash() =>
    r'97acc32099e8d804f17eff0e222b63ad32a2bc1b';

/// See also [SelectedSportLesson].
@ProviderFor(SelectedSportLesson)
final selectedSportLessonProvider =
    NotifierProvider<SelectedSportLesson, ClubLocationSports?>.internal(
  SelectedSportLesson.new,
  name: r'selectedSportLessonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSportLessonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSportLesson = Notifier<ClubLocationSports?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
