import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/assessment_req_model.dart';
import 'package:acepadel/models/assessment_res_model.dart';
import 'package:acepadel/models/events_model.dart';
import 'package:acepadel/models/lesson_models.dart';
import 'package:acepadel/models/open_match_model.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/models/service_waiting_players.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/cancellation_policy_model.dart';
import '../models/coach_list_model.dart';
import '../models/lesson_model_new.dart';
import 'club_repo.dart';

part 'play_repo.g.dart';

enum RequestServiceType {
  booking,
  lesson,
  event;

  String get value {
    switch (this) {
      case booking:
        return "booking";
      case lesson:
        return "lesson";
      case event:
        return "event";
    }
  }
}

class PlayRepo {
  Future<List<CoachListModel>> fetchAllCoaches(Ref ref) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;

      final response = await apiManager.get(
        ref,
        ApiEndPoint.coachList,
        token: token,
      );
      if (response['data'] == null ||
          response['data']["CoachesDetails"] == null) {
        return [];
      }
      final data = response['data']["CoachesDetails"] as List;
      return data.map((e) => CoachListModel.fromJson(e)).toList();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'] ?? e;
      }
      rethrow;
    }
  }

  Future<List<OpenMatchModel>> fetchOpenMatches(Ref ref,
      {required DateTime startDate,
      required DateTime endDate,
      required List<int> locationIds,
      required double minLevel,
      required double maxLevel}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final Map<String, dynamic> queryParams = {
        "start_date": startDate.format(kFormatForAPI),
        "end_date": endDate.format(kFormatForAPI),
        "min_level": minLevel,
        "max_level": maxLevel,
      };

      List<int> checkLocation = [...locationIds];
      checkLocation.remove(-1);
      if (checkLocation.isNotEmpty) {
        queryParams["location_id"] = checkLocation.join(",");
      }
      final response = await apiManager.get(
        ref,
        ApiEndPoint.openMatches,
        token: token,
        queryParams: queryParams,
      );
      if (response['data'] == null || response['data']["services"] == null) {
        return [];
      }
      final data = response['data']["services"] as List;

      final list = data.map((e) => OpenMatchModel.fromJson(e)).toList();
      list.sort((a, b) => a.bookingStartTime.compareTo(b.bookingStartTime));
      list.removeWhere((element) => element.isPast);
      return list;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'] ?? e;
      }
      rethrow;
    }
  }

  Future<List<EventsModel>> fetchEvents(Ref ref,
      {required DateTime startDate,
      required DateTime endDate,
      required List<int> locationIds,
      required double minLevel,
      required double maxLevel}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      Map<String, dynamic> queryParams = {
        "start_date": startDate.format(kFormatForAPI),
        "end_date": endDate.format(kFormatForAPI),
        "min_level": double.parse(minLevel.toStringAsFixed(2)),
        "max_level": double.parse(maxLevel.toStringAsFixed(2))
      };
      if (locationIds.isNotEmpty) {
        queryParams["location_id"] =
            locationIds.map((e) => e.toString()).toList();
      }
      final response = await apiManager.get(
        ref,
        ApiEndPoint.events,
        token: token,
        queryParams: queryParams,
      );
      if (response['data'] == null || response['data']["services"] == null) {
        return [];
      }
      final data = response['data']["services"] as List;
      List<EventsModel> list =
          data.map((e) => EventsModel.fromJson(e)).toList();
      list.sort((a, b) => a.bookingStartTime.compareTo(b.bookingStartTime));
      list.removeWhere((element) => element.isPast);
      return list;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<LessonsModel>> fetchLessonsList(Ref ref,
      {required DateTime startDate,
      required DateTime endDate,
      required List<int> locationIds,
      required List<int> coachesIds}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      Map<String, dynamic> queryParams = {
        "start_date": startDate.format(kFormatForAPI),
        "end_date": endDate.format(kFormatForAPI),
      };
      if (locationIds.isNotEmpty) {
        queryParams["location_id"] =
            locationIds.map((e) => e.toString()).toList();
      }
      coachesIds.remove(-1);
      if (coachesIds.isNotEmpty) {
        queryParams["coach_id"] = coachesIds.join(",");
      }
      final response = await apiManager.get(
        ref,
        ApiEndPoint.lessons,
        token: token,
        queryParams: queryParams,
      );
      if (response['data'] == null || response['data']["lessons"] == null) {
        return [];
      }
      final data = response['data']["lessons"] as List;
      return data.map((e) => LessonsModel.fromJson(e)).toList();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<ServiceDetail> fetchService(Ref ref, int serviceID) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.services,
        token: token,
        pathParams: [serviceID.toString()],
      );
      if (response['data'] == null || response['data']["service"] == null) {
        throw "SERVICE_NOT_FOUND";
      }
      final data = response['data']["service"];
      return ServiceDetail.fromJson(data);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<double?> joinService(Ref ref, int id,
      {int? playerId,
      required int position,
      required bool isEvent,
      required bool isOpenMatch,
      required bool isLesson,
      required bool isDouble,
      required bool isReserve,
      bool isApprovalNeeded = false}) async {
    try {
      if (isEvent && isOpenMatch) {
        throw "Either event or open match";
      }
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      Map<String, dynamic> data = {
        "request_type": isReserve ? "Reserved" : "Join",
      };
      if (playerId != null) {
        data["player_id"] = playerId;
      }
      if (isEvent) {
        data["service_type"] = "Event";
        data["event_type"] = !isDouble ? "Single" : "Double";
        if (isDouble) {
          data["position"] = position;
        }
      } else if (isOpenMatch) {
        data["service_type"] = "Booking";
        data["booking_type"] = "Open Match";
        data["position"] = position;
      } else if (isLesson) {
        data["service_type"] = "Lesson";
      }

      final response = await apiManager.post(
        ref,
        ApiEndPoint.joinService,
        isV2Version: true,
        data,
        token: token,
        pathParams: [id.toString()],
      );
      if (isApprovalNeeded) {
        return -1;
      }
      return double.tryParse(response['data']['price'].toString()) ?? 0;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool?> cancelService(Ref ref, int id) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      await apiManager.patch(ref, ApiEndPoint.serviceCancel, {},
          token: token,
          pathParams: [
            id.toString(),
          ]);
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<ServiceWaitingPlayers>> fetchWaitingList(
      Ref ref, int id, RequestServiceType requestServiceType) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.serviceWaitingList,
        queryParams: {"service_type": requestServiceType.value},
        token: token,
        pathParams: [id.toString()],
      );
      final data = response['data'] as List;
      return data.map((e) => ServiceWaitingPlayers.fromJson(e)).toList();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> approveWithdrawPlayer(Ref ref,
      {bool isApprove = true,
      required int serviceID,
      required int playerID}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final status = isApprove ? "approve" : "remove";
      await apiManager.patch(
        ref,
        ApiEndPoint.serviceApprovePlayer,
        {},
        token: token,
        pathParams: [status, serviceID.toString(), playerID.toString()],
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<CancellationPolicy> cancellationPolicy(Ref ref, int id) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;

      final response = await apiManager
          .get(ref, ApiEndPoint.cancellationPolicy, token: token, pathParams: [
        id.toString(),
      ]);
      return CancellationPolicy.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> deleteReserved(Ref ref, int serviceID, int reservedID) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      await apiManager.delete(
        ref,
        ApiEndPoint.serviceDeleteReservedPlayer,
        token: token,
        pathParams: [serviceID.toString(), reservedID.toString()],
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> submitAssessment(
      Ref ref, AssessmentReqModel model, int serviceID) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await apiManager.post(
        ref,
        ApiEndPoint.serviceSubmitAssessment,
        model.toJson(),
        token: token,
        pathParams: [serviceID.toString()],
      );
      myPrint(response.toString());
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<LessonModelNew> fetchLessons(Ref ref,
      {required DateTime startTime,
      DateTime? endTime,
      required int? duration,
      // required int? duration,
      required String sportName,
      required List<int> coachId}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      // final date = ref.watch(selectedDateLessonProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      // final formattedDate = DateTime.now().copyWith(
      //     year: date.dateTime.year,
      //     month: date.dateTime.month,
      //     day: date.dateTime.day);
      // final DateTime now = DateTime.now();

      Map<String, dynamic> queryParams = {
        "date": startTime,
        "sport_name": sportName,
        "coach_id": coachId,
        // "current_time" : now
      };
      if (duration != null) {
        queryParams["duration"] = duration;
      }
      if(endTime != null) {
        queryParams["end_date"] = endTime;
      }
      final response = await apiManager.get(
        ref,
        ApiEndPoint.bookingLessons,
        isV2Version: true,
        token: token,
        queryParams: queryParams,
      );
      if (response == "" || response == null) {
        return LessonModelNew();
      }
      return LessonModelNew.fromJson(response);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }


  Future<List<String>> fetchBlockedCoaches(Ref ref,
      {required DateTime startDate,
        required DateTime endDate,
        required String sportName}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken;

      final response = await apiManager.get(
        ref,
        ApiEndPoint.coachesOff,
        queryParams: {
          'start_date': startDate.toIso8601String().split('T').first,
          'end_date': endDate.toIso8601String().split('T').first,
          'sport_name': sportName,
        },
        token: token,
      );

      final data = response['data'];
      if (data == null || data['UnavailableDates'] == null) {
        return [];
      }

      final unavailableDates = List<String>.from(data['UnavailableDates']);
      return unavailableDates;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'] ?? e;
      }
      rethrow;
    }
  }

  Future<String?> joinWaitingList(Ref ref,
      {required int position, required int serviceId}) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      Map<String, dynamic> data = {"position": position};

      final response = await apiManager.post(
        ref,
        ApiEndPoint.joinEventWaitingList,
        data,
        token: token,
        pathParams: [serviceId.toString()],
      );
      throw response['message'];
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<AssessmentResModel> fetchAssessment(Ref ref, int serviceID) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await apiManager.get(
        ref,
        ApiEndPoint.serviceAssessment,
        token: token,
        pathParams: [serviceID.toString()],
      );
      return AssessmentResModel.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@riverpod
PlayRepo playRepo(Ref ref) => PlayRepo();

@riverpod
Future<List<OpenMatchModel>> openMatchesList(OpenMatchesListRef ref,
    {required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    required double minLevel,
    required double maxLevel}) async {
  return ref.read(playRepoProvider).fetchOpenMatches(ref,
      startDate: startDate,
      endDate: endDate,
      locationIds: locationIDs,
      minLevel: minLevel,
      maxLevel: maxLevel);
}

@riverpod
Future<List<CoachListModel>> fetchAllCoaches(FetchAllCoachesRef ref) async {
  return ref.read(playRepoProvider).fetchAllCoaches(ref);
}

@riverpod
Future<List<EventsModel>> eventsList(EventsListRef ref,
    {required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    required double minLevel,
    required double maxLevel}) async {
  return ref.read(playRepoProvider).fetchEvents(ref,
      startDate: startDate,
      endDate: endDate,
      locationIds: locationIDs,
      minLevel: minLevel,
      maxLevel: maxLevel);
}

@riverpod
Future<List<LessonsModel>> lessonsList(LessonsListRef ref,
    {required DateTime startDate,
    required DateTime endDate,
    List<int> locationIDs = const [],
    List<int> coachesIds = const []}) async {
  return ref.read(playRepoProvider).fetchLessonsList(
        ref,
        startDate: startDate,
        endDate: endDate,
        locationIds: locationIDs,
        coachesIds: coachesIds,
      );
}

@riverpod
Future<ServiceDetail> fetchServiceDetail(
    FetchServiceDetailRef ref, int serviceID) async {
  return ref.read(playRepoProvider).fetchService(ref, serviceID);
}

@riverpod
Future<double?> joinService(JoinServiceRef ref, int id,
    {int? playerId,
    required int position,
    required bool isEvent,
    required bool isOpenMatch,
    required bool isDouble,
    required bool isReserve,
    required bool isLesson,
    bool isApprovalNeeded = false}) async {
  return ref.read(playRepoProvider).joinService(
        ref,
        id,
        position: position,
        playerId: playerId,
        isEvent: isEvent,
        isOpenMatch: isOpenMatch,
        isDouble: isDouble,
        isReserve: isReserve,
        isLesson: isLesson,
        isApprovalNeeded: isApprovalNeeded,
      );
}

@riverpod
Future<bool?> cancelService(CancelServiceRef ref, int id) async {
  return ref.read(playRepoProvider).cancelService(ref, id);
}

@riverpod
Future<List<ServiceWaitingPlayers>> fetchServiceWaitingPlayers(
    FetchServiceWaitingPlayersRef ref,
    int id,
    RequestServiceType requestServiceType) async {
  return ref
      .read(playRepoProvider)
      .fetchWaitingList(ref, id, requestServiceType);
}

@riverpod
Future<bool> approvePlayer(ApprovePlayerRef ref,
    {bool isApprove = true,
    required int serviceID,
    required int playerID}) async {
  return ref.read(playRepoProvider).approveWithdrawPlayer(ref,
      isApprove: isApprove, serviceID: serviceID, playerID: playerID);
}

@riverpod
Future<bool> deleteReserved(
    DeleteReservedRef ref, int serviceID, int reservedID) async {
  return ref.read(playRepoProvider).deleteReserved(ref, serviceID, reservedID);
}

@riverpod
Future<bool> submitAssessment(SubmitAssessmentRef ref,
    {required AssessmentReqModel model, required int serviceID}) async {
  return ref.read(playRepoProvider).submitAssessment(ref, model, serviceID);
}

@riverpod
Future<AssessmentResModel> fetchAssessment(
    FetchAssessmentRef ref, int serviceID) async {
  return ref.read(playRepoProvider).fetchAssessment(ref, serviceID);
}

@riverpod
Future<LessonModelNew> lessonsSlot(LessonsSlotRef ref,
    {required DateTime startTime,
    DateTime? endTime,
    required int? duration,
    required List<int> coachId,
    required String sportName}) async {
  return ref.read(playRepoProvider).fetchLessons(ref,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      coachId: coachId,
      sportName: sportName);
}

@riverpod
Future<String?> joinWaitingList(JoinWaitingListRef ref,
    {required int position, required int serviceId}) async {
  return ref
      .read(playRepoProvider)
      .joinWaitingList(ref, serviceId: serviceId, position: position);
}

@riverpod
Future<CancellationPolicy> cancellationPolicy(
    CancellationPolicyRef ref, int id) async {
  return ref.read(playRepoProvider).cancellationPolicy(ref, id);
}
@riverpod
Future<List<String>> fetchBlockedCoaches(FetchBlockedCoachesRef ref,
    {required DateTime startDate,
      required DateTime endDate,
      required String sportName}) async {
  return ref.read(playRepoProvider).fetchBlockedCoaches(ref,
      startDate: startDate, endDate: endDate, sportName: sportName);
}
