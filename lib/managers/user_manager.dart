import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/managers/shared_pref_manager.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_manager.g.dart';

@Riverpod(keepAlive: true)
UserManager userManager(UserManagerRef ref) {
  return UserManager();
}

final userProvider =
    StateProvider<AppUser?>((ref) => ref.read(userManagerProvider).user);

@Riverpod(keepAlive: true)
Future<bool> isAuthenticated(IsAuthenticatedRef ref) async {
  return ref.read(userManagerProvider).isAuthenticated(ref);
}

class UserManager {
  bool? _isAuthenticated;
  AppUser? _user;

  AppUser? get user => _user;

  authenticate(Ref ref, AppUser user) async {
    _user = AppUser.fromJson(user.toJson());
    ref.read(userProvider.notifier).state = _user;
    await ref.read(sharedPrefManagerProvider).saveUser(user);
  }

  Future<bool> isAuthenticated(IsAuthenticatedRef ref) async {
    _isAuthenticated ??= await _checkIfAuthenticated(ref);
    return _isAuthenticated!;
  }

  Future<bool> _checkIfAuthenticated(IsAuthenticatedRef ref) async {
    final user = ref.read(sharedPrefManagerProvider).fetchUser();
    if (user != null) {
      _user = user;
      return true;
    }
    return false;
  }

  signout(dynamic ref) async {
    if (ref is Ref || ref is WidgetRef) {
      _user = null;
      _isAuthenticated = false;
      ref.refresh(isAuthenticatedProvider);

      await ref.read(sharedPrefManagerProvider).clearUser();
    }
  }
}
