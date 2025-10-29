import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import '../globals/constants.dart';

/// Provides methods to manage dynamic links.
class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize(WidgetRef ref) async {
    try {
      // Check for initial link that launched the app
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        myPrint('Initial link: $initialLink');
        _handleLinkData(initialLink, ref);
      }

      // Listen for incoming links
      _appLinks.uriLinkStream.listen((data) {
        myPrint('Link data: $data');
        _handleLinkData(data, ref);
      }).onError((error) {
        myPrint('Error in Deep Link ------------------------ $error');
      });
    } catch (e) {
      myPrint('Error initializing deep links: $e');
    }
  }

  void _handleLinkData(Uri data, WidgetRef ref) {
    myPrint('Handling link: $data');
    myPrint('Path segments: ${data.pathSegments}');

    if (data.pathSegments.length != 3) {
      myPrint('Invalid path segments length: ${data.pathSegments.length}');
      return;
    }

    final type = data.pathSegments[1];
    final id = int.tryParse(data.pathSegments[2]);
    if (id == null) {
      myPrint('Invalid ID: ${data.pathSegments[2]}');
      return;
    }

    myPrint('Processing deep link - Type: $type, ID: $id');

    switch (type) {
      case 'match_info':
        ref.read(goRouterProvider).push("${RouteNames.matchInfo}/$id");
        break;
      case 'event_info':
        ref.read(goRouterProvider).push("${RouteNames.eventInfo}/$id");
        break;
      case 'booking_info':
        ref.read(goRouterProvider).push("${RouteNames.bookingInfo}/$id");
        break;
      case 'lesson_info':
        ref.read(goRouterProvider).push("${RouteNames.lessonInfo}/$id");
        break;
      default:
        myPrint('Unknown deep link type: $type');
    }
  }

  getMatchURL(int id) {
    return '$kDeepLinkUrl/match_info/$id';
  }

  getBookingURL(int id) {
    return '$kDeepLinkUrl/booking_info/$id';
  }

  getEventURL(int id) {
    return '$kDeepLinkUrl/event_info/$id';
  }

  getLessonUrl(int id) {
    return '$kDeepLinkUrl/lesson_info/$id';
  }
}
