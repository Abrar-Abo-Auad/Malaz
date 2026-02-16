import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/core/constants/app_constants.dart';

import '../../main.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _isInitialized = false;

  static Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print('>>> [Permission] حالة صلاحية الإشعارات: ${settings.authorizationStatus}');
  }

  static Future<void> updateNotificationChannel(String? soundUri) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const String fixedChannelId = AppConstants.ChannelId;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId: fixedChannelId);

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      fixedChannelId,
      'Malaz Notifications',
      description: 'Main notifications for malaz app',
      importance: Importance.max,
      playSound: true,
      sound: soundUri != null ? UriAndroidNotificationSound(soundUri) : null,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print("📢 Channel updated locally: $fixedChannelId");
  }

  static Future<void> handleInitialMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print(">>> [FCM Initial] تم فتح التطبيق عبر إشعار وكان مغلقاً تماماً");
      _showTopSnackBar(initialMessage.notification?.title, initialMessage.notification?.body);
    }
  }

  static Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;
    print(">>> [FCM] جاري بدء الاستماع للإشعارات...");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(">>> [FCM Foreground] وصل إشعار جديد الآن!");
      print(">>> [FCM Foreground] العنوان: ${message.notification?.title}");

      if (message.notification != null) {
        _showTopSnackBar(message.notification!.title, message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(">>> [FCM Opened] تم الضغط على الإشعار من شريط الإشعارات");
      _showTopSnackBar(message.notification?.title, message.notification?.body);
    });

    handleInitialMessage(context);
    _isInitialized = true;
  }

  static void _showTopSnackBar(String? title, String? body) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ?? "إشعار جديد",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text(body ?? "",
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 600, left: 10, right: 10),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}