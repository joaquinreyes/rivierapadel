import 'dart:async';
import 'dart:convert';
import 'package:acepadel/managers/user_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../globals/constants.dart';
import '../main.dart';
import '../repository/play_repo.dart';
import '../repository/user_repo.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

class FcmManager {
  FcmManager._internal();

  factory FcmManager() => _selfInstance;

  static final FcmManager _selfInstance = FcmManager._internal();

  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  RemoteMessage? initialMessage;
  StreamSubscription? messageSubscription;

  String? _token;

  String get token => _token ?? "";

  Future<FcmManager> initialize() async {
    if (_isInitialized) return this;

    // Request permissions
    final permissions = await _fcm.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true);
    if (permissions.authorizationStatus == AuthorizationStatus.notDetermined) {
      return this;
    }

    // Set foreground notification presentation options
    _fcm.setForegroundNotificationPresentationOptions(
        alert: true, sound: true, badge: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });

    // Listen to incoming messages
    messageSubscription = FirebaseMessaging.onMessage.listen((message) {
      _onMessage(message);
    });

    // Handle token refresh
    _fcm.onTokenRefresh.listen((String token) {
      _onTokenChange(token, globalRef!);
    });

    // Fetch the FCM token
    try {
      _token = await _fcm.getToken() ?? '';
      myPrint("FCM Token: $_token");
    } catch (e) {
      myPrint("FCM Token Error: $e");
      _token = "";
    }

    // Configure local notifications
    await _configureLocalNotifications(globalRef!);

    _isInitialized = true;
    return this;
  }

  Future<void> getInitialMessage() async {
    // Handle notification taps (when app is in terminated or background state)
    initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage!);
    }
  }

  void _onTokenChange(String token, WidgetRef ref) {
    myPrint("FCM Token refreshed: $token");
    if (token.trim().isNotEmpty && _token != token) {
      ref.watch(saveFCMTokenProvider(token));
    }
    _token = token;
    // Optionally send the updated token to the server
  }

  Future<void> _onMessage(RemoteMessage message) async {
    if (message.notification != null) {
      String? payload;
      if (message.data.isNotEmpty) {
        payload = jsonEncode(message.data);
      }
      myPrint(
          "Notification Received: ${message.notification!.title} - ${message.notification!.body} - $payload");

      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'default_notification_channel_id',
        'Notifications',
        channelDescription: 'Default channel for app notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        icon: '@drawable/ic_stat',
      );

      const iosPlatformChannelSpecifics = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
          macOS: DarwinNotificationDetails(),
          linux: LinuxNotificationDetails());

      final token = globalRef!.read(userManagerProvider).user?.accessToken;

      if (message.data["service_type"] == "Event" && token != null) {
        globalRef!.invalidate(fetchServiceDetailProvider);
        globalRef!.invalidate(fetchServiceWaitingPlayersProvider);
      } else if (message.data["service_type"] == "Booking" &&
          message.data["booking_type"] == "Open Match") {
        globalRef!.invalidate(fetchServiceDetailProvider);
        globalRef!.invalidate(fetchServiceWaitingPlayersProvider);
      }

      await _localNotifications.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: payload,
      );
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      if (message.data["service_type"] == "Booking" &&
          message.data["booking_type"] == "Open Match") {
        final id = int.tryParse(message.data["service_booking_id"]);
        if (id != null) {
          globalRef!.read(goRouterProvider).push("${RouteNames.matchInfo}/$id");
        }
      }
    }
  }

  Future<void> _configureLocalNotifications(WidgetRef ref) async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_stat');
    const iosInitializationSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      myPrint("Notification payload: ${payload.payload}");
      myPrint("Notification id: ${payload.id}");
      if ((payload.payload ?? "").isNotEmpty) {
        _handleMessage(RemoteMessage(data: jsonDecode(payload.payload ?? "")));
      }
    });
  }
}
