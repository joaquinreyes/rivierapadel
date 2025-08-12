import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/auth/auth_screen.dart';
import 'package:acepadel/screens/auth/signin/signin_screen.dart';
import 'package:acepadel/screens/auth/signup/signup_screen.dart';
import 'package:acepadel/screens/booking_detail/booking_detail.dart';
import 'package:acepadel/screens/event_detail/event_detail.dart';
import 'package:acepadel/screens/home_screen/home_screen.dart';
import 'package:acepadel/screens/lesson_detail/lesson_detail.dart';
import 'package:acepadel/screens/notification_screen/notification_screen.dart';
import 'package:acepadel/screens/open_match_detail/open_match_detail.dart';
import 'package:acepadel/screens/payment_information/midtran_webview.dart';
import 'package:acepadel/screens/splash_screen/splash_screen.dart';

import '../screens/chat/chat_screen.dart';
import '../screens/full_screen_image/full_screen_image_screen.dart';
import '../screens/ranking_profile/ranking_profile.dart';

final goRouterProvider = Provider((ref) => AppPages.router);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppPages {
  AppPages._();
  static const String initial = RouteNames.splash;

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initial,
    routes: [
      GoRoute(
        name: "splash",
        path: RouteNames.splash,
        pageBuilder: (context, state) {
          return _buildPage(const SplashScreen());
        },
      ),
      GoRoute(
        path: RouteNames.auth,
        name: "auth",
        pageBuilder: (context, state) {
          return _buildPage(const AuthScreen());
        },
      ),
      GoRoute(
        path: RouteNames.signIn,
        name: "sign_in",
        pageBuilder: (context, state) {
          return _buildPage(const SigninScreen());
        },
      ),
      GoRoute(
        path: RouteNames.signUp,
        name: "sign_up",
        pageBuilder: (context, state) {
          return _buildPage(const SignUpScreen());
        },
      ),
      GoRoute(
        path: "${RouteNames.bookingInfo}/:booking_id",
        name: "booking_info",
        pageBuilder: (context, state) {
          final bookingId =
              int.tryParse(state.pathParameters['booking_id'] ?? '');

          return _buildPage(BookingDetail(bookingId: bookingId));
        },
      ),
      GoRoute(
        path: "${RouteNames.matchInfo}/:id",
        name: "match_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(OpenMatchDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: "${RouteNames.eventInfo}/:id",
        name: "event_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(EventDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: "${RouteNames.lessonInfo}/:id",
        name: "lesson_info",
        pageBuilder: (context, state) {
          final matchId = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildPage(LessonDetail(matchId: matchId));
        },
      ),
      GoRoute(
        path: "${RouteNames.midTranWebView}/:url",
        name: "mid_tran_web_view",
        pageBuilder: (context, state) {
          final url = state.pathParameters['url'] ?? '';
          final String decodedUrl = Uri.decodeComponent(url);
          return _buildPage(MidtranWebview(url: decodedUrl));
        },
      ),
      GoRoute(
        path: RouteNames.showImage,
        name: "show_image",
        pageBuilder: (context, state) {
          String image = "";
          if (state.extra is List) {
            image = (state.extra as List)[0] ?? "";
          }
          return _buildPage(FullScreenImage(imageUrl: image));
        },
      ),
      GoRoute(
        path: "${RouteNames.rankingProfile}/:id",
        name: "ranking_profile",
        pageBuilder: (context, state) {
          int id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _buildPage(RankingProfile(customerID: id));
        },
      ),
      GoRoute(
        path: RouteNames.home,
        name: "home",
        pageBuilder: (context, state) {
          return _buildPage(const HomeScreen());
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: "notifications",
        pageBuilder: (context, state) {
          return _buildPage(const NotificationScreen());
        },
      ),
      GoRoute(
        path: RouteNames.chat,
        name: "chat",
        pageBuilder: (context, state) {
          int matchId = 0;
          if (state.extra is List) {
            matchId = (state.extra as List)[0] ?? 0;
          }
          return _buildPage(ChatScreen(matchId: matchId));
        },
      ),
    ],
  );
  static Page<dynamic> _buildPage(Widget child) {
    if (PlatformC().isCurrentDesignPlatformDesktop) {
      return CustomTransitionPage(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    } else {
      return MaterialPage(child: child);
    }
  }
}
