import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';

class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize(WidgetRef ref) async {
    _appLinks.uriLinkStream.listen((data) {
      log('Link data: $data', name: 'Dynamic Link Handler');
      _handleLinkData(data, ref);
    }).onError((error) {
      log('$error', name: 'Dynamic Link Handler');
    });
    // _checkInitialLink(ref);
  }

  // /// Handle navigation if initial link is found on app start.
  // Future<void> _checkInitialLink(WidgetRef ref) async {
  //   final initialLink = await _appLinks.getInitialLink();
  //   if (initialLink != null) {
  //     // log('Link data: $data', name: 'Dynamic Link Handler');
  //     log('Initial Link: $initialLink', name: 'Dynamic Link Handler');
  //     _handleLinkData(initialLink, ref);
  //   }
  // }

  void _handleLinkData(Uri data, WidgetRef ref) {
    if (data.pathSegments.length != 2) return;
    if (data.pathSegments[0] == 'match_info') {
      final id = int.tryParse(data.pathSegments[1]);
      if (id != null) {
        ref.read(goRouterProvider).push("${RouteNames.matchInfo}/$id");
      }
    }
    if (data.pathSegments[0] == 'event_info') {
      final id = int.tryParse(data.pathSegments[1]);
      if (id != null) {
        ref.read(goRouterProvider).push("${RouteNames.eventInfo}/$id");
      }
    }
    if (data.pathSegments[0] == 'lesson_info') {
      final id = int.tryParse(data.pathSegments[1]);
      if (id != null) {
        ref.read(goRouterProvider).push("${RouteNames.lessonInfo}/$id");
      }
    }
    if (data.pathSegments[0] == 'booking_info') {
      final id = int.tryParse(data.pathSegments[1]);
      if (id != null) {
        ref.read(goRouterProvider).push("${RouteNames.bookingInfo}/$id");
      }
    }
  }

  getMatchURL(int id) {
    return 'https://app.acepadel.bookandgo.app/match_info/$id';
  }

  getBookingURL(int id) {
    return 'https://app.acepadel.bookandgo.app/booking_info/$id';
  }

  getEventURL(int id) {
    return 'https://app.acepadel.bookandgo.app/event_info/$id';
  }

  getLessonUrl(int id) {
    return 'https://app.acepadel.bookandgo.app/lesson_info/$id';
  }
}
