// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$levelRepoHash() => r'b3e29487fd16a9dc76b3c6b9d9e8e813108792b2';

/// See also [levelRepo].
@ProviderFor(levelRepo)
final levelRepoProvider = AutoDisposeProvider<LevelRepo>.internal(
  levelRepo,
  name: r'levelRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$levelRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LevelRepoRef = AutoDisposeProviderRef<LevelRepo>;
String _$levelQuestionsHash() => r'38985e53a7faafb98c16da21c538a983fc2133c4';

/// See also [levelQuestions].
@ProviderFor(levelQuestions)
final levelQuestionsProvider =
    AutoDisposeFutureProvider<List<LevelQuestion>>.internal(
  levelQuestions,
  name: r'levelQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$levelQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LevelQuestionsRef = AutoDisposeFutureProviderRef<List<LevelQuestion>>;
String _$calculateLevelHash() => r'2d2341e2f0e012eb4c8efe520d437674a270d4ed';

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

/// See also [calculateLevel].
@ProviderFor(calculateLevel)
const calculateLevelProvider = CalculateLevelFamily();

/// See also [calculateLevel].
class CalculateLevelFamily extends Family<AsyncValue<CalculatedLevelData>> {
  /// See also [calculateLevel].
  const CalculateLevelFamily();

  /// See also [calculateLevel].
  CalculateLevelProvider call(
    List<double?> answers,
  ) {
    return CalculateLevelProvider(
      answers,
    );
  }

  @override
  CalculateLevelProvider getProviderOverride(
    covariant CalculateLevelProvider provider,
  ) {
    return call(
      provider.answers,
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
  String? get name => r'calculateLevelProvider';
}

/// See also [calculateLevel].
class CalculateLevelProvider
    extends AutoDisposeFutureProvider<CalculatedLevelData> {
  /// See also [calculateLevel].
  CalculateLevelProvider(
    List<double?> answers,
  ) : this._internal(
          (ref) => calculateLevel(
            ref as CalculateLevelRef,
            answers,
          ),
          from: calculateLevelProvider,
          name: r'calculateLevelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calculateLevelHash,
          dependencies: CalculateLevelFamily._dependencies,
          allTransitiveDependencies:
              CalculateLevelFamily._allTransitiveDependencies,
          answers: answers,
        );

  CalculateLevelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.answers,
  }) : super.internal();

  final List<double?> answers;

  @override
  Override overrideWith(
    FutureOr<CalculatedLevelData> Function(CalculateLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalculateLevelProvider._internal(
        (ref) => create(ref as CalculateLevelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        answers: answers,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CalculatedLevelData> createElement() {
    return _CalculateLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateLevelProvider && other.answers == answers;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, answers.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalculateLevelRef on AutoDisposeFutureProviderRef<CalculatedLevelData> {
  /// The parameter `answers` of this provider.
  List<double?> get answers;
}

class _CalculateLevelProviderElement
    extends AutoDisposeFutureProviderElement<CalculatedLevelData>
    with CalculateLevelRef {
  _CalculateLevelProviderElement(super.provider);

  @override
  List<double?> get answers => (origin as CalculateLevelProvider).answers;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
