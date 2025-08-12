import 'dart:io';

import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/wallet_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/models/custom_fields.dart';
import 'package:acepadel/models/register_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/transaction_model.dart';
import '../models/user_assessment.dart';
part 'user_repo.g.dart';

class AuthRepo {
  Future<AppUser> signIn(String email, String password, Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response = await apiManager.post(ref, ApiEndPoint.login, {
        'email': email,
        'password': password,
      });
      if (response is Map<String, dynamic>) {
        final AppUser user = AppUser.fromJson(response);
        await ref.read(userManagerProvider).authenticate(ref, user);
        return user;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<AppUser> signup(RegisterModel? model, Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response =
          await apiManager.post(ref, ApiEndPoint.register, model!.toJson());
      if (response is Map<String, dynamic>) {
        final AppUser user = AppUser.fromJson(response);
        await ref.read(userManagerProvider).authenticate(ref, user);
        return user;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future signout(Ref ref) async {
    try {
      final userManager = ref.read(userManagerProvider);
      await userManager.signout(ref);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateProfile(Ref ref, File? originalFile) async {
    try {
      if (originalFile == null) {
        return true;
      }
      final userManager = ref.read(userManagerProvider);
      final apiManager = ref.read(apiManagerProvider);
      final file = await Utils.bakeImageOrientation(originalFile);
      if (file == null) {
        throw "Some error occured while baking image";
      }
      final token = userManager.user?.accessToken;
      String fileName = file.path.split('/').last;
      String extension = fileName.split('.').last;
      final response = await apiManager.patchMultipart(
        ref,
        ApiEndPoint.userProfileUpdate,
        multipartData: {
          'image': await MultipartFile.fromFile(file.path,
              filename: fileName,
              contentType: DioMediaType('image', extension)),
        },
        token: token,
      );
      if (response is Map<String, dynamic>) {
        final AppUser appUser = ref.read(userManagerProvider).user!;
        appUser.user!.profileUrl = response["data"]["profile_url"];
        userManager.authenticate(ref, appUser);
      }
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> fetchUser(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response =
          await apiManager.get(ref, ApiEndPoint.usersMe, token: token);
      final User user;

      if (response is Map<String, dynamic>) {
        user = User.fromJson(response["user"]);
        final AppUser appUser = ref.read(userManagerProvider).user!;
        if (appUser.user != null) {
          appUser.user?.copy(user);
        } else {
          appUser.user = user;
        }
        ref.read(userManagerProvider).authenticate(ref, appUser);
        return true;
      }

      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> updatUser(Ref ref, User? user) async {
    try {
      if (user == null) {
        return true;
      }
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.patch(
        ref,
        ApiEndPoint.usersPost,
        user.toJson(),
        token: token,
      );
      if (response is Map<String, dynamic>) {
        user = User.fromJson(response["data"]["user"]);
        final AppUser appUser = ref.read(userManagerProvider).user!;
        if (appUser.user != null) {
          appUser.user?.copy(user);
        } else {
          appUser.user = user;
        }
        ref.read(userManagerProvider).authenticate(ref, appUser);
        return true;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<CustomFields>> fetchAllCustomFields(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = (await apiManager.get(ref, ApiEndPoint.customFields,
          token: token))["data"];
      if (response is List) {
        List<CustomFields> customFields = [];
        for (var element in response) {
          customFields.add(CustomFields.fromJson(element));
        }
        customFields.removeWhere((element) => !element.isVisible);
        return customFields;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> updatePassword(Ref ref,
      {required String oldPassword, required String newPassword}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      await apiManager.patch(
        ref,
        ApiEndPoint.updatePassword,
        {
          "current_password": oldPassword,
          "new_password": newPassword,
        },
        token: token,
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> deleteAccount(Ref ref, {required String password}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      await apiManager.patch(
        ref,
        ApiEndPoint.deleteAccount,
        token: token,
        {
          "password": password,
        },
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<WalletInfo>> walletInfo(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = (await apiManager.get(ref, ApiEndPoint.usersWallets,
          token: token))["data"];
      if (response is List) {
        List<WalletInfo> wallets = [];
        for (var element in response) {
          wallets.add(WalletInfo.fromJson(element));
        }
        return wallets;
      }
      throw "Some error occured";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<TransactionModel>> transactions(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = (await apiManager.get(ref, ApiEndPoint.transactions,
          token: token))["data"]["transactions"];
      if (response is List) {
        List<TransactionModel> wallets = [];
        for (var element in response) {
          wallets.add(TransactionModel.fromJson(element));
        }
        return wallets;
      }
      throw "Some error occurred";
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<void> saveFCMToken(Ref ref, String fcmToken) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final res = await apiManager.post(
        ref,
        ApiEndPoint.fcmToken,
        token: token,
        {
          "token": fcmToken,
        },
      );
      return res;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool?> resetPassword(Ref ref, String email) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response =
          await apiManager.post(ref, ApiEndPoint.userRecoverPassword, {
        'email': email,
      });

      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool?> updateRecoveryPassword(
      Ref ref, String email, String password, String token) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response = await apiManager.post(
          ref,
          ApiEndPoint.userUpdateRecoverPassword,
          {'email': email, "recovery_token": token, "new_password": password});

      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<UserAssessment> fetchUserAssessment(Ref ref, int id) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;
      final response = await apiManager.get(ref, ApiEndPoint.usersAssessments,
          token: token, pathParams: [id.toString()]);
      return UserAssessment.fromJson(response["data"]);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepo authRepo(Ref ref) {
  return AuthRepo();
}

@riverpod
Future<AppUser?> loginUser(
    LoginUserRef ref, String email, String password) async {
  return ref.watch(authRepoProvider).signIn(email, password, ref);
}

@riverpod
Future<AppUser?> registerUser(RegisterUserRef ref, RegisterModel model) async {
  return ref.watch(authRepoProvider).signup(model, ref);
}

@Riverpod(keepAlive: true)
Future<bool> fetchUser(FetchUserRef ref) async {
  return ref.watch(authRepoProvider).fetchUser(ref);
}

@riverpod
Future<bool> updateUser(Ref ref, User? user) async {
  return ref.watch(authRepoProvider).updatUser(ref, user);
}

@riverpod
Future<bool> updateProfile(Ref ref, File? file) async {
  return ref.watch(authRepoProvider).updateProfile(ref, file);
}

@Riverpod(keepAlive: true)
Future<List<CustomFields>> fetchAllCustomFields(
    FetchAllCustomFieldsRef ref) async {
  return ref.watch(authRepoProvider).fetchAllCustomFields(ref);
}

@riverpod
Future<(bool?, bool?)> updatePictureAndUser(
  UpdatePictureAndUserRef ref,
  File? file,
  User? user,
) async {
  final results = await Future.wait([
    ref.watch(updateProfileProvider(file).future),
    ref.watch(updateUserProvider(user).future),
  ]);

  return (results[0] as bool?, results[1] as bool?);
}

@riverpod
Future<UserAssessment> fetchUserAssessment(Ref ref, {required int id}) async {
  return ref.watch(authRepoProvider).fetchUserAssessment(ref, id);
}

@riverpod
Future<bool> updatePassword(Ref ref,
    {required String oldPassword, required String newPassword}) async {
  return ref
      .watch(authRepoProvider)
      .updatePassword(ref, oldPassword: oldPassword, newPassword: newPassword);
}

@riverpod
Future<bool> deleteAccount(Ref ref, {required String password}) async {
  return ref.watch(authRepoProvider).deleteAccount(ref, password: password);
}

@riverpod
Future<List<WalletInfo>> walletInfo(WalletInfoRef ref) async {
  return ref.watch(authRepoProvider).walletInfo(ref);
}

@riverpod
Future<List<TransactionModel>> transactions(TransactionsRef ref) async {
  return ref.watch(authRepoProvider).transactions(ref);
}

@riverpod
Future<void> saveFCMToken(SaveFCMTokenRef ref, String token) async {
  return ref.watch(authRepoProvider).saveFCMToken(ref, token);
}

@riverpod
Future<bool?> recoverPassword(RecoverPasswordRef ref, String email) async {
  return ref.watch(authRepoProvider).resetPassword(ref, email);
}

@riverpod
Future<bool?> updateRecoveryPassword(UpdateRecoveryPasswordRef ref,
    {required String email, required String password, required String token}) {
  return ref
      .watch(authRepoProvider)
      .updateRecoveryPassword(ref, email, password, token);
}
