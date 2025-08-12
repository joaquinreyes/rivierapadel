import 'dart:async';

import 'package:acepadel/models/active_memberships.dart';
import 'package:acepadel/models/multi_booking_model.dart';
import 'package:acepadel/models/total_hours.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/court_booking.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/court_price_model.dart';
import '../models/lesson_model_new.dart';

part 'booking_repo.g.dart';

enum BookingRequestType {
  addToCart,
  processingBooking;

  String get value {
    switch (this) {
      case addToCart:
        return "ADD_TO_CART";
      case processingBooking:
        return "PROCESS_BOOKING";
    }
  }
}

enum TransactionRequestType {
  cart,
  normal;

  String get value {
    switch (this) {
      case cart:
        return "CART";
      case normal:
        return "NORMAL";
    }
  }
}

enum CourtPriceRequestType {
  join,
  booking,
  lesson;

  String get value {
    switch (this) {
      case join:
        return "join_service";
      case booking:
        return "booking_service";
      case lesson:
        return "lesson_service";
    }
  }
}

class BookingRepo {
  Future<double?> bookCourt(Ref ref,
      {required Bookings booking,
      required int courtID,
      required DateTime dateTime,
      required bool isOpenMatch,
      required int reservedPlayers,
      required BookingRequestType requestType,
      String? organizerNote,
      double? openMatchMinLevel,
      bool? isFriendlyMatch,
      double? openMatchMaxLevel,
      bool? approvalNeeded}) async {
    try {
      final startTime = dateTime.format("HH:mm:ss");
      final endTime =
          dateTime.add(Duration(minutes: booking.duration!)).format("HH:mm:ss");
      final date = dateTime.format(kFormatForAPI);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final data = {
        "court_id": courtID,
        "booking_id": booking.id,
        "location_id": booking.location!.id,
        "start_time": startTime,
        "end_time": endTime,
        "date": date,
        "is_open_match": isOpenMatch,
        "reserved_players_count": reservedPlayers,
      };
      if (isOpenMatch) {
        data['organizer_notes'] = organizerNote;
        data['friendly_match'] = isFriendlyMatch;
        data['approve_before_join'] = approvalNeeded ?? false;
        if (openMatchMinLevel != null) {
          data['open_match_options'] = {
            "min_level": openMatchMinLevel,
            "max_level": openMatchMaxLevel,
          };
        }
      }

      final Map<String, dynamic> queryParams = {};
      queryParams['request_type'] = requestType.value;

      final response = await ref.read(apiManagerProvider).post(
            isV2Version: true,
            queryParams: queryParams,
            ref,
            ApiEndPoint.courtBookingPost,
            data,
            token: token,
          );
      if (requestType == BookingRequestType.addToCart) {
        return response['data']['savedBookingCart']['total_price'].toDouble();
      }
      return response['data']['price'].toDouble();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<UserBookings>> fetchUserBooking(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.userBookings,
            token: token,
          );
      final List<UserBookings> bookings = [];
      for (final booking in response['data']["bookings"]) {
        bookings.add(UserBookings.fromJson(booking));
      }
      return bookings;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<UserBookings>> fetchUserBookingWaitingList(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.userBookingsWaitingList,
            token: token,
          );
      final List<UserBookings> bookings = [];
      for (final booking in response['data']["bookings"]) {
        bookings.add(UserBookings.fromJson(booking));
      }
      return bookings;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<dynamic> fetchCourtPrice(Ref ref,
      {required int serviceId,
      required CourtPriceRequestType requestType,
      required DateTime dateTime,
      required List courtId,
      required int? coachId,
      required LessonVariants? lessonVariant,
      required bool isOpenMatch,
      required int reserveCounter,
      required int durationInMin}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      if (isOpenMatch) {
        final data = {"reserve_counter": reserveCounter};

        final response = await ref.read(apiManagerProvider).patch(
          ref,
          ApiEndPoint.openMatchCalculatePriceApi,
          data,
          token: token,
          pathParams: [serviceId.toString()],
        );
        return response["message"];
      }

      final startTime = dateTime.format("HH:mm:ss");
      final endTime =
          dateTime.add(Duration(minutes: durationInMin)).format("HH:mm:ss");
      final date = dateTime.format(kFormatForAPI);
      final data = {
        "request_type": requestType.value,
        "service_id": serviceId,
        "booking_details": {
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
          "courts": courtId
        }
      };
      if (lessonVariant != null) {
        data['variant_id'] = lessonVariant.id ?? 0;

      }
      if (coachId != null) {
        data["coach_id"] = coachId;
      }
      final response = await ref.read(apiManagerProvider).post(
            ref,
            ApiEndPoint.courtPricePost,
            data,
            token: token,
          );
      return CourtPriceModel.fromJson(response['data']);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<MultipleBookings>> fetchBookingCartList(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.userBookingCartList,
            token: token,
          );
      final List<MultipleBookings> bookings = [];
      for (final booking in response) {
        bookings.add(MultipleBookings.fromJson(booking));
      }
      bookings.sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
      return bookings;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<bool> deleteCartBooking(Ref ref, String bookingId) async {
    try {
      final apiManager = ref.read(apiManagerProvider);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      await apiManager.delete(
        ref,
        ApiEndPoint.deleteCartBooking,
        token: token,
        pathParams: [bookingId],
      );
      return true;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<int> fetchServiceIDWithTransactionID(
    Ref ref, {
    required String orderID,
    required String statusCode,
    required TransactionRequestType requestType,
    required String transactionStatus,
  }) async {
    final token = ref.read(userManagerProvider).user?.accessToken;
    if (token == null) {
      throw Exception('No access token available');
    }

    // Compute deadline 15 seconds from now.
    final deadline = DateTime.now().add(const Duration(seconds: 17));
    // Initial wait
    await Future.delayed(const Duration(seconds: 4));

    // Polling loop
    while (DateTime.now().isBefore(deadline)) {
      try {
        final response = await ref.read(apiManagerProvider).get(
          ref,
          ApiEndPoint.transaction,
          token: token,
          queryParams: {
            'order_id': orderID,
            'status_code': statusCode,
            'transaction_status': transactionStatus,
            'request_type': requestType.value,
          },
        );

        // If it's a cart request, shortcut out
        if (requestType == TransactionRequestType.cart) {
          return -1;
        }

        // If we got a valid service ID, return it
        final serviceId = response['data']?['service']?['id'];
        if (serviceId is int) {
          return serviceId;
        }

        // Otherwise, wait before retrying
      } catch (e) {
        // If the API itself returns an error payload, propagate it
        if (e is Map<String, dynamic> && e.containsKey('message')) {
          if (e['message'] != "Transaction not found") {
            throw e['message'];
          }
        }
        // rethrow;
      }

      // Wait 2 seconds between polls
      await Future.delayed(const Duration(seconds: 3));
    }

    // If we reach here, we've timed out
    throw "Transaction not found";
  }

  Future<TotalHours> fetchUserHours(Ref ref) {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      return ref
          .read(apiManagerProvider)
          .get(ref, ApiEndPoint.usersTotalHours, token: token)
          .then((response) => TotalHours.fromJson(response['data']));
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<List<ActiveMemberships>> fetchActiveMemberships(Ref ref) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.usersActiveMembership,
            token: token,
          );
      final List<ActiveMemberships> memberships = [];

      for (final membership in response['data']["activeMemberships"]) {
        memberships.add(ActiveMemberships.fromJson(membership));
      }
      return memberships;
    } catch (e) {
      return [];
    }
  }

  Future<bool> addToCalendar(
      String title, DateTime startDate, DateTime endDate) async {
    try {
      final Event event = Event(
        title: title,
        startDate: startDate,
        endDate: endDate,
      );
      await Add2Calendar.addEvent2Cal(event);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookLessonCourt(
    Ref ref, {
    required int lessonTime,
    required int courtId,
    required int lessonId,
    required int coachId,
    required int locationId,
    required LessonVariants? lessonVariant,
    required DateTime dateTime,
  }) async {
    try {
      final startTime = dateTime.format("HH:mm:ss");
      final endTime =
          dateTime.add(Duration(minutes: lessonTime)).format("HH:mm:ss");
      final date = dateTime.format(kFormatForAPI);
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final data = {
        "court_id": courtId,
        "lesson_id": lessonId,
        "coach_id": coachId,
        "location_id": locationId,
        "start_time": startTime,
        "end_time": endTime,
        "date": date
      };
      if (lessonVariant != null) {
        data['variant_id'] = lessonVariant.id ?? 0;
      }

      final response = await ref.read(apiManagerProvider).post(
          ref, ApiEndPoint.bookingLessons, data,
          isV2Version: true,
          token: token,
          queryParams: {"request_type": "PROCESS_BOOKING"});
      return response['data']['price'].toDouble();
    } catch (e, _) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }

      rethrow;
    }
  }

  Future<double?> upgradeBookingToOpen(Ref ref,
      {required Bookings booking,
      required int reservedPlayers,
      String? organizerNote,
      double? openMatchMinLevel,
      bool? isFriendlyMatch,
      double? openMatchMaxLevel,
      bool? approvalNeeded}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;
      final Map<String, dynamic> data = {
        "reserved_players_count": reservedPlayers
      };
      data['organizer_notes'] = organizerNote;
      data['friendly_match'] = isFriendlyMatch;
      data['approve_before_join'] = approvalNeeded ?? false;
      if (openMatchMinLevel != null) {
        data['open_match_options'] = {
          "min_level": openMatchMinLevel,
          "max_level": openMatchMaxLevel,
        };
      }

      final response = await ref.read(apiManagerProvider).patch(
            ref,
            pathParams: [(booking.id ?? 0).toString()],
            ApiEndPoint.upgradeBookingToOpen,
            data,
            token: token,
          );
      return response['data']['service_id'].toDouble();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<double?> fetchChatCount(Ref ref, {required int matchId}) async {
    try {
      final token = ref.read(userManagerProvider).user?.accessToken!;

      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.fetchChatCount,
            pathParams: [
              matchId.toString(),
            ],
            token: token,
          );
      return double.tryParse(response['data'].toString());
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@riverpod
BookingRepo bookingRepo(Ref ref) => BookingRepo();

@riverpod
Future<double?> bookCourt(BookCourtRef ref,
    {required Bookings booking,
    required int courtID,
    required DateTime dateTime,
    required bool isOpenMatch,
    required int reservedPlayers,
    required BookingRequestType requestType,
    String? organizerNote,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded}) async {
  return ref.read(bookingRepoProvider).bookCourt(ref,
      requestType: requestType,
      booking: booking,
      courtID: courtID,
      dateTime: dateTime,
      isOpenMatch: isOpenMatch,
      reservedPlayers: reservedPlayers,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      approvalNeeded: approvalNeeded);
}

@riverpod
Future<dynamic> fetchCourtPrice(FetchCourtPriceRef ref,
    {required int serviceId,
    required CourtPriceRequestType requestType,
    required DateTime dateTime,
    required List courtId,
    bool? isOpenMatch,
    required int? coachId,
    int? reserveCounter,
    LessonVariants? lessonVariant,
    required int durationInMin}) async {
  return ref.read(bookingRepoProvider).fetchCourtPrice(ref,
      requestType: requestType,
      serviceId: serviceId,
      isOpenMatch: isOpenMatch ?? false,
      reserveCounter: reserveCounter ?? 0,
      courtId: courtId,
      lessonVariant: lessonVariant,
      dateTime: dateTime,
      coachId: coachId,
      durationInMin: durationInMin);
}

@riverpod
Future<List<UserBookings>> fetchUserBooking(FetchUserBookingRef ref) {
  return ref.read(bookingRepoProvider).fetchUserBooking(ref);
}

@riverpod
Future<List<UserBookings>> fetchUserBookingWaitingList(
    FetchUserBookingWaitingListRef ref) {
  return ref.read(bookingRepoProvider).fetchUserBookingWaitingList(ref);
}

@riverpod
Future<List<UserBookings>> fetchUserAllBookings(
    FetchUserAllBookingsRef ref) async {
  final results = await Future.wait([
    ref.refresh(fetchUserBookingProvider.future),
    // ref.refresh(fetchUserBookingWaitingListProvider.future),
  ]);

  final List<UserBookings> bookings = [];
  bookings.addAll(results[0]);
  // bookings.addAll(results[1]);
  //SORT BOOKINGS BY DATE, in descending order
  bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  return bookings;
}

@riverpod
Future<int> fetchServiceIDWithTransactionID(
    FetchServiceIDWithTransactionIDRef ref,
    {required String orderID,
    required String statusCode,
    required TransactionRequestType requestType,
    required String transactionStatus}) {
  return ref.read(bookingRepoProvider).fetchServiceIDWithTransactionID(ref,
      orderID: orderID,
      statusCode: statusCode,
      requestType: requestType,
      transactionStatus: transactionStatus);
}

@riverpod
Future<TotalHours> playedHours(PlayedHoursRef ref) {
  return ref.read(bookingRepoProvider).fetchUserHours(ref);
}

@riverpod
Future<List<ActiveMemberships>> activeMembership(ActiveMembershipRef ref) {
  return ref.read(bookingRepoProvider).fetchActiveMemberships(ref);
}

@riverpod
Future<bool> addToCalendar(AddToCalendarRef ref,
    {required String title,
    required DateTime startDate,
    required DateTime endDate}) {
  return ref.read(bookingRepoProvider).addToCalendar(title, startDate, endDate);
}

@riverpod
Future<List<MultipleBookings>> fetchBookingCartList(
    FetchBookingCartListRef ref) {
  return ref.read(bookingRepoProvider).fetchBookingCartList(ref);
}

@riverpod
Future<bool> deleteCart(DeleteCartRef ref, String bookingId) async {
  return ref.read(bookingRepoProvider).deleteCartBooking(ref, bookingId);
}

@riverpod
Future<double?> fetchChatCount(FetchChatCountRef ref,
    {required int matchId}) async {
  return ref.read(bookingRepoProvider).fetchChatCount(ref, matchId: matchId);
}

@riverpod
Future<void> bookLessonCourt(
  BookLessonCourtRef ref, {
  required int lessonTime,
  required int courtId,
  required int lessonId,
  required int coachId,
  required int locationId,
  required DateTime dateTime,
  required LessonVariants? lessonVariant,
}) async {
  return ref.read(bookingRepoProvider).bookLessonCourt(
        ref,
        lessonTime: lessonTime,
        dateTime: dateTime,
        coachId: coachId,
        courtId: courtId,
        lessonVariant: lessonVariant,
        lessonId: lessonId,
        locationId: locationId,
      );
}

@riverpod
Future<double?> upgradeBookingToOpen(UpgradeBookingToOpenRef ref,
    {required Bookings booking,
    required int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded}) async {
  return ref.read(bookingRepoProvider).upgradeBookingToOpen(ref,
      booking: booking,
      reservedPlayers: reservedPlayers,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      approvalNeeded: approvalNeeded);
}
