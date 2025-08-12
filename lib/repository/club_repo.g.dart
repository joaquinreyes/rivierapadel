// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubRepoHash() => r'135ddaadfa3cfc55a766302c5e4c7e8fd3bf4d5f';

/// See also [clubRepo].
@ProviderFor(clubRepo)
final clubRepoProvider = AutoDisposeProvider<CourtRepo>.internal(
  clubRepo,
  name: r'clubRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clubRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClubRepoRef = AutoDisposeProviderRef<CourtRepo>;
String _$clubLocationsHash() => r'c969b935efa64bc175bf663731134be83d27f411';

/// See also [clubLocations].
@ProviderFor(clubLocations)
final clubLocationsProvider = FutureProvider<List<ClubLocationData>?>.internal(
  clubLocations,
  name: r'clubLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clubLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClubLocationsRef = FutureProviderRef<List<ClubLocationData>?>;
String _$getCourtBookingHash() => r'd8bceb225ca3fa4f7c529f03f51ff52e3b0bdbdb';

/// See also [getCourtBooking].
@ProviderFor(getCourtBooking)
final getCourtBookingProvider = FutureProvider<CourtBookingData?>.internal(
  getCourtBooking,
  name: r'getCourtBookingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCourtBookingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCourtBookingRef = FutureProviderRef<CourtBookingData?>;
String _$getVouchersApiHash() => r'14fd734759573a40d7c5eb7501478aeafd99cb86';

/// See also [getVouchersApi].
@ProviderFor(getVouchersApi)
final getVouchersApiProvider = FutureProvider<List<VoucherModel>>.internal(
  getVouchersApi,
  name: r'getVouchersApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getVouchersApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetVouchersApiRef = FutureProviderRef<List<VoucherModel>>;
String _$checkUpdateHash() => r'77cfa3a2fab1c4a931cb6c5a9b266f2de5439945';

/// See also [checkUpdate].
@ProviderFor(checkUpdate)
final checkUpdateProvider = AutoDisposeFutureProvider<AppUpdateModel?>.internal(
  checkUpdate,
  name: r'checkUpdateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$checkUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckUpdateRef = AutoDisposeFutureProviderRef<AppUpdateModel?>;
String _$selectedDateHash() => r'9c9b25e83b91321a82f2c350cabe9f67eaf4912b';

/// See also [SelectedDate].
@ProviderFor(SelectedDate)
final selectedDateProvider =
    NotifierProvider<SelectedDate, DubaiDateTime>.internal(
  SelectedDate.new,
  name: r'selectedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDate = Notifier<DubaiDateTime>;
String _$selectedDateLessonHash() =>
    r'1ee726bea866475f17abcff2825c9088a7bbaffe';

/// See also [SelectedDateLesson].
@ProviderFor(SelectedDateLesson)
final selectedDateLessonProvider =
    NotifierProvider<SelectedDateLesson, DubaiDateTime>.internal(
  SelectedDateLesson.new,
  name: r'selectedDateLessonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDateLessonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDateLesson = Notifier<DubaiDateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
