// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepoHash() => r'97ad17a1d489e0d3aa8886512915644a524a1af8';

/// See also [authRepo].
@ProviderFor(authRepo)
final authRepoProvider = Provider<AuthRepo>.internal(
  authRepo,
  name: r'authRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepoRef = ProviderRef<AuthRepo>;
String _$loginUserHash() => r'6dcd9ab5ca307bef7e553297319ad86a440d88db';

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

/// See also [loginUser].
@ProviderFor(loginUser)
const loginUserProvider = LoginUserFamily();

/// See also [loginUser].
class LoginUserFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [loginUser].
  const LoginUserFamily();

  /// See also [loginUser].
  LoginUserProvider call(
    String email,
    String password,
  ) {
    return LoginUserProvider(
      email,
      password,
    );
  }

  @override
  LoginUserProvider getProviderOverride(
    covariant LoginUserProvider provider,
  ) {
    return call(
      provider.email,
      provider.password,
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
  String? get name => r'loginUserProvider';
}

/// See also [loginUser].
class LoginUserProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [loginUser].
  LoginUserProvider(
    String email,
    String password,
  ) : this._internal(
          (ref) => loginUser(
            ref as LoginUserRef,
            email,
            password,
          ),
          from: loginUserProvider,
          name: r'loginUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginUserHash,
          dependencies: LoginUserFamily._dependencies,
          allTransitiveDependencies: LoginUserFamily._allTransitiveDependencies,
          email: email,
          password: password,
        );

  LoginUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
  }) : super.internal();

  final String email;
  final String password;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(LoginUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoginUserProvider._internal(
        (ref) => create(ref as LoginUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _LoginUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginUserProvider &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoginUserRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;
}

class _LoginUserProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with LoginUserRef {
  _LoginUserProviderElement(super.provider);

  @override
  String get email => (origin as LoginUserProvider).email;
  @override
  String get password => (origin as LoginUserProvider).password;
}

String _$registerUserHash() => r'8cea4ebe62c9c7672d840412af619633db2fafdb';

/// See also [registerUser].
@ProviderFor(registerUser)
const registerUserProvider = RegisterUserFamily();

/// See also [registerUser].
class RegisterUserFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [registerUser].
  const RegisterUserFamily();

  /// See also [registerUser].
  RegisterUserProvider call(
    RegisterModel model,
  ) {
    return RegisterUserProvider(
      model,
    );
  }

  @override
  RegisterUserProvider getProviderOverride(
    covariant RegisterUserProvider provider,
  ) {
    return call(
      provider.model,
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
  String? get name => r'registerUserProvider';
}

/// See also [registerUser].
class RegisterUserProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [registerUser].
  RegisterUserProvider(
    RegisterModel model,
  ) : this._internal(
          (ref) => registerUser(
            ref as RegisterUserRef,
            model,
          ),
          from: registerUserProvider,
          name: r'registerUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$registerUserHash,
          dependencies: RegisterUserFamily._dependencies,
          allTransitiveDependencies:
              RegisterUserFamily._allTransitiveDependencies,
          model: model,
        );

  RegisterUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.model,
  }) : super.internal();

  final RegisterModel model;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(RegisterUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegisterUserProvider._internal(
        (ref) => create(ref as RegisterUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        model: model,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _RegisterUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegisterUserProvider && other.model == model;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, model.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RegisterUserRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `model` of this provider.
  RegisterModel get model;
}

class _RegisterUserProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with RegisterUserRef {
  _RegisterUserProviderElement(super.provider);

  @override
  RegisterModel get model => (origin as RegisterUserProvider).model;
}

String _$fetchUserHash() => r'099ebf003f1ab6676e312af39803bde0a7e5b1cd';

/// See also [fetchUser].
@ProviderFor(fetchUser)
final fetchUserProvider = FutureProvider<bool>.internal(
  fetchUser,
  name: r'fetchUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchUserRef = FutureProviderRef<bool>;
String _$updateUserHash() => r'49753388487c4557191ee6510a979534427f3962';

/// See also [updateUser].
@ProviderFor(updateUser)
const updateUserProvider = UpdateUserFamily();

/// See also [updateUser].
class UpdateUserFamily extends Family<AsyncValue<bool>> {
  /// See also [updateUser].
  const UpdateUserFamily();

  /// See also [updateUser].
  UpdateUserProvider call(
    User? user,
  ) {
    return UpdateUserProvider(
      user,
    );
  }

  @override
  UpdateUserProvider getProviderOverride(
    covariant UpdateUserProvider provider,
  ) {
    return call(
      provider.user,
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
  String? get name => r'updateUserProvider';
}

/// See also [updateUser].
class UpdateUserProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updateUser].
  UpdateUserProvider(
    User? user,
  ) : this._internal(
          (ref) => updateUser(
            ref as UpdateUserRef,
            user,
          ),
          from: updateUserProvider,
          name: r'updateUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateUserHash,
          dependencies: UpdateUserFamily._dependencies,
          allTransitiveDependencies:
              UpdateUserFamily._allTransitiveDependencies,
          user: user,
        );

  UpdateUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.user,
  }) : super.internal();

  final User? user;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdateUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateUserProvider._internal(
        (ref) => create(ref as UpdateUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        user: user,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdateUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateUserProvider && other.user == user;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateUserRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `user` of this provider.
  User? get user;
}

class _UpdateUserProviderElement extends AutoDisposeFutureProviderElement<bool>
    with UpdateUserRef {
  _UpdateUserProviderElement(super.provider);

  @override
  User? get user => (origin as UpdateUserProvider).user;
}

String _$updateProfileHash() => r'13c111f47f5d8cb7ef253793fe3f802821901f78';

/// See also [updateProfile].
@ProviderFor(updateProfile)
const updateProfileProvider = UpdateProfileFamily();

/// See also [updateProfile].
class UpdateProfileFamily extends Family<AsyncValue<bool>> {
  /// See also [updateProfile].
  const UpdateProfileFamily();

  /// See also [updateProfile].
  UpdateProfileProvider call(
    File? file,
  ) {
    return UpdateProfileProvider(
      file,
    );
  }

  @override
  UpdateProfileProvider getProviderOverride(
    covariant UpdateProfileProvider provider,
  ) {
    return call(
      provider.file,
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
  String? get name => r'updateProfileProvider';
}

/// See also [updateProfile].
class UpdateProfileProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updateProfile].
  UpdateProfileProvider(
    File? file,
  ) : this._internal(
          (ref) => updateProfile(
            ref as UpdateProfileRef,
            file,
          ),
          from: updateProfileProvider,
          name: r'updateProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateProfileHash,
          dependencies: UpdateProfileFamily._dependencies,
          allTransitiveDependencies:
              UpdateProfileFamily._allTransitiveDependencies,
          file: file,
        );

  UpdateProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
  }) : super.internal();

  final File? file;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdateProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateProfileProvider._internal(
        (ref) => create(ref as UpdateProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdateProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProfileProvider && other.file == file;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateProfileRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `file` of this provider.
  File? get file;
}

class _UpdateProfileProviderElement
    extends AutoDisposeFutureProviderElement<bool> with UpdateProfileRef {
  _UpdateProfileProviderElement(super.provider);

  @override
  File? get file => (origin as UpdateProfileProvider).file;
}

String _$fetchAllCustomFieldsHash() =>
    r'98d9db596e582cbfee0285f28102e09a2d6f9ed7';

/// See also [fetchAllCustomFields].
@ProviderFor(fetchAllCustomFields)
final fetchAllCustomFieldsProvider =
    FutureProvider<List<CustomFields>>.internal(
  fetchAllCustomFields,
  name: r'fetchAllCustomFieldsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAllCustomFieldsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchAllCustomFieldsRef = FutureProviderRef<List<CustomFields>>;
String _$updatePictureAndUserHash() =>
    r'9e122d692dea8955cfa58e549eb96e6f1a3f4f13';

/// See also [updatePictureAndUser].
@ProviderFor(updatePictureAndUser)
const updatePictureAndUserProvider = UpdatePictureAndUserFamily();

/// See also [updatePictureAndUser].
class UpdatePictureAndUserFamily extends Family<AsyncValue<(bool?, bool?)>> {
  /// See also [updatePictureAndUser].
  const UpdatePictureAndUserFamily();

  /// See also [updatePictureAndUser].
  UpdatePictureAndUserProvider call(
    File? file,
    User? user,
  ) {
    return UpdatePictureAndUserProvider(
      file,
      user,
    );
  }

  @override
  UpdatePictureAndUserProvider getProviderOverride(
    covariant UpdatePictureAndUserProvider provider,
  ) {
    return call(
      provider.file,
      provider.user,
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
  String? get name => r'updatePictureAndUserProvider';
}

/// See also [updatePictureAndUser].
class UpdatePictureAndUserProvider
    extends AutoDisposeFutureProvider<(bool?, bool?)> {
  /// See also [updatePictureAndUser].
  UpdatePictureAndUserProvider(
    File? file,
    User? user,
  ) : this._internal(
          (ref) => updatePictureAndUser(
            ref as UpdatePictureAndUserRef,
            file,
            user,
          ),
          from: updatePictureAndUserProvider,
          name: r'updatePictureAndUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updatePictureAndUserHash,
          dependencies: UpdatePictureAndUserFamily._dependencies,
          allTransitiveDependencies:
              UpdatePictureAndUserFamily._allTransitiveDependencies,
          file: file,
          user: user,
        );

  UpdatePictureAndUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
    required this.user,
  }) : super.internal();

  final File? file;
  final User? user;

  @override
  Override overrideWith(
    FutureOr<(bool?, bool?)> Function(UpdatePictureAndUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdatePictureAndUserProvider._internal(
        (ref) => create(ref as UpdatePictureAndUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
        user: user,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(bool?, bool?)> createElement() {
    return _UpdatePictureAndUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePictureAndUserProvider &&
        other.file == file &&
        other.user == user;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdatePictureAndUserRef on AutoDisposeFutureProviderRef<(bool?, bool?)> {
  /// The parameter `file` of this provider.
  File? get file;

  /// The parameter `user` of this provider.
  User? get user;
}

class _UpdatePictureAndUserProviderElement
    extends AutoDisposeFutureProviderElement<(bool?, bool?)>
    with UpdatePictureAndUserRef {
  _UpdatePictureAndUserProviderElement(super.provider);

  @override
  File? get file => (origin as UpdatePictureAndUserProvider).file;
  @override
  User? get user => (origin as UpdatePictureAndUserProvider).user;
}

String _$fetchUserAssessmentHash() =>
    r'771f158811b7bbbe45afa475e197b06c56cf9d59';

/// See also [fetchUserAssessment].
@ProviderFor(fetchUserAssessment)
const fetchUserAssessmentProvider = FetchUserAssessmentFamily();

/// See also [fetchUserAssessment].
class FetchUserAssessmentFamily extends Family<AsyncValue<UserAssessment>> {
  /// See also [fetchUserAssessment].
  const FetchUserAssessmentFamily();

  /// See also [fetchUserAssessment].
  FetchUserAssessmentProvider call({
    required int id,
  }) {
    return FetchUserAssessmentProvider(
      id: id,
    );
  }

  @override
  FetchUserAssessmentProvider getProviderOverride(
    covariant FetchUserAssessmentProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'fetchUserAssessmentProvider';
}

/// See also [fetchUserAssessment].
class FetchUserAssessmentProvider
    extends AutoDisposeFutureProvider<UserAssessment> {
  /// See also [fetchUserAssessment].
  FetchUserAssessmentProvider({
    required int id,
  }) : this._internal(
          (ref) => fetchUserAssessment(
            ref as FetchUserAssessmentRef,
            id: id,
          ),
          from: fetchUserAssessmentProvider,
          name: r'fetchUserAssessmentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserAssessmentHash,
          dependencies: FetchUserAssessmentFamily._dependencies,
          allTransitiveDependencies:
              FetchUserAssessmentFamily._allTransitiveDependencies,
          id: id,
        );

  FetchUserAssessmentProvider._internal(
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
    FutureOr<UserAssessment> Function(FetchUserAssessmentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserAssessmentProvider._internal(
        (ref) => create(ref as FetchUserAssessmentRef),
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
  AutoDisposeFutureProviderElement<UserAssessment> createElement() {
    return _FetchUserAssessmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserAssessmentProvider && other.id == id;
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
mixin FetchUserAssessmentRef on AutoDisposeFutureProviderRef<UserAssessment> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FetchUserAssessmentProviderElement
    extends AutoDisposeFutureProviderElement<UserAssessment>
    with FetchUserAssessmentRef {
  _FetchUserAssessmentProviderElement(super.provider);

  @override
  int get id => (origin as FetchUserAssessmentProvider).id;
}

String _$updatePasswordHash() => r'a21d921bf0443cbc9cbbdd4f3357101361896c9f';

/// See also [updatePassword].
@ProviderFor(updatePassword)
const updatePasswordProvider = UpdatePasswordFamily();

/// See also [updatePassword].
class UpdatePasswordFamily extends Family<AsyncValue<bool>> {
  /// See also [updatePassword].
  const UpdatePasswordFamily();

  /// See also [updatePassword].
  UpdatePasswordProvider call({
    required String oldPassword,
    required String newPassword,
  }) {
    return UpdatePasswordProvider(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  UpdatePasswordProvider getProviderOverride(
    covariant UpdatePasswordProvider provider,
  ) {
    return call(
      oldPassword: provider.oldPassword,
      newPassword: provider.newPassword,
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
  String? get name => r'updatePasswordProvider';
}

/// See also [updatePassword].
class UpdatePasswordProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updatePassword].
  UpdatePasswordProvider({
    required String oldPassword,
    required String newPassword,
  }) : this._internal(
          (ref) => updatePassword(
            ref as UpdatePasswordRef,
            oldPassword: oldPassword,
            newPassword: newPassword,
          ),
          from: updatePasswordProvider,
          name: r'updatePasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updatePasswordHash,
          dependencies: UpdatePasswordFamily._dependencies,
          allTransitiveDependencies:
              UpdatePasswordFamily._allTransitiveDependencies,
          oldPassword: oldPassword,
          newPassword: newPassword,
        );

  UpdatePasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.oldPassword,
    required this.newPassword,
  }) : super.internal();

  final String oldPassword;
  final String newPassword;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdatePasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdatePasswordProvider._internal(
        (ref) => create(ref as UpdatePasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdatePasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePasswordProvider &&
        other.oldPassword == oldPassword &&
        other.newPassword == newPassword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, oldPassword.hashCode);
    hash = _SystemHash.combine(hash, newPassword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdatePasswordRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `oldPassword` of this provider.
  String get oldPassword;

  /// The parameter `newPassword` of this provider.
  String get newPassword;
}

class _UpdatePasswordProviderElement
    extends AutoDisposeFutureProviderElement<bool> with UpdatePasswordRef {
  _UpdatePasswordProviderElement(super.provider);

  @override
  String get oldPassword => (origin as UpdatePasswordProvider).oldPassword;
  @override
  String get newPassword => (origin as UpdatePasswordProvider).newPassword;
}

String _$deleteAccountHash() => r'bbfa8a9b19d4fe69f1595787ff5a5ed24063352d';

/// See also [deleteAccount].
@ProviderFor(deleteAccount)
const deleteAccountProvider = DeleteAccountFamily();

/// See also [deleteAccount].
class DeleteAccountFamily extends Family<AsyncValue<bool>> {
  /// See also [deleteAccount].
  const DeleteAccountFamily();

  /// See also [deleteAccount].
  DeleteAccountProvider call({
    required String password,
  }) {
    return DeleteAccountProvider(
      password: password,
    );
  }

  @override
  DeleteAccountProvider getProviderOverride(
    covariant DeleteAccountProvider provider,
  ) {
    return call(
      password: provider.password,
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
  String? get name => r'deleteAccountProvider';
}

/// See also [deleteAccount].
class DeleteAccountProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteAccount].
  DeleteAccountProvider({
    required String password,
  }) : this._internal(
          (ref) => deleteAccount(
            ref as DeleteAccountRef,
            password: password,
          ),
          from: deleteAccountProvider,
          name: r'deleteAccountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteAccountHash,
          dependencies: DeleteAccountFamily._dependencies,
          allTransitiveDependencies:
              DeleteAccountFamily._allTransitiveDependencies,
          password: password,
        );

  DeleteAccountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.password,
  }) : super.internal();

  final String password;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteAccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteAccountProvider._internal(
        (ref) => create(ref as DeleteAccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteAccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteAccountProvider && other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteAccountRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `password` of this provider.
  String get password;
}

class _DeleteAccountProviderElement
    extends AutoDisposeFutureProviderElement<bool> with DeleteAccountRef {
  _DeleteAccountProviderElement(super.provider);

  @override
  String get password => (origin as DeleteAccountProvider).password;
}

String _$walletInfoHash() => r'b85e22a85700e433b87e7cbb00baacfdf2b91677';

/// See also [walletInfo].
@ProviderFor(walletInfo)
final walletInfoProvider = AutoDisposeFutureProvider<List<WalletInfo>>.internal(
  walletInfo,
  name: r'walletInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$walletInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletInfoRef = AutoDisposeFutureProviderRef<List<WalletInfo>>;
String _$transactionsHash() => r'14397e550e14e09358c2d9caef1aedaae2c241cc';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeFutureProvider<List<TransactionModel>>.internal(
  transactions,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRef = AutoDisposeFutureProviderRef<List<TransactionModel>>;
String _$saveFCMTokenHash() => r'c8f3a62078ac93dde6a0be4f03bbe9de0a1fde37';

/// See also [saveFCMToken].
@ProviderFor(saveFCMToken)
const saveFCMTokenProvider = SaveFCMTokenFamily();

/// See also [saveFCMToken].
class SaveFCMTokenFamily extends Family<AsyncValue<void>> {
  /// See also [saveFCMToken].
  const SaveFCMTokenFamily();

  /// See also [saveFCMToken].
  SaveFCMTokenProvider call(
    String token,
  ) {
    return SaveFCMTokenProvider(
      token,
    );
  }

  @override
  SaveFCMTokenProvider getProviderOverride(
    covariant SaveFCMTokenProvider provider,
  ) {
    return call(
      provider.token,
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
  String? get name => r'saveFCMTokenProvider';
}

/// See also [saveFCMToken].
class SaveFCMTokenProvider extends AutoDisposeFutureProvider<void> {
  /// See also [saveFCMToken].
  SaveFCMTokenProvider(
    String token,
  ) : this._internal(
          (ref) => saveFCMToken(
            ref as SaveFCMTokenRef,
            token,
          ),
          from: saveFCMTokenProvider,
          name: r'saveFCMTokenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveFCMTokenHash,
          dependencies: SaveFCMTokenFamily._dependencies,
          allTransitiveDependencies:
              SaveFCMTokenFamily._allTransitiveDependencies,
          token: token,
        );

  SaveFCMTokenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveFCMTokenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveFCMTokenProvider._internal(
        (ref) => create(ref as SaveFCMTokenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveFCMTokenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveFCMTokenProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaveFCMTokenRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `token` of this provider.
  String get token;
}

class _SaveFCMTokenProviderElement
    extends AutoDisposeFutureProviderElement<void> with SaveFCMTokenRef {
  _SaveFCMTokenProviderElement(super.provider);

  @override
  String get token => (origin as SaveFCMTokenProvider).token;
}

String _$recoverPasswordHash() => r'000818da027fa41325fb9bcc7f8c384808f0bc06';

/// See also [recoverPassword].
@ProviderFor(recoverPassword)
const recoverPasswordProvider = RecoverPasswordFamily();

/// See also [recoverPassword].
class RecoverPasswordFamily extends Family<AsyncValue<bool?>> {
  /// See also [recoverPassword].
  const RecoverPasswordFamily();

  /// See also [recoverPassword].
  RecoverPasswordProvider call(
    String email,
  ) {
    return RecoverPasswordProvider(
      email,
    );
  }

  @override
  RecoverPasswordProvider getProviderOverride(
    covariant RecoverPasswordProvider provider,
  ) {
    return call(
      provider.email,
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
  String? get name => r'recoverPasswordProvider';
}

/// See also [recoverPassword].
class RecoverPasswordProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [recoverPassword].
  RecoverPasswordProvider(
    String email,
  ) : this._internal(
          (ref) => recoverPassword(
            ref as RecoverPasswordRef,
            email,
          ),
          from: recoverPasswordProvider,
          name: r'recoverPasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recoverPasswordHash,
          dependencies: RecoverPasswordFamily._dependencies,
          allTransitiveDependencies:
              RecoverPasswordFamily._allTransitiveDependencies,
          email: email,
        );

  RecoverPasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String email;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(RecoverPasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoverPasswordProvider._internal(
        (ref) => create(ref as RecoverPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _RecoverPasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecoverPasswordProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecoverPasswordRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `email` of this provider.
  String get email;
}

class _RecoverPasswordProviderElement
    extends AutoDisposeFutureProviderElement<bool?> with RecoverPasswordRef {
  _RecoverPasswordProviderElement(super.provider);

  @override
  String get email => (origin as RecoverPasswordProvider).email;
}

String _$updateRecoveryPasswordHash() =>
    r'aca845866de76a720bea59f5d06e52538652841e';

/// See also [updateRecoveryPassword].
@ProviderFor(updateRecoveryPassword)
const updateRecoveryPasswordProvider = UpdateRecoveryPasswordFamily();

/// See also [updateRecoveryPassword].
class UpdateRecoveryPasswordFamily extends Family<AsyncValue<bool?>> {
  /// See also [updateRecoveryPassword].
  const UpdateRecoveryPasswordFamily();

  /// See also [updateRecoveryPassword].
  UpdateRecoveryPasswordProvider call({
    required String email,
    required String password,
    required String token,
  }) {
    return UpdateRecoveryPasswordProvider(
      email: email,
      password: password,
      token: token,
    );
  }

  @override
  UpdateRecoveryPasswordProvider getProviderOverride(
    covariant UpdateRecoveryPasswordProvider provider,
  ) {
    return call(
      email: provider.email,
      password: provider.password,
      token: provider.token,
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
  String? get name => r'updateRecoveryPasswordProvider';
}

/// See also [updateRecoveryPassword].
class UpdateRecoveryPasswordProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [updateRecoveryPassword].
  UpdateRecoveryPasswordProvider({
    required String email,
    required String password,
    required String token,
  }) : this._internal(
          (ref) => updateRecoveryPassword(
            ref as UpdateRecoveryPasswordRef,
            email: email,
            password: password,
            token: token,
          ),
          from: updateRecoveryPasswordProvider,
          name: r'updateRecoveryPasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateRecoveryPasswordHash,
          dependencies: UpdateRecoveryPasswordFamily._dependencies,
          allTransitiveDependencies:
              UpdateRecoveryPasswordFamily._allTransitiveDependencies,
          email: email,
          password: password,
          token: token,
        );

  UpdateRecoveryPasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
    required this.token,
  }) : super.internal();

  final String email;
  final String password;
  final String token;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(UpdateRecoveryPasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateRecoveryPasswordProvider._internal(
        (ref) => create(ref as UpdateRecoveryPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _UpdateRecoveryPasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateRecoveryPasswordProvider &&
        other.email == email &&
        other.password == password &&
        other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateRecoveryPasswordRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;

  /// The parameter `token` of this provider.
  String get token;
}

class _UpdateRecoveryPasswordProviderElement
    extends AutoDisposeFutureProviderElement<bool?>
    with UpdateRecoveryPasswordRef {
  _UpdateRecoveryPasswordProviderElement(super.provider);

  @override
  String get email => (origin as UpdateRecoveryPasswordProvider).email;
  @override
  String get password => (origin as UpdateRecoveryPasswordProvider).password;
  @override
  String get token => (origin as UpdateRecoveryPasswordProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
