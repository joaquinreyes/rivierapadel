// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepoHash() => r'247f998882c3accb492988e04b8a179afe6a0184';

/// See also [bookingRepo].
@ProviderFor(bookingRepo)
final bookingRepoProvider = AutoDisposeProvider<BookingRepo>.internal(
  bookingRepo,
  name: r'bookingRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookingRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookingRepoRef = AutoDisposeProviderRef<BookingRepo>;
String _$bookCourtHash() => r'0c61765910d3df65de3389a8f61937249d1c0e47';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [bookCourt].
@ProviderFor(bookCourt)
const bookCourtProvider = BookCourtFamily();

/// See also [bookCourt].
class BookCourtFamily extends Family<AsyncValue<double?>> {
  /// See also [bookCourt].
  const BookCourtFamily();

  /// See also [bookCourt].
  BookCourtProvider call({
    required Bookings booking,
    required int courtID,
    required DateTime dateTime,
    required bool isOpenMatch,
    required int reservedPlayers,
    required BookingRequestType requestType,
    String? organizerNote,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) {
    return BookCourtProvider(
      booking: booking,
      courtID: courtID,
      dateTime: dateTime,
      isOpenMatch: isOpenMatch,
      reservedPlayers: reservedPlayers,
      requestType: requestType,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
    );
  }

  @override
  BookCourtProvider getProviderOverride(
    covariant BookCourtProvider provider,
  ) {
    return call(
      booking: provider.booking,
      courtID: provider.courtID,
      dateTime: provider.dateTime,
      isOpenMatch: provider.isOpenMatch,
      reservedPlayers: provider.reservedPlayers,
      requestType: provider.requestType,
      organizerNote: provider.organizerNote,
      isFriendlyMatch: provider.isFriendlyMatch,
      openMatchMinLevel: provider.openMatchMinLevel,
      openMatchMaxLevel: provider.openMatchMaxLevel,
      approvalNeeded: provider.approvalNeeded,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookCourtProvider';
}

/// See also [bookCourt].
class BookCourtProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [bookCourt].
  BookCourtProvider({
    required Bookings booking,
    required int courtID,
    required DateTime dateTime,
    required bool isOpenMatch,
    required int reservedPlayers,
    required BookingRequestType requestType,
    String? organizerNote,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) : this._internal(
          (ref) => bookCourt(
            ref as BookCourtRef,
            booking: booking,
            courtID: courtID,
            dateTime: dateTime,
            isOpenMatch: isOpenMatch,
            reservedPlayers: reservedPlayers,
            requestType: requestType,
            organizerNote: organizerNote,
            isFriendlyMatch: isFriendlyMatch,
            openMatchMinLevel: openMatchMinLevel,
            openMatchMaxLevel: openMatchMaxLevel,
            approvalNeeded: approvalNeeded,
          ),
          from: bookCourtProvider,
          name: r'bookCourtProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookCourtHash,
          dependencies: BookCourtFamily._dependencies,
          allTransitiveDependencies: BookCourtFamily._allTransitiveDependencies,
          booking: booking,
          courtID: courtID,
          dateTime: dateTime,
          isOpenMatch: isOpenMatch,
          reservedPlayers: reservedPlayers,
          requestType: requestType,
          organizerNote: organizerNote,
          isFriendlyMatch: isFriendlyMatch,
          openMatchMinLevel: openMatchMinLevel,
          openMatchMaxLevel: openMatchMaxLevel,
          approvalNeeded: approvalNeeded,
        );

  BookCourtProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.booking,
    required this.courtID,
    required this.dateTime,
    required this.isOpenMatch,
    required this.reservedPlayers,
    required this.requestType,
    required this.organizerNote,
    required this.isFriendlyMatch,
    required this.openMatchMinLevel,
    required this.openMatchMaxLevel,
    required this.approvalNeeded,
  }) : super.internal();

  final Bookings booking;
  final int courtID;
  final DateTime dateTime;
  final bool isOpenMatch;
  final int reservedPlayers;
  final BookingRequestType requestType;
  final String? organizerNote;
  final bool? isFriendlyMatch;
  final double? openMatchMinLevel;
  final double? openMatchMaxLevel;
  final bool? approvalNeeded;

  @override
  Override overrideWith(
    FutureOr<double?> Function(BookCourtRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookCourtProvider._internal(
        (ref) => create(ref as BookCourtRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        booking: booking,
        courtID: courtID,
        dateTime: dateTime,
        isOpenMatch: isOpenMatch,
        reservedPlayers: reservedPlayers,
        requestType: requestType,
        organizerNote: organizerNote,
        isFriendlyMatch: isFriendlyMatch,
        openMatchMinLevel: openMatchMinLevel,
        openMatchMaxLevel: openMatchMaxLevel,
        approvalNeeded: approvalNeeded,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _BookCourtProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookCourtProvider &&
        other.booking == booking &&
        other.courtID == courtID &&
        other.dateTime == dateTime &&
        other.isOpenMatch == isOpenMatch &&
        other.reservedPlayers == reservedPlayers &&
        other.requestType == requestType &&
        other.organizerNote == organizerNote &&
        other.isFriendlyMatch == isFriendlyMatch &&
        other.openMatchMinLevel == openMatchMinLevel &&
        other.openMatchMaxLevel == openMatchMaxLevel &&
        other.approvalNeeded == approvalNeeded;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, booking.hashCode);
    hash = _SystemHash.combine(hash, courtID.hashCode);
    hash = _SystemHash.combine(hash, dateTime.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, reservedPlayers.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, organizerNote.hashCode);
    hash = _SystemHash.combine(hash, isFriendlyMatch.hashCode);
    hash = _SystemHash.combine(hash, openMatchMinLevel.hashCode);
    hash = _SystemHash.combine(hash, openMatchMaxLevel.hashCode);
    hash = _SystemHash.combine(hash, approvalNeeded.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookCourtRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `booking` of this provider.
  Bookings get booking;

  /// The parameter `courtID` of this provider.
  int get courtID;

  /// The parameter `dateTime` of this provider.
  DateTime get dateTime;

  /// The parameter `isOpenMatch` of this provider.
  bool get isOpenMatch;

  /// The parameter `reservedPlayers` of this provider.
  int get reservedPlayers;

  /// The parameter `requestType` of this provider.
  BookingRequestType get requestType;

  /// The parameter `organizerNote` of this provider.
  String? get organizerNote;

  /// The parameter `isFriendlyMatch` of this provider.
  bool? get isFriendlyMatch;

  /// The parameter `openMatchMinLevel` of this provider.
  double? get openMatchMinLevel;

  /// The parameter `openMatchMaxLevel` of this provider.
  double? get openMatchMaxLevel;

  /// The parameter `approvalNeeded` of this provider.
  bool? get approvalNeeded;
}

class _BookCourtProviderElement
    extends AutoDisposeFutureProviderElement<double?> with BookCourtRef {
  _BookCourtProviderElement(super.provider);

  @override
  Bookings get booking => (origin as BookCourtProvider).booking;
  @override
  int get courtID => (origin as BookCourtProvider).courtID;
  @override
  DateTime get dateTime => (origin as BookCourtProvider).dateTime;
  @override
  bool get isOpenMatch => (origin as BookCourtProvider).isOpenMatch;
  @override
  int get reservedPlayers => (origin as BookCourtProvider).reservedPlayers;
  @override
  BookingRequestType get requestType =>
      (origin as BookCourtProvider).requestType;
  @override
  String? get organizerNote => (origin as BookCourtProvider).organizerNote;
  @override
  bool? get isFriendlyMatch => (origin as BookCourtProvider).isFriendlyMatch;
  @override
  double? get openMatchMinLevel =>
      (origin as BookCourtProvider).openMatchMinLevel;
  @override
  double? get openMatchMaxLevel =>
      (origin as BookCourtProvider).openMatchMaxLevel;
  @override
  bool? get approvalNeeded => (origin as BookCourtProvider).approvalNeeded;
}

String _$fetchCourtPriceHash() => r'031a11fb364c82ad7a01c92cfa5c8c027d9ef726';

/// See also [fetchCourtPrice].
@ProviderFor(fetchCourtPrice)
const fetchCourtPriceProvider = FetchCourtPriceFamily();

/// See also [fetchCourtPrice].
class FetchCourtPriceFamily extends Family<AsyncValue<dynamic>> {
  /// See also [fetchCourtPrice].
  const FetchCourtPriceFamily();

  /// See also [fetchCourtPrice].
  FetchCourtPriceProvider call({
    required int serviceId,
    required CourtPriceRequestType requestType,
    required DateTime dateTime,
    required List<dynamic> courtId,
    bool? isOpenMatch,
    required int? coachId,
    int? reserveCounter,
    LessonVariants? lessonVariant,
    required int durationInMin,
  }) {
    return FetchCourtPriceProvider(
      serviceId: serviceId,
      requestType: requestType,
      dateTime: dateTime,
      courtId: courtId,
      isOpenMatch: isOpenMatch,
      coachId: coachId,
      reserveCounter: reserveCounter,
      lessonVariant: lessonVariant,
      durationInMin: durationInMin,
    );
  }

  @override
  FetchCourtPriceProvider getProviderOverride(
    covariant FetchCourtPriceProvider provider,
  ) {
    return call(
      serviceId: provider.serviceId,
      requestType: provider.requestType,
      dateTime: provider.dateTime,
      courtId: provider.courtId,
      isOpenMatch: provider.isOpenMatch,
      coachId: provider.coachId,
      reserveCounter: provider.reserveCounter,
      lessonVariant: provider.lessonVariant,
      durationInMin: provider.durationInMin,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchCourtPriceProvider';
}

/// See also [fetchCourtPrice].
class FetchCourtPriceProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [fetchCourtPrice].
  FetchCourtPriceProvider({
    required int serviceId,
    required CourtPriceRequestType requestType,
    required DateTime dateTime,
    required List<dynamic> courtId,
    bool? isOpenMatch,
    required int? coachId,
    int? reserveCounter,
    LessonVariants? lessonVariant,
    required int durationInMin,
  }) : this._internal(
          (ref) => fetchCourtPrice(
            ref as FetchCourtPriceRef,
            serviceId: serviceId,
            requestType: requestType,
            dateTime: dateTime,
            courtId: courtId,
            isOpenMatch: isOpenMatch,
            coachId: coachId,
            reserveCounter: reserveCounter,
            lessonVariant: lessonVariant,
            durationInMin: durationInMin,
          ),
          from: fetchCourtPriceProvider,
          name: r'fetchCourtPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchCourtPriceHash,
          dependencies: FetchCourtPriceFamily._dependencies,
          allTransitiveDependencies:
              FetchCourtPriceFamily._allTransitiveDependencies,
          serviceId: serviceId,
          requestType: requestType,
          dateTime: dateTime,
          courtId: courtId,
          isOpenMatch: isOpenMatch,
          coachId: coachId,
          reserveCounter: reserveCounter,
          lessonVariant: lessonVariant,
          durationInMin: durationInMin,
        );

  FetchCourtPriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
    required this.requestType,
    required this.dateTime,
    required this.courtId,
    required this.isOpenMatch,
    required this.coachId,
    required this.reserveCounter,
    required this.lessonVariant,
    required this.durationInMin,
  }) : super.internal();

  final int serviceId;
  final CourtPriceRequestType requestType;
  final DateTime dateTime;
  final List<dynamic> courtId;
  final bool? isOpenMatch;
  final int? coachId;
  final int? reserveCounter;
  final LessonVariants? lessonVariant;
  final int durationInMin;

  @override
  Override overrideWith(
    FutureOr<dynamic> Function(FetchCourtPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchCourtPriceProvider._internal(
        (ref) => create(ref as FetchCourtPriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
        requestType: requestType,
        dateTime: dateTime,
        courtId: courtId,
        isOpenMatch: isOpenMatch,
        coachId: coachId,
        reserveCounter: reserveCounter,
        lessonVariant: lessonVariant,
        durationInMin: durationInMin,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<dynamic> createElement() {
    return _FetchCourtPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCourtPriceProvider &&
        other.serviceId == serviceId &&
        other.requestType == requestType &&
        other.dateTime == dateTime &&
        other.courtId == courtId &&
        other.isOpenMatch == isOpenMatch &&
        other.coachId == coachId &&
        other.reserveCounter == reserveCounter &&
        other.lessonVariant == lessonVariant &&
        other.durationInMin == durationInMin;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, dateTime.hashCode);
    hash = _SystemHash.combine(hash, courtId.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, coachId.hashCode);
    hash = _SystemHash.combine(hash, reserveCounter.hashCode);
    hash = _SystemHash.combine(hash, lessonVariant.hashCode);
    hash = _SystemHash.combine(hash, durationInMin.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchCourtPriceRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `serviceId` of this provider.
  int get serviceId;

  /// The parameter `requestType` of this provider.
  CourtPriceRequestType get requestType;

  /// The parameter `dateTime` of this provider.
  DateTime get dateTime;

  /// The parameter `courtId` of this provider.
  List<dynamic> get courtId;

  /// The parameter `isOpenMatch` of this provider.
  bool? get isOpenMatch;

  /// The parameter `coachId` of this provider.
  int? get coachId;

  /// The parameter `reserveCounter` of this provider.
  int? get reserveCounter;

  /// The parameter `lessonVariant` of this provider.
  LessonVariants? get lessonVariant;

  /// The parameter `durationInMin` of this provider.
  int get durationInMin;
}

class _FetchCourtPriceProviderElement
    extends AutoDisposeFutureProviderElement<dynamic> with FetchCourtPriceRef {
  _FetchCourtPriceProviderElement(super.provider);

  @override
  int get serviceId => (origin as FetchCourtPriceProvider).serviceId;
  @override
  CourtPriceRequestType get requestType =>
      (origin as FetchCourtPriceProvider).requestType;
  @override
  DateTime get dateTime => (origin as FetchCourtPriceProvider).dateTime;
  @override
  List<dynamic> get courtId => (origin as FetchCourtPriceProvider).courtId;
  @override
  bool? get isOpenMatch => (origin as FetchCourtPriceProvider).isOpenMatch;
  @override
  int? get coachId => (origin as FetchCourtPriceProvider).coachId;
  @override
  int? get reserveCounter => (origin as FetchCourtPriceProvider).reserveCounter;
  @override
  LessonVariants? get lessonVariant =>
      (origin as FetchCourtPriceProvider).lessonVariant;
  @override
  int get durationInMin => (origin as FetchCourtPriceProvider).durationInMin;
}

String _$fetchUserBookingHash() => r'b0a69cce66a73843c33103d839f8f608885b630e';

/// See also [fetchUserBooking].
@ProviderFor(fetchUserBooking)
final fetchUserBookingProvider =
    AutoDisposeFutureProvider<List<UserBookings>>.internal(
  fetchUserBooking,
  name: r'fetchUserBookingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserBookingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchUserBookingRef = AutoDisposeFutureProviderRef<List<UserBookings>>;
String _$fetchUserBookingWaitingListHash() =>
    r'43d18a355c2fb71b457cc3c91f56a6b7de188193';

/// See also [fetchUserBookingWaitingList].
@ProviderFor(fetchUserBookingWaitingList)
final fetchUserBookingWaitingListProvider =
    AutoDisposeFutureProvider<List<UserBookings>>.internal(
  fetchUserBookingWaitingList,
  name: r'fetchUserBookingWaitingListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserBookingWaitingListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchUserBookingWaitingListRef
    = AutoDisposeFutureProviderRef<List<UserBookings>>;
String _$fetchUserAllBookingsHash() =>
    r'389fa06b4091f95baecba70aef5aed4de4230ebb';

/// See also [fetchUserAllBookings].
@ProviderFor(fetchUserAllBookings)
final fetchUserAllBookingsProvider =
    AutoDisposeFutureProvider<List<UserBookings>>.internal(
  fetchUserAllBookings,
  name: r'fetchUserAllBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserAllBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchUserAllBookingsRef
    = AutoDisposeFutureProviderRef<List<UserBookings>>;
String _$fetchServiceIDWithTransactionIDHash() =>
    r'bb5e1ac53cc12eb64db063190878fdc44927af10';

/// See also [fetchServiceIDWithTransactionID].
@ProviderFor(fetchServiceIDWithTransactionID)
const fetchServiceIDWithTransactionIDProvider =
    FetchServiceIDWithTransactionIDFamily();

/// See also [fetchServiceIDWithTransactionID].
class FetchServiceIDWithTransactionIDFamily extends Family<AsyncValue<int>> {
  /// See also [fetchServiceIDWithTransactionID].
  const FetchServiceIDWithTransactionIDFamily();

  /// See also [fetchServiceIDWithTransactionID].
  FetchServiceIDWithTransactionIDProvider call({
    required String orderID,
    required String statusCode,
    required TransactionRequestType requestType,
    required String transactionStatus,
  }) {
    return FetchServiceIDWithTransactionIDProvider(
      orderID: orderID,
      statusCode: statusCode,
      requestType: requestType,
      transactionStatus: transactionStatus,
    );
  }

  @override
  FetchServiceIDWithTransactionIDProvider getProviderOverride(
    covariant FetchServiceIDWithTransactionIDProvider provider,
  ) {
    return call(
      orderID: provider.orderID,
      statusCode: provider.statusCode,
      requestType: provider.requestType,
      transactionStatus: provider.transactionStatus,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchServiceIDWithTransactionIDProvider';
}

/// See also [fetchServiceIDWithTransactionID].
class FetchServiceIDWithTransactionIDProvider
    extends AutoDisposeFutureProvider<int> {
  /// See also [fetchServiceIDWithTransactionID].
  FetchServiceIDWithTransactionIDProvider({
    required String orderID,
    required String statusCode,
    required TransactionRequestType requestType,
    required String transactionStatus,
  }) : this._internal(
          (ref) => fetchServiceIDWithTransactionID(
            ref as FetchServiceIDWithTransactionIDRef,
            orderID: orderID,
            statusCode: statusCode,
            requestType: requestType,
            transactionStatus: transactionStatus,
          ),
          from: fetchServiceIDWithTransactionIDProvider,
          name: r'fetchServiceIDWithTransactionIDProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchServiceIDWithTransactionIDHash,
          dependencies: FetchServiceIDWithTransactionIDFamily._dependencies,
          allTransitiveDependencies:
              FetchServiceIDWithTransactionIDFamily._allTransitiveDependencies,
          orderID: orderID,
          statusCode: statusCode,
          requestType: requestType,
          transactionStatus: transactionStatus,
        );

  FetchServiceIDWithTransactionIDProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderID,
    required this.statusCode,
    required this.requestType,
    required this.transactionStatus,
  }) : super.internal();

  final String orderID;
  final String statusCode;
  final TransactionRequestType requestType;
  final String transactionStatus;

  @override
  Override overrideWith(
    FutureOr<int> Function(FetchServiceIDWithTransactionIDRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchServiceIDWithTransactionIDProvider._internal(
        (ref) => create(ref as FetchServiceIDWithTransactionIDRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderID: orderID,
        statusCode: statusCode,
        requestType: requestType,
        transactionStatus: transactionStatus,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _FetchServiceIDWithTransactionIDProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchServiceIDWithTransactionIDProvider &&
        other.orderID == orderID &&
        other.statusCode == statusCode &&
        other.requestType == requestType &&
        other.transactionStatus == transactionStatus;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderID.hashCode);
    hash = _SystemHash.combine(hash, statusCode.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, transactionStatus.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchServiceIDWithTransactionIDRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `orderID` of this provider.
  String get orderID;

  /// The parameter `statusCode` of this provider.
  String get statusCode;

  /// The parameter `requestType` of this provider.
  TransactionRequestType get requestType;

  /// The parameter `transactionStatus` of this provider.
  String get transactionStatus;
}

class _FetchServiceIDWithTransactionIDProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with FetchServiceIDWithTransactionIDRef {
  _FetchServiceIDWithTransactionIDProviderElement(super.provider);

  @override
  String get orderID =>
      (origin as FetchServiceIDWithTransactionIDProvider).orderID;
  @override
  String get statusCode =>
      (origin as FetchServiceIDWithTransactionIDProvider).statusCode;
  @override
  TransactionRequestType get requestType =>
      (origin as FetchServiceIDWithTransactionIDProvider).requestType;
  @override
  String get transactionStatus =>
      (origin as FetchServiceIDWithTransactionIDProvider).transactionStatus;
}

String _$playedHoursHash() => r'df11c5727413f776a9d1e1c0c6acdb74300edfee';

/// See also [playedHours].
@ProviderFor(playedHours)
final playedHoursProvider = AutoDisposeFutureProvider<TotalHours>.internal(
  playedHours,
  name: r'playedHoursProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playedHoursHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlayedHoursRef = AutoDisposeFutureProviderRef<TotalHours>;
String _$activeMembershipHash() => r'ee8ccc1ba16514605ab88600feb077b13b8fbc9a';

/// See also [activeMembership].
@ProviderFor(activeMembership)
final activeMembershipProvider =
    AutoDisposeFutureProvider<List<ActiveMemberships>>.internal(
  activeMembership,
  name: r'activeMembershipProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeMembershipHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveMembershipRef
    = AutoDisposeFutureProviderRef<List<ActiveMemberships>>;
String _$addToCalendarHash() => r'64a254810c4801ab505e0babb496fd935dc108dc';

/// See also [addToCalendar].
@ProviderFor(addToCalendar)
const addToCalendarProvider = AddToCalendarFamily();

/// See also [addToCalendar].
class AddToCalendarFamily extends Family<AsyncValue<bool>> {
  /// See also [addToCalendar].
  const AddToCalendarFamily();

  /// See also [addToCalendar].
  AddToCalendarProvider call({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return AddToCalendarProvider(
      title: title,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  AddToCalendarProvider getProviderOverride(
    covariant AddToCalendarProvider provider,
  ) {
    return call(
      title: provider.title,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addToCalendarProvider';
}

/// See also [addToCalendar].
class AddToCalendarProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [addToCalendar].
  AddToCalendarProvider({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => addToCalendar(
            ref as AddToCalendarRef,
            title: title,
            startDate: startDate,
            endDate: endDate,
          ),
          from: addToCalendarProvider,
          name: r'addToCalendarProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addToCalendarHash,
          dependencies: AddToCalendarFamily._dependencies,
          allTransitiveDependencies:
              AddToCalendarFamily._allTransitiveDependencies,
          title: title,
          startDate: startDate,
          endDate: endDate,
        );

  AddToCalendarProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String title;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<bool> Function(AddToCalendarRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddToCalendarProvider._internal(
        (ref) => create(ref as AddToCalendarRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _AddToCalendarProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddToCalendarProvider &&
        other.title == title &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddToCalendarRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _AddToCalendarProviderElement
    extends AutoDisposeFutureProviderElement<bool> with AddToCalendarRef {
  _AddToCalendarProviderElement(super.provider);

  @override
  String get title => (origin as AddToCalendarProvider).title;
  @override
  DateTime get startDate => (origin as AddToCalendarProvider).startDate;
  @override
  DateTime get endDate => (origin as AddToCalendarProvider).endDate;
}

String _$fetchBookingCartListHash() =>
    r'bb1ab4b33c6c609151cabdd566d9023a343018b6';

/// See also [fetchBookingCartList].
@ProviderFor(fetchBookingCartList)
final fetchBookingCartListProvider =
    AutoDisposeFutureProvider<List<MultipleBookings>>.internal(
  fetchBookingCartList,
  name: r'fetchBookingCartListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchBookingCartListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchBookingCartListRef
    = AutoDisposeFutureProviderRef<List<MultipleBookings>>;
String _$deleteCartHash() => r'270f5242597dce0c128f744b8e6be5f53d636b46';

/// See also [deleteCart].
@ProviderFor(deleteCart)
const deleteCartProvider = DeleteCartFamily();

/// See also [deleteCart].
class DeleteCartFamily extends Family<AsyncValue<bool>> {
  /// See also [deleteCart].
  const DeleteCartFamily();

  /// See also [deleteCart].
  DeleteCartProvider call(
    String bookingId,
  ) {
    return DeleteCartProvider(
      bookingId,
    );
  }

  @override
  DeleteCartProvider getProviderOverride(
    covariant DeleteCartProvider provider,
  ) {
    return call(
      provider.bookingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteCartProvider';
}

/// See also [deleteCart].
class DeleteCartProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteCart].
  DeleteCartProvider(
    String bookingId,
  ) : this._internal(
          (ref) => deleteCart(
            ref as DeleteCartRef,
            bookingId,
          ),
          from: deleteCartProvider,
          name: r'deleteCartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteCartHash,
          dependencies: DeleteCartFamily._dependencies,
          allTransitiveDependencies:
              DeleteCartFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  DeleteCartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteCartRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteCartProvider._internal(
        (ref) => create(ref as DeleteCartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteCartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteCartProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteCartRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _DeleteCartProviderElement extends AutoDisposeFutureProviderElement<bool>
    with DeleteCartRef {
  _DeleteCartProviderElement(super.provider);

  @override
  String get bookingId => (origin as DeleteCartProvider).bookingId;
}

String _$fetchChatCountHash() => r'b322e51f3a27c4575af69af38ba3c62353795d05';

/// See also [fetchChatCount].
@ProviderFor(fetchChatCount)
const fetchChatCountProvider = FetchChatCountFamily();

/// See also [fetchChatCount].
class FetchChatCountFamily extends Family<AsyncValue<double?>> {
  /// See also [fetchChatCount].
  const FetchChatCountFamily();

  /// See also [fetchChatCount].
  FetchChatCountProvider call({
    required int matchId,
  }) {
    return FetchChatCountProvider(
      matchId: matchId,
    );
  }

  @override
  FetchChatCountProvider getProviderOverride(
    covariant FetchChatCountProvider provider,
  ) {
    return call(
      matchId: provider.matchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchChatCountProvider';
}

/// See also [fetchChatCount].
class FetchChatCountProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [fetchChatCount].
  FetchChatCountProvider({
    required int matchId,
  }) : this._internal(
          (ref) => fetchChatCount(
            ref as FetchChatCountRef,
            matchId: matchId,
          ),
          from: fetchChatCountProvider,
          name: r'fetchChatCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchChatCountHash,
          dependencies: FetchChatCountFamily._dependencies,
          allTransitiveDependencies:
              FetchChatCountFamily._allTransitiveDependencies,
          matchId: matchId,
        );

  FetchChatCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.matchId,
  }) : super.internal();

  final int matchId;

  @override
  Override overrideWith(
    FutureOr<double?> Function(FetchChatCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchChatCountProvider._internal(
        (ref) => create(ref as FetchChatCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        matchId: matchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _FetchChatCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchChatCountProvider && other.matchId == matchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, matchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchChatCountRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `matchId` of this provider.
  int get matchId;
}

class _FetchChatCountProviderElement
    extends AutoDisposeFutureProviderElement<double?> with FetchChatCountRef {
  _FetchChatCountProviderElement(super.provider);

  @override
  int get matchId => (origin as FetchChatCountProvider).matchId;
}

String _$bookLessonCourtHash() => r'2c5754ed5f3fba4f7166c87d979279df73036d7d';

/// See also [bookLessonCourt].
@ProviderFor(bookLessonCourt)
const bookLessonCourtProvider = BookLessonCourtFamily();

/// See also [bookLessonCourt].
class BookLessonCourtFamily extends Family<AsyncValue<void>> {
  /// See also [bookLessonCourt].
  const BookLessonCourtFamily();

  /// See also [bookLessonCourt].
  BookLessonCourtProvider call({
    required int lessonTime,
    required int courtId,
    required int lessonId,
    required int coachId,
    required int locationId,
    required DateTime dateTime,
    required LessonVariants? lessonVariant,
  }) {
    return BookLessonCourtProvider(
      lessonTime: lessonTime,
      courtId: courtId,
      lessonId: lessonId,
      coachId: coachId,
      locationId: locationId,
      dateTime: dateTime,
      lessonVariant: lessonVariant,
    );
  }

  @override
  BookLessonCourtProvider getProviderOverride(
    covariant BookLessonCourtProvider provider,
  ) {
    return call(
      lessonTime: provider.lessonTime,
      courtId: provider.courtId,
      lessonId: provider.lessonId,
      coachId: provider.coachId,
      locationId: provider.locationId,
      dateTime: provider.dateTime,
      lessonVariant: provider.lessonVariant,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookLessonCourtProvider';
}

/// See also [bookLessonCourt].
class BookLessonCourtProvider extends AutoDisposeFutureProvider<void> {
  /// See also [bookLessonCourt].
  BookLessonCourtProvider({
    required int lessonTime,
    required int courtId,
    required int lessonId,
    required int coachId,
    required int locationId,
    required DateTime dateTime,
    required LessonVariants? lessonVariant,
  }) : this._internal(
          (ref) => bookLessonCourt(
            ref as BookLessonCourtRef,
            lessonTime: lessonTime,
            courtId: courtId,
            lessonId: lessonId,
            coachId: coachId,
            locationId: locationId,
            dateTime: dateTime,
            lessonVariant: lessonVariant,
          ),
          from: bookLessonCourtProvider,
          name: r'bookLessonCourtProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookLessonCourtHash,
          dependencies: BookLessonCourtFamily._dependencies,
          allTransitiveDependencies:
              BookLessonCourtFamily._allTransitiveDependencies,
          lessonTime: lessonTime,
          courtId: courtId,
          lessonId: lessonId,
          coachId: coachId,
          locationId: locationId,
          dateTime: dateTime,
          lessonVariant: lessonVariant,
        );

  BookLessonCourtProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonTime,
    required this.courtId,
    required this.lessonId,
    required this.coachId,
    required this.locationId,
    required this.dateTime,
    required this.lessonVariant,
  }) : super.internal();

  final int lessonTime;
  final int courtId;
  final int lessonId;
  final int coachId;
  final int locationId;
  final DateTime dateTime;
  final LessonVariants? lessonVariant;

  @override
  Override overrideWith(
    FutureOr<void> Function(BookLessonCourtRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookLessonCourtProvider._internal(
        (ref) => create(ref as BookLessonCourtRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonTime: lessonTime,
        courtId: courtId,
        lessonId: lessonId,
        coachId: coachId,
        locationId: locationId,
        dateTime: dateTime,
        lessonVariant: lessonVariant,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _BookLessonCourtProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookLessonCourtProvider &&
        other.lessonTime == lessonTime &&
        other.courtId == courtId &&
        other.lessonId == lessonId &&
        other.coachId == coachId &&
        other.locationId == locationId &&
        other.dateTime == dateTime &&
        other.lessonVariant == lessonVariant;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonTime.hashCode);
    hash = _SystemHash.combine(hash, courtId.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);
    hash = _SystemHash.combine(hash, coachId.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);
    hash = _SystemHash.combine(hash, dateTime.hashCode);
    hash = _SystemHash.combine(hash, lessonVariant.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookLessonCourtRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `lessonTime` of this provider.
  int get lessonTime;

  /// The parameter `courtId` of this provider.
  int get courtId;

  /// The parameter `lessonId` of this provider.
  int get lessonId;

  /// The parameter `coachId` of this provider.
  int get coachId;

  /// The parameter `locationId` of this provider.
  int get locationId;

  /// The parameter `dateTime` of this provider.
  DateTime get dateTime;

  /// The parameter `lessonVariant` of this provider.
  LessonVariants? get lessonVariant;
}

class _BookLessonCourtProviderElement
    extends AutoDisposeFutureProviderElement<void> with BookLessonCourtRef {
  _BookLessonCourtProviderElement(super.provider);

  @override
  int get lessonTime => (origin as BookLessonCourtProvider).lessonTime;
  @override
  int get courtId => (origin as BookLessonCourtProvider).courtId;
  @override
  int get lessonId => (origin as BookLessonCourtProvider).lessonId;
  @override
  int get coachId => (origin as BookLessonCourtProvider).coachId;
  @override
  int get locationId => (origin as BookLessonCourtProvider).locationId;
  @override
  DateTime get dateTime => (origin as BookLessonCourtProvider).dateTime;
  @override
  LessonVariants? get lessonVariant =>
      (origin as BookLessonCourtProvider).lessonVariant;
}

String _$upgradeBookingToOpenHash() =>
    r'327b25159113760b1093a21f14f3fb6d756f1d83';

/// See also [upgradeBookingToOpen].
@ProviderFor(upgradeBookingToOpen)
const upgradeBookingToOpenProvider = UpgradeBookingToOpenFamily();

/// See also [upgradeBookingToOpen].
class UpgradeBookingToOpenFamily extends Family<AsyncValue<double?>> {
  /// See also [upgradeBookingToOpen].
  const UpgradeBookingToOpenFamily();

  /// See also [upgradeBookingToOpen].
  UpgradeBookingToOpenProvider call({
    required Bookings booking,
    required int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) {
    return UpgradeBookingToOpenProvider(
      booking: booking,
      reservedPlayers: reservedPlayers,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
    );
  }

  @override
  UpgradeBookingToOpenProvider getProviderOverride(
    covariant UpgradeBookingToOpenProvider provider,
  ) {
    return call(
      booking: provider.booking,
      reservedPlayers: provider.reservedPlayers,
      organizerNote: provider.organizerNote,
      isFriendlyMatch: provider.isFriendlyMatch,
      openMatchMinLevel: provider.openMatchMinLevel,
      openMatchMaxLevel: provider.openMatchMaxLevel,
      approvalNeeded: provider.approvalNeeded,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'upgradeBookingToOpenProvider';
}

/// See also [upgradeBookingToOpen].
class UpgradeBookingToOpenProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [upgradeBookingToOpen].
  UpgradeBookingToOpenProvider({
    required Bookings booking,
    required int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) : this._internal(
          (ref) => upgradeBookingToOpen(
            ref as UpgradeBookingToOpenRef,
            booking: booking,
            reservedPlayers: reservedPlayers,
            organizerNote: organizerNote,
            isFriendlyMatch: isFriendlyMatch,
            openMatchMinLevel: openMatchMinLevel,
            openMatchMaxLevel: openMatchMaxLevel,
            approvalNeeded: approvalNeeded,
          ),
          from: upgradeBookingToOpenProvider,
          name: r'upgradeBookingToOpenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upgradeBookingToOpenHash,
          dependencies: UpgradeBookingToOpenFamily._dependencies,
          allTransitiveDependencies:
              UpgradeBookingToOpenFamily._allTransitiveDependencies,
          booking: booking,
          reservedPlayers: reservedPlayers,
          organizerNote: organizerNote,
          isFriendlyMatch: isFriendlyMatch,
          openMatchMinLevel: openMatchMinLevel,
          openMatchMaxLevel: openMatchMaxLevel,
          approvalNeeded: approvalNeeded,
        );

  UpgradeBookingToOpenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.booking,
    required this.reservedPlayers,
    required this.organizerNote,
    required this.isFriendlyMatch,
    required this.openMatchMinLevel,
    required this.openMatchMaxLevel,
    required this.approvalNeeded,
  }) : super.internal();

  final Bookings booking;
  final int reservedPlayers;
  final String? organizerNote;
  final bool? isFriendlyMatch;
  final double? openMatchMinLevel;
  final double? openMatchMaxLevel;
  final bool? approvalNeeded;

  @override
  Override overrideWith(
    FutureOr<double?> Function(UpgradeBookingToOpenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpgradeBookingToOpenProvider._internal(
        (ref) => create(ref as UpgradeBookingToOpenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        booking: booking,
        reservedPlayers: reservedPlayers,
        organizerNote: organizerNote,
        isFriendlyMatch: isFriendlyMatch,
        openMatchMinLevel: openMatchMinLevel,
        openMatchMaxLevel: openMatchMaxLevel,
        approvalNeeded: approvalNeeded,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _UpgradeBookingToOpenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpgradeBookingToOpenProvider &&
        other.booking == booking &&
        other.reservedPlayers == reservedPlayers &&
        other.organizerNote == organizerNote &&
        other.isFriendlyMatch == isFriendlyMatch &&
        other.openMatchMinLevel == openMatchMinLevel &&
        other.openMatchMaxLevel == openMatchMaxLevel &&
        other.approvalNeeded == approvalNeeded;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, booking.hashCode);
    hash = _SystemHash.combine(hash, reservedPlayers.hashCode);
    hash = _SystemHash.combine(hash, organizerNote.hashCode);
    hash = _SystemHash.combine(hash, isFriendlyMatch.hashCode);
    hash = _SystemHash.combine(hash, openMatchMinLevel.hashCode);
    hash = _SystemHash.combine(hash, openMatchMaxLevel.hashCode);
    hash = _SystemHash.combine(hash, approvalNeeded.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpgradeBookingToOpenRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `booking` of this provider.
  Bookings get booking;

  /// The parameter `reservedPlayers` of this provider.
  int get reservedPlayers;

  /// The parameter `organizerNote` of this provider.
  String? get organizerNote;

  /// The parameter `isFriendlyMatch` of this provider.
  bool? get isFriendlyMatch;

  /// The parameter `openMatchMinLevel` of this provider.
  double? get openMatchMinLevel;

  /// The parameter `openMatchMaxLevel` of this provider.
  double? get openMatchMaxLevel;

  /// The parameter `approvalNeeded` of this provider.
  bool? get approvalNeeded;
}

class _UpgradeBookingToOpenProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with UpgradeBookingToOpenRef {
  _UpgradeBookingToOpenProviderElement(super.provider);

  @override
  Bookings get booking => (origin as UpgradeBookingToOpenProvider).booking;
  @override
  int get reservedPlayers =>
      (origin as UpgradeBookingToOpenProvider).reservedPlayers;
  @override
  String? get organizerNote =>
      (origin as UpgradeBookingToOpenProvider).organizerNote;
  @override
  bool? get isFriendlyMatch =>
      (origin as UpgradeBookingToOpenProvider).isFriendlyMatch;
  @override
  double? get openMatchMinLevel =>
      (origin as UpgradeBookingToOpenProvider).openMatchMinLevel;
  @override
  double? get openMatchMaxLevel =>
      (origin as UpgradeBookingToOpenProvider).openMatchMaxLevel;
  @override
  bool? get approvalNeeded =>
      (origin as UpgradeBookingToOpenProvider).approvalNeeded;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
