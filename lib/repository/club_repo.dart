import 'package:acepadel/screens/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/app_update_model.dart';
import 'package:acepadel/models/club_locations.dart';
import 'package:acepadel/models/court_booking.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/utils/dubai_date_time.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/voucher_model.dart';

part 'club_repo.g.dart';

class CourtRepo {
  Future<List<ClubLocationData>> getClubLocations(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response = await apiManager.get(ref, ApiEndPoint.locations);

      final List<ClubLocationData> locations = [];
      for (final item in response['data']) {
        locations.add(ClubLocationData.fromJson(item));
      }
      return locations;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<CourtBookingData?> getCourtBooking(Ref ref,
      {required String sport}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final date = ref.watch(selectedDateProvider);
      // final sport = ref.read(selectedSportProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final formattedDate = date.dateTime.format(kFormatForAPI);
      // final sportName = sport.name.toLowerCase().capitalizeFirst;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.courtBooking,
        token: token,
        queryParams: {
          "date": formattedDate,
          "sport_name": sport,
        },
      );
      final tempDate = ref.read(selectedDateProvider);
      if (tempDate.dateTime != date.dateTime) {
        return null;
      }
      return CourtBookingData.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }

      rethrow;
    }
  }

  Future<List<VoucherModel>> getVouchersApi(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final apiManager = ref.read(apiManagerProvider);
      final response =
          await apiManager.get(ref, ApiEndPoint.getVouchers, token: token);

      final List<VoucherModel> vouchers = [];
      for (final item in response['data']['vouchersDetails']) {
        vouchers.add(VoucherModel.fromJson(item));
      }
      return vouchers;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }

      rethrow;
    }
  }

  Future<AppUpdateModel?> checkUpdate(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final response = await apiManager.get(ref, ApiEndPoint.appUpdates);
      return AppUpdateModel.fromJson(response['data']);
    } catch (e) {
      return null;
    }
  }
}

@riverpod
CourtRepo clubRepo(Ref ref) => CourtRepo();

@Riverpod(keepAlive: true)
Future<List<ClubLocationData>?> clubLocations(Ref ref) async {
  return ref.read(clubRepoProvider).getClubLocations(ref);
}

@Riverpod(keepAlive: true)
Future<CourtBookingData?> getCourtBooking(Ref ref) {
  final sport = ref.watch(selectedSportProvider);
  if (sport == null || (sport.sportName?.isEmpty ?? true)) {
    return Future.value(null);
  }
  return ref
      .read(clubRepoProvider)
      .getCourtBooking(ref, sport: sport.sportName!);
}

@Riverpod(keepAlive: true)
Future<List<VoucherModel>> getVouchersApi(Ref ref) {
  return ref.read(clubRepoProvider).getVouchersApi(ref);
}

@Riverpod(keepAlive: true)
class SelectedDate extends _$SelectedDate {
  @override
  DubaiDateTime build() {
    final now = DateTime.now();
    return DubaiDateTime.custom(
      now.year,
      now.month,
      now.day,
    );
  }

  set selectedDate(DubaiDateTime date) {
    state = date;
  }

  DubaiDateTime get selectedDate => state;
}

@Riverpod(keepAlive: true)
class SelectedDateLesson extends _$SelectedDateLesson {
  @override
  DubaiDateTime build() {
    final now = DateTime.now();
    return DubaiDateTime.custom(
      now.year,
      now.month,
      now.day,
    );
  }

  set selectedDate(DubaiDateTime date) {
    state = date;
  }

  DubaiDateTime get selectedDate => state;
}

@riverpod
Future<AppUpdateModel?> checkUpdate(Ref ref) async {
  if (kIsWeb) {
    return null;
  }
  return ref.read(clubRepoProvider).checkUpdate(ref);
}
