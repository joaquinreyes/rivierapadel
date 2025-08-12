// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playRepoHash() => r'76b578b12e07c15077c1338a15980b902cefba90';

/// See also [playRepo].
@ProviderFor(playRepo)
final playRepoProvider = AutoDisposeProvider<PlayRepo>.internal(
  playRepo,
  name: r'playRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlayRepoRef = AutoDisposeProviderRef<PlayRepo>;
String _$openMatchesListHash() => r'cddda7f722d06e4be88a43b85a1867781355780f';

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

/// See also [openMatchesList].
@ProviderFor(openMatchesList)
const openMatchesListProvider = OpenMatchesListFamily();

/// See also [openMatchesList].
class OpenMatchesListFamily extends Family<AsyncValue<List<OpenMatchModel>>> {
  /// See also [openMatchesList].
  const OpenMatchesListFamily();

  /// See also [openMatchesList].
  OpenMatchesListProvider call({
    required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    required double minLevel,
    required double maxLevel,
  }) {
    return OpenMatchesListProvider(
      startDate: startDate,
      endDate: endDate,
      locationIDs: locationIDs,
      minLevel: minLevel,
      maxLevel: maxLevel,
    );
  }

  @override
  OpenMatchesListProvider getProviderOverride(
    covariant OpenMatchesListProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      locationIDs: provider.locationIDs,
      minLevel: provider.minLevel,
      maxLevel: provider.maxLevel,
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
  String? get name => r'openMatchesListProvider';
}

/// See also [openMatchesList].
class OpenMatchesListProvider
    extends AutoDisposeFutureProvider<List<OpenMatchModel>> {
  /// See also [openMatchesList].
  OpenMatchesListProvider({
    required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    required double minLevel,
    required double maxLevel,
  }) : this._internal(
          (ref) => openMatchesList(
            ref as OpenMatchesListRef,
            startDate: startDate,
            endDate: endDate,
            locationIDs: locationIDs,
            minLevel: minLevel,
            maxLevel: maxLevel,
          ),
          from: openMatchesListProvider,
          name: r'openMatchesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$openMatchesListHash,
          dependencies: OpenMatchesListFamily._dependencies,
          allTransitiveDependencies:
              OpenMatchesListFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          locationIDs: locationIDs,
          minLevel: minLevel,
          maxLevel: maxLevel,
        );

  OpenMatchesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.locationIDs,
    required this.minLevel,
    required this.maxLevel,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final List<int> locationIDs;
  final double minLevel;
  final double maxLevel;

  @override
  Override overrideWith(
    FutureOr<List<OpenMatchModel>> Function(OpenMatchesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenMatchesListProvider._internal(
        (ref) => create(ref as OpenMatchesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        locationIDs: locationIDs,
        minLevel: minLevel,
        maxLevel: maxLevel,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OpenMatchModel>> createElement() {
    return _OpenMatchesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenMatchesListProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.locationIDs == locationIDs &&
        other.minLevel == minLevel &&
        other.maxLevel == maxLevel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, locationIDs.hashCode);
    hash = _SystemHash.combine(hash, minLevel.hashCode);
    hash = _SystemHash.combine(hash, maxLevel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OpenMatchesListRef on AutoDisposeFutureProviderRef<List<OpenMatchModel>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `locationIDs` of this provider.
  List<int> get locationIDs;

  /// The parameter `minLevel` of this provider.
  double get minLevel;

  /// The parameter `maxLevel` of this provider.
  double get maxLevel;
}

class _OpenMatchesListProviderElement
    extends AutoDisposeFutureProviderElement<List<OpenMatchModel>>
    with OpenMatchesListRef {
  _OpenMatchesListProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as OpenMatchesListProvider).startDate;
  @override
  DateTime get endDate => (origin as OpenMatchesListProvider).endDate;
  @override
  List<int> get locationIDs => (origin as OpenMatchesListProvider).locationIDs;
  @override
  double get minLevel => (origin as OpenMatchesListProvider).minLevel;
  @override
  double get maxLevel => (origin as OpenMatchesListProvider).maxLevel;
}

String _$fetchAllCoachesHash() => r'259e738358908a42fa30143520c85b5de5964a99';

/// See also [fetchAllCoaches].
@ProviderFor(fetchAllCoaches)
final fetchAllCoachesProvider =
    AutoDisposeFutureProvider<List<CoachListModel>>.internal(
  fetchAllCoaches,
  name: r'fetchAllCoachesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAllCoachesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchAllCoachesRef = AutoDisposeFutureProviderRef<List<CoachListModel>>;
String _$eventsListHash() => r'2cdc1f33437493b2dd5c285c1af66980af255322';

/// See also [eventsList].
@ProviderFor(eventsList)
const eventsListProvider = EventsListFamily();

/// See also [eventsList].
class EventsListFamily extends Family<AsyncValue<List<EventsModel>>> {
  /// See also [eventsList].
  const EventsListFamily();

  /// See also [eventsList].
  EventsListProvider call({
    required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    required double minLevel,
    required double maxLevel,
  }) {
    return EventsListProvider(
      startDate: startDate,
      endDate: endDate,
      locationIDs: locationIDs,
      minLevel: minLevel,
      maxLevel: maxLevel,
    );
  }

  @override
  EventsListProvider getProviderOverride(
    covariant EventsListProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      locationIDs: provider.locationIDs,
      minLevel: provider.minLevel,
      maxLevel: provider.maxLevel,
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
  String? get name => r'eventsListProvider';
}

/// See also [eventsList].
class EventsListProvider extends AutoDisposeFutureProvider<List<EventsModel>> {
  /// See also [eventsList].
  EventsListProvider({
    required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    required double minLevel,
    required double maxLevel,
  }) : this._internal(
          (ref) => eventsList(
            ref as EventsListRef,
            startDate: startDate,
            endDate: endDate,
            locationIDs: locationIDs,
            minLevel: minLevel,
            maxLevel: maxLevel,
          ),
          from: eventsListProvider,
          name: r'eventsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventsListHash,
          dependencies: EventsListFamily._dependencies,
          allTransitiveDependencies:
              EventsListFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          locationIDs: locationIDs,
          minLevel: minLevel,
          maxLevel: maxLevel,
        );

  EventsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.locationIDs,
    required this.minLevel,
    required this.maxLevel,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final List<int> locationIDs;
  final double minLevel;
  final double maxLevel;

  @override
  Override overrideWith(
    FutureOr<List<EventsModel>> Function(EventsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventsListProvider._internal(
        (ref) => create(ref as EventsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        locationIDs: locationIDs,
        minLevel: minLevel,
        maxLevel: maxLevel,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<EventsModel>> createElement() {
    return _EventsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsListProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.locationIDs == locationIDs &&
        other.minLevel == minLevel &&
        other.maxLevel == maxLevel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, locationIDs.hashCode);
    hash = _SystemHash.combine(hash, minLevel.hashCode);
    hash = _SystemHash.combine(hash, maxLevel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventsListRef on AutoDisposeFutureProviderRef<List<EventsModel>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `locationIDs` of this provider.
  List<int> get locationIDs;

  /// The parameter `minLevel` of this provider.
  double get minLevel;

  /// The parameter `maxLevel` of this provider.
  double get maxLevel;
}

class _EventsListProviderElement
    extends AutoDisposeFutureProviderElement<List<EventsModel>>
    with EventsListRef {
  _EventsListProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as EventsListProvider).startDate;
  @override
  DateTime get endDate => (origin as EventsListProvider).endDate;
  @override
  List<int> get locationIDs => (origin as EventsListProvider).locationIDs;
  @override
  double get minLevel => (origin as EventsListProvider).minLevel;
  @override
  double get maxLevel => (origin as EventsListProvider).maxLevel;
}

String _$lessonsListHash() => r'2b7d431fce91090901231157c96938867c6d1df9';

/// See also [lessonsList].
@ProviderFor(lessonsList)
const lessonsListProvider = LessonsListFamily();

/// See also [lessonsList].
class LessonsListFamily extends Family<AsyncValue<List<LessonsModel>>> {
  /// See also [lessonsList].
  const LessonsListFamily();

  /// See also [lessonsList].
  LessonsListProvider call({
    required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    List<int> coachesIds = const [],
  }) {
    return LessonsListProvider(
      startDate: startDate,
      endDate: endDate,
      locationIDs: locationIDs,
      coachesIds: coachesIds,
    );
  }

  @override
  LessonsListProvider getProviderOverride(
    covariant LessonsListProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      locationIDs: provider.locationIDs,
      coachesIds: provider.coachesIds,
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
  String? get name => r'lessonsListProvider';
}

/// See also [lessonsList].
class LessonsListProvider
    extends AutoDisposeFutureProvider<List<LessonsModel>> {
  /// See also [lessonsList].
  LessonsListProvider({
    required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    List<int> coachesIds = const [],
  }) : this._internal(
          (ref) => lessonsList(
            ref as LessonsListRef,
            startDate: startDate,
            endDate: endDate,
            locationIDs: locationIDs,
            coachesIds: coachesIds,
          ),
          from: lessonsListProvider,
          name: r'lessonsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lessonsListHash,
          dependencies: LessonsListFamily._dependencies,
          allTransitiveDependencies:
              LessonsListFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          locationIDs: locationIDs,
          coachesIds: coachesIds,
        );

  LessonsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.locationIDs,
    required this.coachesIds,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final List<int> locationIDs;
  final List<int> coachesIds;

  @override
  Override overrideWith(
    FutureOr<List<LessonsModel>> Function(LessonsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LessonsListProvider._internal(
        (ref) => create(ref as LessonsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        locationIDs: locationIDs,
        coachesIds: coachesIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<LessonsModel>> createElement() {
    return _LessonsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonsListProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.locationIDs == locationIDs &&
        other.coachesIds == coachesIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, locationIDs.hashCode);
    hash = _SystemHash.combine(hash, coachesIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LessonsListRef on AutoDisposeFutureProviderRef<List<LessonsModel>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `locationIDs` of this provider.
  List<int> get locationIDs;

  /// The parameter `coachesIds` of this provider.
  List<int> get coachesIds;
}

class _LessonsListProviderElement
    extends AutoDisposeFutureProviderElement<List<LessonsModel>>
    with LessonsListRef {
  _LessonsListProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as LessonsListProvider).startDate;
  @override
  DateTime get endDate => (origin as LessonsListProvider).endDate;
  @override
  List<int> get locationIDs => (origin as LessonsListProvider).locationIDs;
  @override
  List<int> get coachesIds => (origin as LessonsListProvider).coachesIds;
}

String _$fetchServiceDetailHash() =>
    r'7bbf7c699be5b4c4814d8648a4d43ce57f986e6d';

/// See also [fetchServiceDetail].
@ProviderFor(fetchServiceDetail)
const fetchServiceDetailProvider = FetchServiceDetailFamily();

/// See also [fetchServiceDetail].
class FetchServiceDetailFamily extends Family<AsyncValue<ServiceDetail>> {
  /// See also [fetchServiceDetail].
  const FetchServiceDetailFamily();

  /// See also [fetchServiceDetail].
  FetchServiceDetailProvider call(
    int serviceID,
  ) {
    return FetchServiceDetailProvider(
      serviceID,
    );
  }

  @override
  FetchServiceDetailProvider getProviderOverride(
    covariant FetchServiceDetailProvider provider,
  ) {
    return call(
      provider.serviceID,
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
  String? get name => r'fetchServiceDetailProvider';
}

/// See also [fetchServiceDetail].
class FetchServiceDetailProvider
    extends AutoDisposeFutureProvider<ServiceDetail> {
  /// See also [fetchServiceDetail].
  FetchServiceDetailProvider(
    int serviceID,
  ) : this._internal(
          (ref) => fetchServiceDetail(
            ref as FetchServiceDetailRef,
            serviceID,
          ),
          from: fetchServiceDetailProvider,
          name: r'fetchServiceDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchServiceDetailHash,
          dependencies: FetchServiceDetailFamily._dependencies,
          allTransitiveDependencies:
              FetchServiceDetailFamily._allTransitiveDependencies,
          serviceID: serviceID,
        );

  FetchServiceDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceID,
  }) : super.internal();

  final int serviceID;

  @override
  Override overrideWith(
    FutureOr<ServiceDetail> Function(FetchServiceDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchServiceDetailProvider._internal(
        (ref) => create(ref as FetchServiceDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceID: serviceID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ServiceDetail> createElement() {
    return _FetchServiceDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchServiceDetailProvider && other.serviceID == serviceID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchServiceDetailRef on AutoDisposeFutureProviderRef<ServiceDetail> {
  /// The parameter `serviceID` of this provider.
  int get serviceID;
}

class _FetchServiceDetailProviderElement
    extends AutoDisposeFutureProviderElement<ServiceDetail>
    with FetchServiceDetailRef {
  _FetchServiceDetailProviderElement(super.provider);

  @override
  int get serviceID => (origin as FetchServiceDetailProvider).serviceID;
}

String _$joinServiceHash() => r'b97ae21d2377675f5ca981eef5fcb4c9be11faee';

/// See also [joinService].
@ProviderFor(joinService)
const joinServiceProvider = JoinServiceFamily();

/// See also [joinService].
class JoinServiceFamily extends Family<AsyncValue<double?>> {
  /// See also [joinService].
  const JoinServiceFamily();

  /// See also [joinService].
  JoinServiceProvider call(
    int id, {
    int? playerId,
    required int position,
    required bool isEvent,
    required bool isOpenMatch,
    required bool isDouble,
    required bool isReserve,
    required bool isLesson,
    bool isApprovalNeeded = false,
  }) {
    return JoinServiceProvider(
      id,
      playerId: playerId,
      position: position,
      isEvent: isEvent,
      isOpenMatch: isOpenMatch,
      isDouble: isDouble,
      isReserve: isReserve,
      isLesson: isLesson,
      isApprovalNeeded: isApprovalNeeded,
    );
  }

  @override
  JoinServiceProvider getProviderOverride(
    covariant JoinServiceProvider provider,
  ) {
    return call(
      provider.id,
      playerId: provider.playerId,
      position: provider.position,
      isEvent: provider.isEvent,
      isOpenMatch: provider.isOpenMatch,
      isDouble: provider.isDouble,
      isReserve: provider.isReserve,
      isLesson: provider.isLesson,
      isApprovalNeeded: provider.isApprovalNeeded,
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
  String? get name => r'joinServiceProvider';
}

/// See also [joinService].
class JoinServiceProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [joinService].
  JoinServiceProvider(
    int id, {
    int? playerId,
    required int position,
    required bool isEvent,
    required bool isOpenMatch,
    required bool isDouble,
    required bool isReserve,
    required bool isLesson,
    bool isApprovalNeeded = false,
  }) : this._internal(
          (ref) => joinService(
            ref as JoinServiceRef,
            id,
            playerId: playerId,
            position: position,
            isEvent: isEvent,
            isOpenMatch: isOpenMatch,
            isDouble: isDouble,
            isReserve: isReserve,
            isLesson: isLesson,
            isApprovalNeeded: isApprovalNeeded,
          ),
          from: joinServiceProvider,
          name: r'joinServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinServiceHash,
          dependencies: JoinServiceFamily._dependencies,
          allTransitiveDependencies:
              JoinServiceFamily._allTransitiveDependencies,
          id: id,
          playerId: playerId,
          position: position,
          isEvent: isEvent,
          isOpenMatch: isOpenMatch,
          isDouble: isDouble,
          isReserve: isReserve,
          isLesson: isLesson,
          isApprovalNeeded: isApprovalNeeded,
        );

  JoinServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.playerId,
    required this.position,
    required this.isEvent,
    required this.isOpenMatch,
    required this.isDouble,
    required this.isReserve,
    required this.isLesson,
    required this.isApprovalNeeded,
  }) : super.internal();

  final int id;
  final int? playerId;
  final int position;
  final bool isEvent;
  final bool isOpenMatch;
  final bool isDouble;
  final bool isReserve;
  final bool isLesson;
  final bool isApprovalNeeded;

  @override
  Override overrideWith(
    FutureOr<double?> Function(JoinServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinServiceProvider._internal(
        (ref) => create(ref as JoinServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        playerId: playerId,
        position: position,
        isEvent: isEvent,
        isOpenMatch: isOpenMatch,
        isDouble: isDouble,
        isReserve: isReserve,
        isLesson: isLesson,
        isApprovalNeeded: isApprovalNeeded,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _JoinServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinServiceProvider &&
        other.id == id &&
        other.playerId == playerId &&
        other.position == position &&
        other.isEvent == isEvent &&
        other.isOpenMatch == isOpenMatch &&
        other.isDouble == isDouble &&
        other.isReserve == isReserve &&
        other.isLesson == isLesson &&
        other.isApprovalNeeded == isApprovalNeeded;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, playerId.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);
    hash = _SystemHash.combine(hash, isEvent.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, isDouble.hashCode);
    hash = _SystemHash.combine(hash, isReserve.hashCode);
    hash = _SystemHash.combine(hash, isLesson.hashCode);
    hash = _SystemHash.combine(hash, isApprovalNeeded.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JoinServiceRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `playerId` of this provider.
  int? get playerId;

  /// The parameter `position` of this provider.
  int get position;

  /// The parameter `isEvent` of this provider.
  bool get isEvent;

  /// The parameter `isOpenMatch` of this provider.
  bool get isOpenMatch;

  /// The parameter `isDouble` of this provider.
  bool get isDouble;

  /// The parameter `isReserve` of this provider.
  bool get isReserve;

  /// The parameter `isLesson` of this provider.
  bool get isLesson;

  /// The parameter `isApprovalNeeded` of this provider.
  bool get isApprovalNeeded;
}

class _JoinServiceProviderElement
    extends AutoDisposeFutureProviderElement<double?> with JoinServiceRef {
  _JoinServiceProviderElement(super.provider);

  @override
  int get id => (origin as JoinServiceProvider).id;
  @override
  int? get playerId => (origin as JoinServiceProvider).playerId;
  @override
  int get position => (origin as JoinServiceProvider).position;
  @override
  bool get isEvent => (origin as JoinServiceProvider).isEvent;
  @override
  bool get isOpenMatch => (origin as JoinServiceProvider).isOpenMatch;
  @override
  bool get isDouble => (origin as JoinServiceProvider).isDouble;
  @override
  bool get isReserve => (origin as JoinServiceProvider).isReserve;
  @override
  bool get isLesson => (origin as JoinServiceProvider).isLesson;
  @override
  bool get isApprovalNeeded => (origin as JoinServiceProvider).isApprovalNeeded;
}

String _$cancelServiceHash() => r'90ea059f4614d1253c8f3fba67fc9584b27e9cb9';

/// See also [cancelService].
@ProviderFor(cancelService)
const cancelServiceProvider = CancelServiceFamily();

/// See also [cancelService].
class CancelServiceFamily extends Family<AsyncValue<bool?>> {
  /// See also [cancelService].
  const CancelServiceFamily();

  /// See also [cancelService].
  CancelServiceProvider call(
    int id,
  ) {
    return CancelServiceProvider(
      id,
    );
  }

  @override
  CancelServiceProvider getProviderOverride(
    covariant CancelServiceProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'cancelServiceProvider';
}

/// See also [cancelService].
class CancelServiceProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [cancelService].
  CancelServiceProvider(
    int id,
  ) : this._internal(
          (ref) => cancelService(
            ref as CancelServiceRef,
            id,
          ),
          from: cancelServiceProvider,
          name: r'cancelServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cancelServiceHash,
          dependencies: CancelServiceFamily._dependencies,
          allTransitiveDependencies:
              CancelServiceFamily._allTransitiveDependencies,
          id: id,
        );

  CancelServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(CancelServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CancelServiceProvider._internal(
        (ref) => create(ref as CancelServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _CancelServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CancelServiceProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CancelServiceRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CancelServiceProviderElement
    extends AutoDisposeFutureProviderElement<bool?> with CancelServiceRef {
  _CancelServiceProviderElement(super.provider);

  @override
  int get id => (origin as CancelServiceProvider).id;
}

String _$fetchServiceWaitingPlayersHash() =>
    r'bd46107762ffc1b7bc8efe00c6ea5fe59af9915b';

/// See also [fetchServiceWaitingPlayers].
@ProviderFor(fetchServiceWaitingPlayers)
const fetchServiceWaitingPlayersProvider = FetchServiceWaitingPlayersFamily();

/// See also [fetchServiceWaitingPlayers].
class FetchServiceWaitingPlayersFamily
    extends Family<AsyncValue<List<ServiceWaitingPlayers>>> {
  /// See also [fetchServiceWaitingPlayers].
  const FetchServiceWaitingPlayersFamily();

  /// See also [fetchServiceWaitingPlayers].
  FetchServiceWaitingPlayersProvider call(
    int id,
    RequestServiceType requestServiceType,
  ) {
    return FetchServiceWaitingPlayersProvider(
      id,
      requestServiceType,
    );
  }

  @override
  FetchServiceWaitingPlayersProvider getProviderOverride(
    covariant FetchServiceWaitingPlayersProvider provider,
  ) {
    return call(
      provider.id,
      provider.requestServiceType,
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
  String? get name => r'fetchServiceWaitingPlayersProvider';
}

/// See also [fetchServiceWaitingPlayers].
class FetchServiceWaitingPlayersProvider
    extends AutoDisposeFutureProvider<List<ServiceWaitingPlayers>> {
  /// See also [fetchServiceWaitingPlayers].
  FetchServiceWaitingPlayersProvider(
    int id,
    RequestServiceType requestServiceType,
  ) : this._internal(
          (ref) => fetchServiceWaitingPlayers(
            ref as FetchServiceWaitingPlayersRef,
            id,
            requestServiceType,
          ),
          from: fetchServiceWaitingPlayersProvider,
          name: r'fetchServiceWaitingPlayersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchServiceWaitingPlayersHash,
          dependencies: FetchServiceWaitingPlayersFamily._dependencies,
          allTransitiveDependencies:
              FetchServiceWaitingPlayersFamily._allTransitiveDependencies,
          id: id,
          requestServiceType: requestServiceType,
        );

  FetchServiceWaitingPlayersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.requestServiceType,
  }) : super.internal();

  final int id;
  final RequestServiceType requestServiceType;

  @override
  Override overrideWith(
    FutureOr<List<ServiceWaitingPlayers>> Function(
            FetchServiceWaitingPlayersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchServiceWaitingPlayersProvider._internal(
        (ref) => create(ref as FetchServiceWaitingPlayersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        requestServiceType: requestServiceType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceWaitingPlayers>>
      createElement() {
    return _FetchServiceWaitingPlayersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchServiceWaitingPlayersProvider &&
        other.id == id &&
        other.requestServiceType == requestServiceType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, requestServiceType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchServiceWaitingPlayersRef
    on AutoDisposeFutureProviderRef<List<ServiceWaitingPlayers>> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `requestServiceType` of this provider.
  RequestServiceType get requestServiceType;
}

class _FetchServiceWaitingPlayersProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceWaitingPlayers>>
    with FetchServiceWaitingPlayersRef {
  _FetchServiceWaitingPlayersProviderElement(super.provider);

  @override
  int get id => (origin as FetchServiceWaitingPlayersProvider).id;
  @override
  RequestServiceType get requestServiceType =>
      (origin as FetchServiceWaitingPlayersProvider).requestServiceType;
}

String _$approvePlayerHash() => r'4fd8ab8406e2dbc47fe3d4f21aa3837111feee5b';

/// See also [approvePlayer].
@ProviderFor(approvePlayer)
const approvePlayerProvider = ApprovePlayerFamily();

/// See also [approvePlayer].
class ApprovePlayerFamily extends Family<AsyncValue<bool>> {
  /// See also [approvePlayer].
  const ApprovePlayerFamily();

  /// See also [approvePlayer].
  ApprovePlayerProvider call({
    bool isApprove = true,
    required int serviceID,
    required int playerID,
  }) {
    return ApprovePlayerProvider(
      isApprove: isApprove,
      serviceID: serviceID,
      playerID: playerID,
    );
  }

  @override
  ApprovePlayerProvider getProviderOverride(
    covariant ApprovePlayerProvider provider,
  ) {
    return call(
      isApprove: provider.isApprove,
      serviceID: provider.serviceID,
      playerID: provider.playerID,
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
  String? get name => r'approvePlayerProvider';
}

/// See also [approvePlayer].
class ApprovePlayerProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [approvePlayer].
  ApprovePlayerProvider({
    bool isApprove = true,
    required int serviceID,
    required int playerID,
  }) : this._internal(
          (ref) => approvePlayer(
            ref as ApprovePlayerRef,
            isApprove: isApprove,
            serviceID: serviceID,
            playerID: playerID,
          ),
          from: approvePlayerProvider,
          name: r'approvePlayerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$approvePlayerHash,
          dependencies: ApprovePlayerFamily._dependencies,
          allTransitiveDependencies:
              ApprovePlayerFamily._allTransitiveDependencies,
          isApprove: isApprove,
          serviceID: serviceID,
          playerID: playerID,
        );

  ApprovePlayerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isApprove,
    required this.serviceID,
    required this.playerID,
  }) : super.internal();

  final bool isApprove;
  final int serviceID;
  final int playerID;

  @override
  Override overrideWith(
    FutureOr<bool> Function(ApprovePlayerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApprovePlayerProvider._internal(
        (ref) => create(ref as ApprovePlayerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isApprove: isApprove,
        serviceID: serviceID,
        playerID: playerID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ApprovePlayerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApprovePlayerProvider &&
        other.isApprove == isApprove &&
        other.serviceID == serviceID &&
        other.playerID == playerID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isApprove.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, playerID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ApprovePlayerRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `isApprove` of this provider.
  bool get isApprove;

  /// The parameter `serviceID` of this provider.
  int get serviceID;

  /// The parameter `playerID` of this provider.
  int get playerID;
}

class _ApprovePlayerProviderElement
    extends AutoDisposeFutureProviderElement<bool> with ApprovePlayerRef {
  _ApprovePlayerProviderElement(super.provider);

  @override
  bool get isApprove => (origin as ApprovePlayerProvider).isApprove;
  @override
  int get serviceID => (origin as ApprovePlayerProvider).serviceID;
  @override
  int get playerID => (origin as ApprovePlayerProvider).playerID;
}

String _$deleteReservedHash() => r'e1ad84f0134d958488a0301006db7b2953b7c2b6';

/// See also [deleteReserved].
@ProviderFor(deleteReserved)
const deleteReservedProvider = DeleteReservedFamily();

/// See also [deleteReserved].
class DeleteReservedFamily extends Family<AsyncValue<bool>> {
  /// See also [deleteReserved].
  const DeleteReservedFamily();

  /// See also [deleteReserved].
  DeleteReservedProvider call(
    int serviceID,
    int reservedID,
  ) {
    return DeleteReservedProvider(
      serviceID,
      reservedID,
    );
  }

  @override
  DeleteReservedProvider getProviderOverride(
    covariant DeleteReservedProvider provider,
  ) {
    return call(
      provider.serviceID,
      provider.reservedID,
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
  String? get name => r'deleteReservedProvider';
}

/// See also [deleteReserved].
class DeleteReservedProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteReserved].
  DeleteReservedProvider(
    int serviceID,
    int reservedID,
  ) : this._internal(
          (ref) => deleteReserved(
            ref as DeleteReservedRef,
            serviceID,
            reservedID,
          ),
          from: deleteReservedProvider,
          name: r'deleteReservedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteReservedHash,
          dependencies: DeleteReservedFamily._dependencies,
          allTransitiveDependencies:
              DeleteReservedFamily._allTransitiveDependencies,
          serviceID: serviceID,
          reservedID: reservedID,
        );

  DeleteReservedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceID,
    required this.reservedID,
  }) : super.internal();

  final int serviceID;
  final int reservedID;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteReservedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteReservedProvider._internal(
        (ref) => create(ref as DeleteReservedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceID: serviceID,
        reservedID: reservedID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteReservedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteReservedProvider &&
        other.serviceID == serviceID &&
        other.reservedID == reservedID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, reservedID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteReservedRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `serviceID` of this provider.
  int get serviceID;

  /// The parameter `reservedID` of this provider.
  int get reservedID;
}

class _DeleteReservedProviderElement
    extends AutoDisposeFutureProviderElement<bool> with DeleteReservedRef {
  _DeleteReservedProviderElement(super.provider);

  @override
  int get serviceID => (origin as DeleteReservedProvider).serviceID;
  @override
  int get reservedID => (origin as DeleteReservedProvider).reservedID;
}

String _$submitAssessmentHash() => r'1ae169ac972cc963880cddaca1881c209d154265';

/// See also [submitAssessment].
@ProviderFor(submitAssessment)
const submitAssessmentProvider = SubmitAssessmentFamily();

/// See also [submitAssessment].
class SubmitAssessmentFamily extends Family<AsyncValue<bool>> {
  /// See also [submitAssessment].
  const SubmitAssessmentFamily();

  /// See also [submitAssessment].
  SubmitAssessmentProvider call({
    required AssessmentReqModel model,
    required int serviceID,
  }) {
    return SubmitAssessmentProvider(
      model: model,
      serviceID: serviceID,
    );
  }

  @override
  SubmitAssessmentProvider getProviderOverride(
    covariant SubmitAssessmentProvider provider,
  ) {
    return call(
      model: provider.model,
      serviceID: provider.serviceID,
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
  String? get name => r'submitAssessmentProvider';
}

/// See also [submitAssessment].
class SubmitAssessmentProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [submitAssessment].
  SubmitAssessmentProvider({
    required AssessmentReqModel model,
    required int serviceID,
  }) : this._internal(
          (ref) => submitAssessment(
            ref as SubmitAssessmentRef,
            model: model,
            serviceID: serviceID,
          ),
          from: submitAssessmentProvider,
          name: r'submitAssessmentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$submitAssessmentHash,
          dependencies: SubmitAssessmentFamily._dependencies,
          allTransitiveDependencies:
              SubmitAssessmentFamily._allTransitiveDependencies,
          model: model,
          serviceID: serviceID,
        );

  SubmitAssessmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.model,
    required this.serviceID,
  }) : super.internal();

  final AssessmentReqModel model;
  final int serviceID;

  @override
  Override overrideWith(
    FutureOr<bool> Function(SubmitAssessmentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubmitAssessmentProvider._internal(
        (ref) => create(ref as SubmitAssessmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        model: model,
        serviceID: serviceID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _SubmitAssessmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmitAssessmentProvider &&
        other.model == model &&
        other.serviceID == serviceID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, model.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubmitAssessmentRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `model` of this provider.
  AssessmentReqModel get model;

  /// The parameter `serviceID` of this provider.
  int get serviceID;
}

class _SubmitAssessmentProviderElement
    extends AutoDisposeFutureProviderElement<bool> with SubmitAssessmentRef {
  _SubmitAssessmentProviderElement(super.provider);

  @override
  AssessmentReqModel get model => (origin as SubmitAssessmentProvider).model;
  @override
  int get serviceID => (origin as SubmitAssessmentProvider).serviceID;
}

String _$fetchAssessmentHash() => r'361a15d57adaab882a7db0e0a92aab6611ee8b49';

/// See also [fetchAssessment].
@ProviderFor(fetchAssessment)
const fetchAssessmentProvider = FetchAssessmentFamily();

/// See also [fetchAssessment].
class FetchAssessmentFamily extends Family<AsyncValue<AssessmentResModel>> {
  /// See also [fetchAssessment].
  const FetchAssessmentFamily();

  /// See also [fetchAssessment].
  FetchAssessmentProvider call(
    int serviceID,
  ) {
    return FetchAssessmentProvider(
      serviceID,
    );
  }

  @override
  FetchAssessmentProvider getProviderOverride(
    covariant FetchAssessmentProvider provider,
  ) {
    return call(
      provider.serviceID,
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
  String? get name => r'fetchAssessmentProvider';
}

/// See also [fetchAssessment].
class FetchAssessmentProvider
    extends AutoDisposeFutureProvider<AssessmentResModel> {
  /// See also [fetchAssessment].
  FetchAssessmentProvider(
    int serviceID,
  ) : this._internal(
          (ref) => fetchAssessment(
            ref as FetchAssessmentRef,
            serviceID,
          ),
          from: fetchAssessmentProvider,
          name: r'fetchAssessmentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAssessmentHash,
          dependencies: FetchAssessmentFamily._dependencies,
          allTransitiveDependencies:
              FetchAssessmentFamily._allTransitiveDependencies,
          serviceID: serviceID,
        );

  FetchAssessmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceID,
  }) : super.internal();

  final int serviceID;

  @override
  Override overrideWith(
    FutureOr<AssessmentResModel> Function(FetchAssessmentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAssessmentProvider._internal(
        (ref) => create(ref as FetchAssessmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceID: serviceID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AssessmentResModel> createElement() {
    return _FetchAssessmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAssessmentProvider && other.serviceID == serviceID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAssessmentRef on AutoDisposeFutureProviderRef<AssessmentResModel> {
  /// The parameter `serviceID` of this provider.
  int get serviceID;
}

class _FetchAssessmentProviderElement
    extends AutoDisposeFutureProviderElement<AssessmentResModel>
    with FetchAssessmentRef {
  _FetchAssessmentProviderElement(super.provider);

  @override
  int get serviceID => (origin as FetchAssessmentProvider).serviceID;
}

String _$lessonsSlotHash() => r'a83f658b579a1a7ff3a9de7da9409ac645cd8633';

/// See also [lessonsSlot].
@ProviderFor(lessonsSlot)
const lessonsSlotProvider = LessonsSlotFamily();

/// See also [lessonsSlot].
class LessonsSlotFamily extends Family<AsyncValue<LessonModelNew>> {
  /// See also [lessonsSlot].
  const LessonsSlotFamily();

  /// See also [lessonsSlot].
  LessonsSlotProvider call({
    required DateTime startTime,
    DateTime? endTime,
    required int? duration,
    required List<int> coachId,
    required String sportName,
  }) {
    return LessonsSlotProvider(
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      coachId: coachId,
      sportName: sportName,
    );
  }

  @override
  LessonsSlotProvider getProviderOverride(
    covariant LessonsSlotProvider provider,
  ) {
    return call(
      startTime: provider.startTime,
      endTime: provider.endTime,
      duration: provider.duration,
      coachId: provider.coachId,
      sportName: provider.sportName,
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
  String? get name => r'lessonsSlotProvider';
}

/// See also [lessonsSlot].
class LessonsSlotProvider extends AutoDisposeFutureProvider<LessonModelNew> {
  /// See also [lessonsSlot].
  LessonsSlotProvider({
    required DateTime startTime,
    DateTime? endTime,
    required int? duration,
    required List<int> coachId,
    required String sportName,
  }) : this._internal(
          (ref) => lessonsSlot(
            ref as LessonsSlotRef,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            coachId: coachId,
            sportName: sportName,
          ),
          from: lessonsSlotProvider,
          name: r'lessonsSlotProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lessonsSlotHash,
          dependencies: LessonsSlotFamily._dependencies,
          allTransitiveDependencies:
              LessonsSlotFamily._allTransitiveDependencies,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          coachId: coachId,
          sportName: sportName,
        );

  LessonsSlotProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.coachId,
    required this.sportName,
  }) : super.internal();

  final DateTime startTime;
  final DateTime? endTime;
  final int? duration;
  final List<int> coachId;
  final String sportName;

  @override
  Override overrideWith(
    FutureOr<LessonModelNew> Function(LessonsSlotRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LessonsSlotProvider._internal(
        (ref) => create(ref as LessonsSlotRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        coachId: coachId,
        sportName: sportName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LessonModelNew> createElement() {
    return _LessonsSlotProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonsSlotProvider &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.duration == duration &&
        other.coachId == coachId &&
        other.sportName == sportName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startTime.hashCode);
    hash = _SystemHash.combine(hash, endTime.hashCode);
    hash = _SystemHash.combine(hash, duration.hashCode);
    hash = _SystemHash.combine(hash, coachId.hashCode);
    hash = _SystemHash.combine(hash, sportName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LessonsSlotRef on AutoDisposeFutureProviderRef<LessonModelNew> {
  /// The parameter `startTime` of this provider.
  DateTime get startTime;

  /// The parameter `endTime` of this provider.
  DateTime? get endTime;

  /// The parameter `duration` of this provider.
  int? get duration;

  /// The parameter `coachId` of this provider.
  List<int> get coachId;

  /// The parameter `sportName` of this provider.
  String get sportName;
}

class _LessonsSlotProviderElement
    extends AutoDisposeFutureProviderElement<LessonModelNew>
    with LessonsSlotRef {
  _LessonsSlotProviderElement(super.provider);

  @override
  DateTime get startTime => (origin as LessonsSlotProvider).startTime;
  @override
  DateTime? get endTime => (origin as LessonsSlotProvider).endTime;
  @override
  int? get duration => (origin as LessonsSlotProvider).duration;
  @override
  List<int> get coachId => (origin as LessonsSlotProvider).coachId;
  @override
  String get sportName => (origin as LessonsSlotProvider).sportName;
}

String _$joinWaitingListHash() => r'd5f14e98a6568e18526b0fae0e90bbf343d53b2d';

/// See also [joinWaitingList].
@ProviderFor(joinWaitingList)
const joinWaitingListProvider = JoinWaitingListFamily();

/// See also [joinWaitingList].
class JoinWaitingListFamily extends Family<AsyncValue<String?>> {
  /// See also [joinWaitingList].
  const JoinWaitingListFamily();

  /// See also [joinWaitingList].
  JoinWaitingListProvider call({
    required int position,
    required int serviceId,
  }) {
    return JoinWaitingListProvider(
      position: position,
      serviceId: serviceId,
    );
  }

  @override
  JoinWaitingListProvider getProviderOverride(
    covariant JoinWaitingListProvider provider,
  ) {
    return call(
      position: provider.position,
      serviceId: provider.serviceId,
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
  String? get name => r'joinWaitingListProvider';
}

/// See also [joinWaitingList].
class JoinWaitingListProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [joinWaitingList].
  JoinWaitingListProvider({
    required int position,
    required int serviceId,
  }) : this._internal(
          (ref) => joinWaitingList(
            ref as JoinWaitingListRef,
            position: position,
            serviceId: serviceId,
          ),
          from: joinWaitingListProvider,
          name: r'joinWaitingListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinWaitingListHash,
          dependencies: JoinWaitingListFamily._dependencies,
          allTransitiveDependencies:
              JoinWaitingListFamily._allTransitiveDependencies,
          position: position,
          serviceId: serviceId,
        );

  JoinWaitingListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.position,
    required this.serviceId,
  }) : super.internal();

  final int position;
  final int serviceId;

  @override
  Override overrideWith(
    FutureOr<String?> Function(JoinWaitingListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinWaitingListProvider._internal(
        (ref) => create(ref as JoinWaitingListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        position: position,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _JoinWaitingListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinWaitingListProvider &&
        other.position == position &&
        other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JoinWaitingListRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `position` of this provider.
  int get position;

  /// The parameter `serviceId` of this provider.
  int get serviceId;
}

class _JoinWaitingListProviderElement
    extends AutoDisposeFutureProviderElement<String?> with JoinWaitingListRef {
  _JoinWaitingListProviderElement(super.provider);

  @override
  int get position => (origin as JoinWaitingListProvider).position;
  @override
  int get serviceId => (origin as JoinWaitingListProvider).serviceId;
}

String _$cancellationPolicyHash() =>
    r'5f15e6523ecc22454f4f2a0e8b0e8c207da06264';

/// See also [cancellationPolicy].
@ProviderFor(cancellationPolicy)
const cancellationPolicyProvider = CancellationPolicyFamily();

/// See also [cancellationPolicy].
class CancellationPolicyFamily extends Family<AsyncValue<CancellationPolicy>> {
  /// See also [cancellationPolicy].
  const CancellationPolicyFamily();

  /// See also [cancellationPolicy].
  CancellationPolicyProvider call(
    int id,
  ) {
    return CancellationPolicyProvider(
      id,
    );
  }

  @override
  CancellationPolicyProvider getProviderOverride(
    covariant CancellationPolicyProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'cancellationPolicyProvider';
}

/// See also [cancellationPolicy].
class CancellationPolicyProvider
    extends AutoDisposeFutureProvider<CancellationPolicy> {
  /// See also [cancellationPolicy].
  CancellationPolicyProvider(
    int id,
  ) : this._internal(
          (ref) => cancellationPolicy(
            ref as CancellationPolicyRef,
            id,
          ),
          from: cancellationPolicyProvider,
          name: r'cancellationPolicyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cancellationPolicyHash,
          dependencies: CancellationPolicyFamily._dependencies,
          allTransitiveDependencies:
              CancellationPolicyFamily._allTransitiveDependencies,
          id: id,
        );

  CancellationPolicyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<CancellationPolicy> Function(CancellationPolicyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CancellationPolicyProvider._internal(
        (ref) => create(ref as CancellationPolicyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CancellationPolicy> createElement() {
    return _CancellationPolicyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CancellationPolicyProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CancellationPolicyRef
    on AutoDisposeFutureProviderRef<CancellationPolicy> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CancellationPolicyProviderElement
    extends AutoDisposeFutureProviderElement<CancellationPolicy>
    with CancellationPolicyRef {
  _CancellationPolicyProviderElement(super.provider);

  @override
  int get id => (origin as CancellationPolicyProvider).id;
}

String _$fetchBlockedCoachesHash() =>
    r'2acae18e4b1cf4d9806358f2dd6d048ce46cb225';

/// See also [fetchBlockedCoaches].
@ProviderFor(fetchBlockedCoaches)
const fetchBlockedCoachesProvider = FetchBlockedCoachesFamily();

/// See also [fetchBlockedCoaches].
class FetchBlockedCoachesFamily extends Family<AsyncValue<List<String>>> {
  /// See also [fetchBlockedCoaches].
  const FetchBlockedCoachesFamily();

  /// See also [fetchBlockedCoaches].
  FetchBlockedCoachesProvider call({
    required DateTime startDate,
    required DateTime endDate,
    required String sportName,
  }) {
    return FetchBlockedCoachesProvider(
      startDate: startDate,
      endDate: endDate,
      sportName: sportName,
    );
  }

  @override
  FetchBlockedCoachesProvider getProviderOverride(
    covariant FetchBlockedCoachesProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      sportName: provider.sportName,
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
  String? get name => r'fetchBlockedCoachesProvider';
}

/// See also [fetchBlockedCoaches].
class FetchBlockedCoachesProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [fetchBlockedCoaches].
  FetchBlockedCoachesProvider({
    required DateTime startDate,
    required DateTime endDate,
    required String sportName,
  }) : this._internal(
          (ref) => fetchBlockedCoaches(
            ref as FetchBlockedCoachesRef,
            startDate: startDate,
            endDate: endDate,
            sportName: sportName,
          ),
          from: fetchBlockedCoachesProvider,
          name: r'fetchBlockedCoachesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchBlockedCoachesHash,
          dependencies: FetchBlockedCoachesFamily._dependencies,
          allTransitiveDependencies:
              FetchBlockedCoachesFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          sportName: sportName,
        );

  FetchBlockedCoachesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.sportName,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final String sportName;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(FetchBlockedCoachesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchBlockedCoachesProvider._internal(
        (ref) => create(ref as FetchBlockedCoachesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        sportName: sportName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _FetchBlockedCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchBlockedCoachesProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.sportName == sportName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, sportName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchBlockedCoachesRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `sportName` of this provider.
  String get sportName;
}

class _FetchBlockedCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with FetchBlockedCoachesRef {
  _FetchBlockedCoachesProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as FetchBlockedCoachesProvider).startDate;
  @override
  DateTime get endDate => (origin as FetchBlockedCoachesProvider).endDate;
  @override
  String get sportName => (origin as FetchBlockedCoachesProvider).sportName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
