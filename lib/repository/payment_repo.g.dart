// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentRepoHash() => r'9fe3844e721b8ce837441831a2b40fe3cd3aa669';

/// See also [paymentRepo].
@ProviderFor(paymentRepo)
final paymentRepoProvider = AutoDisposeProvider<PaymentRepo>.internal(
  paymentRepo,
  name: r'paymentRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$paymentRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentRepoRef = AutoDisposeProviderRef<PaymentRepo>;
String _$fetchPaymentDetailsHash() =>
    r'8ba6baadda1b1f73dab822240114c7de5583397c';

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

/// See also [fetchPaymentDetails].
@ProviderFor(fetchPaymentDetails)
const fetchPaymentDetailsProvider = FetchPaymentDetailsFamily();

/// See also [fetchPaymentDetails].
class FetchPaymentDetailsFamily extends Family<AsyncValue<PaymentDetails>> {
  /// See also [fetchPaymentDetails].
  const FetchPaymentDetailsFamily();

  /// See also [fetchPaymentDetails].
  FetchPaymentDetailsProvider call(
    int locationID,
    PaymentDetailsRequestType type,
    int id,
    DateTime? startDate,
    int? duration,
  ) {
    return FetchPaymentDetailsProvider(
      locationID,
      type,
      id,
      startDate,
      duration,
    );
  }

  @override
  FetchPaymentDetailsProvider getProviderOverride(
    covariant FetchPaymentDetailsProvider provider,
  ) {
    return call(
      provider.locationID,
      provider.type,
      provider.id,
      provider.startDate,
      provider.duration,
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
  String? get name => r'fetchPaymentDetailsProvider';
}

/// See also [fetchPaymentDetails].
class FetchPaymentDetailsProvider
    extends AutoDisposeFutureProvider<PaymentDetails> {
  /// See also [fetchPaymentDetails].
  FetchPaymentDetailsProvider(
    int locationID,
    PaymentDetailsRequestType type,
    int id,
    DateTime? startDate,
    int? duration,
  ) : this._internal(
          (ref) => fetchPaymentDetails(
            ref as FetchPaymentDetailsRef,
            locationID,
            type,
            id,
            startDate,
            duration,
          ),
          from: fetchPaymentDetailsProvider,
          name: r'fetchPaymentDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPaymentDetailsHash,
          dependencies: FetchPaymentDetailsFamily._dependencies,
          allTransitiveDependencies:
              FetchPaymentDetailsFamily._allTransitiveDependencies,
          locationID: locationID,
          type: type,
          id: id,
          startDate: startDate,
          duration: duration,
        );

  FetchPaymentDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationID,
    required this.type,
    required this.id,
    required this.startDate,
    required this.duration,
  }) : super.internal();

  final int locationID;
  final PaymentDetailsRequestType type;
  final int id;
  final DateTime? startDate;
  final int? duration;

  @override
  Override overrideWith(
    FutureOr<PaymentDetails> Function(FetchPaymentDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPaymentDetailsProvider._internal(
        (ref) => create(ref as FetchPaymentDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationID: locationID,
        type: type,
        id: id,
        startDate: startDate,
        duration: duration,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaymentDetails> createElement() {
    return _FetchPaymentDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPaymentDetailsProvider &&
        other.locationID == locationID &&
        other.type == type &&
        other.id == id &&
        other.startDate == startDate &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationID.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, duration.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchPaymentDetailsRef on AutoDisposeFutureProviderRef<PaymentDetails> {
  /// The parameter `locationID` of this provider.
  int get locationID;

  /// The parameter `type` of this provider.
  PaymentDetailsRequestType get type;

  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `duration` of this provider.
  int? get duration;
}

class _FetchPaymentDetailsProviderElement
    extends AutoDisposeFutureProviderElement<PaymentDetails>
    with FetchPaymentDetailsRef {
  _FetchPaymentDetailsProviderElement(super.provider);

  @override
  int get locationID => (origin as FetchPaymentDetailsProvider).locationID;
  @override
  PaymentDetailsRequestType get type =>
      (origin as FetchPaymentDetailsProvider).type;
  @override
  int get id => (origin as FetchPaymentDetailsProvider).id;
  @override
  DateTime? get startDate => (origin as FetchPaymentDetailsProvider).startDate;
  @override
  int? get duration => (origin as FetchPaymentDetailsProvider).duration;
}

String _$paymentProcessHash() => r'71e115acaba364c1ee420a92f7bbf4542625df08';

/// See also [paymentProcess].
@ProviderFor(paymentProcess)
const paymentProcessProvider = PaymentProcessFamily();

/// See also [paymentProcess].
class PaymentProcessFamily
    extends Family<AsyncValue<(int?, String?, double?)>> {
  /// See also [paymentProcess].
  const PaymentProcessFamily();

  /// See also [paymentProcess].
  PaymentProcessProvider call({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    List<AppPaymentMethods>? paymentMethod,
    int? serviceID,
    bool isJoiningApproval = false,
    int? couponID,
  }) {
    return PaymentProcessProvider(
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      serviceID: serviceID,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID,
    );
  }

  @override
  PaymentProcessProvider getProviderOverride(
    covariant PaymentProcessProvider provider,
  ) {
    return call(
      requestType: provider.requestType,
      payLater: provider.payLater,
      totalAmount: provider.totalAmount,
      paymentMethod: provider.paymentMethod,
      serviceID: provider.serviceID,
      isJoiningApproval: provider.isJoiningApproval,
      couponID: provider.couponID,
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
  String? get name => r'paymentProcessProvider';
}

/// See also [paymentProcess].
class PaymentProcessProvider
    extends AutoDisposeFutureProvider<(int?, String?, double?)> {
  /// See also [paymentProcess].
  PaymentProcessProvider({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    List<AppPaymentMethods>? paymentMethod,
    int? serviceID,
    bool isJoiningApproval = false,
    int? couponID,
  }) : this._internal(
          (ref) => paymentProcess(
            ref as PaymentProcessRef,
            requestType: requestType,
            payLater: payLater,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
            serviceID: serviceID,
            isJoiningApproval: isJoiningApproval,
            couponID: couponID,
          ),
          from: paymentProcessProvider,
          name: r'paymentProcessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentProcessHash,
          dependencies: PaymentProcessFamily._dependencies,
          allTransitiveDependencies:
              PaymentProcessFamily._allTransitiveDependencies,
          requestType: requestType,
          payLater: payLater,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
          serviceID: serviceID,
          isJoiningApproval: isJoiningApproval,
          couponID: couponID,
        );

  PaymentProcessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestType,
    required this.payLater,
    required this.totalAmount,
    required this.paymentMethod,
    required this.serviceID,
    required this.isJoiningApproval,
    required this.couponID,
  }) : super.internal();

  final PaymentProcessRequestType requestType;
  final bool? payLater;
  final double? totalAmount;
  final List<AppPaymentMethods>? paymentMethod;
  final int? serviceID;
  final bool isJoiningApproval;
  final int? couponID;

  @override
  Override overrideWith(
    FutureOr<(int?, String?, double?)> Function(PaymentProcessRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentProcessProvider._internal(
        (ref) => create(ref as PaymentProcessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestType: requestType,
        payLater: payLater,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        serviceID: serviceID,
        isJoiningApproval: isJoiningApproval,
        couponID: couponID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(int?, String?, double?)> createElement() {
    return _PaymentProcessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentProcessProvider &&
        other.requestType == requestType &&
        other.payLater == payLater &&
        other.totalAmount == totalAmount &&
        other.paymentMethod == paymentMethod &&
        other.serviceID == serviceID &&
        other.isJoiningApproval == isJoiningApproval &&
        other.couponID == couponID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, payLater.hashCode);
    hash = _SystemHash.combine(hash, totalAmount.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, isJoiningApproval.hashCode);
    hash = _SystemHash.combine(hash, couponID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentProcessRef
    on AutoDisposeFutureProviderRef<(int?, String?, double?)> {
  /// The parameter `requestType` of this provider.
  PaymentProcessRequestType get requestType;

  /// The parameter `payLater` of this provider.
  bool? get payLater;

  /// The parameter `totalAmount` of this provider.
  double? get totalAmount;

  /// The parameter `paymentMethod` of this provider.
  List<AppPaymentMethods>? get paymentMethod;

  /// The parameter `serviceID` of this provider.
  int? get serviceID;

  /// The parameter `isJoiningApproval` of this provider.
  bool get isJoiningApproval;

  /// The parameter `couponID` of this provider.
  int? get couponID;
}

class _PaymentProcessProviderElement
    extends AutoDisposeFutureProviderElement<(int?, String?, double?)>
    with PaymentProcessRef {
  _PaymentProcessProviderElement(super.provider);

  @override
  PaymentProcessRequestType get requestType =>
      (origin as PaymentProcessProvider).requestType;
  @override
  bool? get payLater => (origin as PaymentProcessProvider).payLater;
  @override
  double? get totalAmount => (origin as PaymentProcessProvider).totalAmount;
  @override
  List<AppPaymentMethods>? get paymentMethod =>
      (origin as PaymentProcessProvider).paymentMethod;
  @override
  int? get serviceID => (origin as PaymentProcessProvider).serviceID;
  @override
  bool get isJoiningApproval =>
      (origin as PaymentProcessProvider).isJoiningApproval;
  @override
  int? get couponID => (origin as PaymentProcessProvider).couponID;
}

String _$multiBookingPaymentProcessHash() =>
    r'19e2b67975aec8dad1bcde9d062f98af4d7efd69';

/// See also [multiBookingPaymentProcess].
@ProviderFor(multiBookingPaymentProcess)
const multiBookingPaymentProcessProvider = MultiBookingPaymentProcessFamily();

/// See also [multiBookingPaymentProcess].
class MultiBookingPaymentProcessFamily
    extends Family<AsyncValue<(List<MultipleBookings>?, String?)>> {
  /// See also [multiBookingPaymentProcess].
  const MultiBookingPaymentProcessFamily();

  /// See also [multiBookingPaymentProcess].
  MultiBookingPaymentProcessProvider call({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    AppPaymentMethods? paymentMethod,
    int? serviceID,
    bool isJoiningApproval = false,
    int? couponID,
  }) {
    return MultiBookingPaymentProcessProvider(
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      serviceID: serviceID,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID,
    );
  }

  @override
  MultiBookingPaymentProcessProvider getProviderOverride(
    covariant MultiBookingPaymentProcessProvider provider,
  ) {
    return call(
      requestType: provider.requestType,
      payLater: provider.payLater,
      totalAmount: provider.totalAmount,
      paymentMethod: provider.paymentMethod,
      serviceID: provider.serviceID,
      isJoiningApproval: provider.isJoiningApproval,
      couponID: provider.couponID,
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
  String? get name => r'multiBookingPaymentProcessProvider';
}

/// See also [multiBookingPaymentProcess].
class MultiBookingPaymentProcessProvider
    extends AutoDisposeFutureProvider<(List<MultipleBookings>?, String?)> {
  /// See also [multiBookingPaymentProcess].
  MultiBookingPaymentProcessProvider({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    AppPaymentMethods? paymentMethod,
    int? serviceID,
    bool isJoiningApproval = false,
    int? couponID,
  }) : this._internal(
          (ref) => multiBookingPaymentProcess(
            ref as MultiBookingPaymentProcessRef,
            requestType: requestType,
            payLater: payLater,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
            serviceID: serviceID,
            isJoiningApproval: isJoiningApproval,
            couponID: couponID,
          ),
          from: multiBookingPaymentProcessProvider,
          name: r'multiBookingPaymentProcessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$multiBookingPaymentProcessHash,
          dependencies: MultiBookingPaymentProcessFamily._dependencies,
          allTransitiveDependencies:
              MultiBookingPaymentProcessFamily._allTransitiveDependencies,
          requestType: requestType,
          payLater: payLater,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
          serviceID: serviceID,
          isJoiningApproval: isJoiningApproval,
          couponID: couponID,
        );

  MultiBookingPaymentProcessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestType,
    required this.payLater,
    required this.totalAmount,
    required this.paymentMethod,
    required this.serviceID,
    required this.isJoiningApproval,
    required this.couponID,
  }) : super.internal();

  final PaymentProcessRequestType requestType;
  final bool? payLater;
  final double? totalAmount;
  final AppPaymentMethods? paymentMethod;
  final int? serviceID;
  final bool isJoiningApproval;
  final int? couponID;

  @override
  Override overrideWith(
    FutureOr<(List<MultipleBookings>?, String?)> Function(
            MultiBookingPaymentProcessRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MultiBookingPaymentProcessProvider._internal(
        (ref) => create(ref as MultiBookingPaymentProcessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestType: requestType,
        payLater: payLater,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        serviceID: serviceID,
        isJoiningApproval: isJoiningApproval,
        couponID: couponID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<MultipleBookings>?, String?)>
      createElement() {
    return _MultiBookingPaymentProcessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MultiBookingPaymentProcessProvider &&
        other.requestType == requestType &&
        other.payLater == payLater &&
        other.totalAmount == totalAmount &&
        other.paymentMethod == paymentMethod &&
        other.serviceID == serviceID &&
        other.isJoiningApproval == isJoiningApproval &&
        other.couponID == couponID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, payLater.hashCode);
    hash = _SystemHash.combine(hash, totalAmount.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, isJoiningApproval.hashCode);
    hash = _SystemHash.combine(hash, couponID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MultiBookingPaymentProcessRef
    on AutoDisposeFutureProviderRef<(List<MultipleBookings>?, String?)> {
  /// The parameter `requestType` of this provider.
  PaymentProcessRequestType get requestType;

  /// The parameter `payLater` of this provider.
  bool? get payLater;

  /// The parameter `totalAmount` of this provider.
  double? get totalAmount;

  /// The parameter `paymentMethod` of this provider.
  AppPaymentMethods? get paymentMethod;

  /// The parameter `serviceID` of this provider.
  int? get serviceID;

  /// The parameter `isJoiningApproval` of this provider.
  bool get isJoiningApproval;

  /// The parameter `couponID` of this provider.
  int? get couponID;
}

class _MultiBookingPaymentProcessProviderElement
    extends AutoDisposeFutureProviderElement<(List<MultipleBookings>?, String?)>
    with MultiBookingPaymentProcessRef {
  _MultiBookingPaymentProcessProviderElement(super.provider);

  @override
  PaymentProcessRequestType get requestType =>
      (origin as MultiBookingPaymentProcessProvider).requestType;
  @override
  bool? get payLater => (origin as MultiBookingPaymentProcessProvider).payLater;
  @override
  double? get totalAmount =>
      (origin as MultiBookingPaymentProcessProvider).totalAmount;
  @override
  AppPaymentMethods? get paymentMethod =>
      (origin as MultiBookingPaymentProcessProvider).paymentMethod;
  @override
  int? get serviceID =>
      (origin as MultiBookingPaymentProcessProvider).serviceID;
  @override
  bool get isJoiningApproval =>
      (origin as MultiBookingPaymentProcessProvider).isJoiningApproval;
  @override
  int? get couponID => (origin as MultiBookingPaymentProcessProvider).couponID;
}

String _$purchaseVoucherAPIHash() =>
    r'140b335d899e8cd528cf31b00e975c7f74279bab';

/// See also [purchaseVoucherAPI].
@ProviderFor(purchaseVoucherAPI)
const purchaseVoucherAPIProvider = PurchaseVoucherAPIFamily();

/// See also [purchaseVoucherAPI].
class PurchaseVoucherAPIFamily extends Family<AsyncValue<(bool, String)>> {
  /// See also [purchaseVoucherAPI].
  const PurchaseVoucherAPIFamily();

  /// See also [purchaseVoucherAPI].
  PurchaseVoucherAPIProvider call({
    required AppPaymentMethods paymentMethod,
    required double totalAmount,
    required int voucherId,
    required int locationId,
  }) {
    return PurchaseVoucherAPIProvider(
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      voucherId: voucherId,
      locationId: locationId,
    );
  }

  @override
  PurchaseVoucherAPIProvider getProviderOverride(
    covariant PurchaseVoucherAPIProvider provider,
  ) {
    return call(
      paymentMethod: provider.paymentMethod,
      totalAmount: provider.totalAmount,
      voucherId: provider.voucherId,
      locationId: provider.locationId,
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
  String? get name => r'purchaseVoucherAPIProvider';
}

/// See also [purchaseVoucherAPI].
class PurchaseVoucherAPIProvider
    extends AutoDisposeFutureProvider<(bool, String)> {
  /// See also [purchaseVoucherAPI].
  PurchaseVoucherAPIProvider({
    required AppPaymentMethods paymentMethod,
    required double totalAmount,
    required int voucherId,
    required int locationId,
  }) : this._internal(
          (ref) => purchaseVoucherAPI(
            ref as PurchaseVoucherAPIRef,
            paymentMethod: paymentMethod,
            totalAmount: totalAmount,
            voucherId: voucherId,
            locationId: locationId,
          ),
          from: purchaseVoucherAPIProvider,
          name: r'purchaseVoucherAPIProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchaseVoucherAPIHash,
          dependencies: PurchaseVoucherAPIFamily._dependencies,
          allTransitiveDependencies:
              PurchaseVoucherAPIFamily._allTransitiveDependencies,
          paymentMethod: paymentMethod,
          totalAmount: totalAmount,
          voucherId: voucherId,
          locationId: locationId,
        );

  PurchaseVoucherAPIProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentMethod,
    required this.totalAmount,
    required this.voucherId,
    required this.locationId,
  }) : super.internal();

  final AppPaymentMethods paymentMethod;
  final double totalAmount;
  final int voucherId;
  final int locationId;

  @override
  Override overrideWith(
    FutureOr<(bool, String)> Function(PurchaseVoucherAPIRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PurchaseVoucherAPIProvider._internal(
        (ref) => create(ref as PurchaseVoucherAPIRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentMethod: paymentMethod,
        totalAmount: totalAmount,
        voucherId: voucherId,
        locationId: locationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(bool, String)> createElement() {
    return _PurchaseVoucherAPIProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseVoucherAPIProvider &&
        other.paymentMethod == paymentMethod &&
        other.totalAmount == totalAmount &&
        other.voucherId == voucherId &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);
    hash = _SystemHash.combine(hash, totalAmount.hashCode);
    hash = _SystemHash.combine(hash, voucherId.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PurchaseVoucherAPIRef on AutoDisposeFutureProviderRef<(bool, String)> {
  /// The parameter `paymentMethod` of this provider.
  AppPaymentMethods get paymentMethod;

  /// The parameter `totalAmount` of this provider.
  double get totalAmount;

  /// The parameter `voucherId` of this provider.
  int get voucherId;

  /// The parameter `locationId` of this provider.
  int get locationId;
}

class _PurchaseVoucherAPIProviderElement
    extends AutoDisposeFutureProviderElement<(bool, String)>
    with PurchaseVoucherAPIRef {
  _PurchaseVoucherAPIProviderElement(super.provider);

  @override
  AppPaymentMethods get paymentMethod =>
      (origin as PurchaseVoucherAPIProvider).paymentMethod;
  @override
  double get totalAmount => (origin as PurchaseVoucherAPIProvider).totalAmount;
  @override
  int get voucherId => (origin as PurchaseVoucherAPIProvider).voucherId;
  @override
  int get locationId => (origin as PurchaseVoucherAPIProvider).locationId;
}

String _$verifyCouponHash() => r'd7ca19f1d5ad8c1583b8e86842001de163c1fefa';

/// See also [verifyCoupon].
@ProviderFor(verifyCoupon)
const verifyCouponProvider = VerifyCouponFamily();

/// See also [verifyCoupon].
class VerifyCouponFamily extends Family<AsyncValue<CouponModel>> {
  /// See also [verifyCoupon].
  const VerifyCouponFamily();

  /// See also [verifyCoupon].
  VerifyCouponProvider call({
    required String coupon,
    required double price,
  }) {
    return VerifyCouponProvider(
      coupon: coupon,
      price: price,
    );
  }

  @override
  VerifyCouponProvider getProviderOverride(
    covariant VerifyCouponProvider provider,
  ) {
    return call(
      coupon: provider.coupon,
      price: provider.price,
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
  String? get name => r'verifyCouponProvider';
}

/// See also [verifyCoupon].
class VerifyCouponProvider extends AutoDisposeFutureProvider<CouponModel> {
  /// See also [verifyCoupon].
  VerifyCouponProvider({
    required String coupon,
    required double price,
  }) : this._internal(
          (ref) => verifyCoupon(
            ref as VerifyCouponRef,
            coupon: coupon,
            price: price,
          ),
          from: verifyCouponProvider,
          name: r'verifyCouponProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$verifyCouponHash,
          dependencies: VerifyCouponFamily._dependencies,
          allTransitiveDependencies:
              VerifyCouponFamily._allTransitiveDependencies,
          coupon: coupon,
          price: price,
        );

  VerifyCouponProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coupon,
    required this.price,
  }) : super.internal();

  final String coupon;
  final double price;

  @override
  Override overrideWith(
    FutureOr<CouponModel> Function(VerifyCouponRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VerifyCouponProvider._internal(
        (ref) => create(ref as VerifyCouponRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coupon: coupon,
        price: price,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CouponModel> createElement() {
    return _VerifyCouponProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VerifyCouponProvider &&
        other.coupon == coupon &&
        other.price == price;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coupon.hashCode);
    hash = _SystemHash.combine(hash, price.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VerifyCouponRef on AutoDisposeFutureProviderRef<CouponModel> {
  /// The parameter `coupon` of this provider.
  String get coupon;

  /// The parameter `price` of this provider.
  double get price;
}

class _VerifyCouponProviderElement
    extends AutoDisposeFutureProviderElement<CouponModel> with VerifyCouponRef {
  _VerifyCouponProviderElement(super.provider);

  @override
  String get coupon => (origin as VerifyCouponProvider).coupon;
  @override
  double get price => (origin as VerifyCouponProvider).price;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
