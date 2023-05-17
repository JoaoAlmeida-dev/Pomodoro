import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pomodoro/services/logger/logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal() {
    _setTimezone();
  }

  Future<void> _setTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    bool? initializeSuccess =
        await _instance.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification,
    );
    Logger.debug(
        message: "Notification initialize Success: $initializeSuccess");
  }

  static Future<void> checkForNotifications() async {
    final NotificationAppLaunchDetails? details = await _instance
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details != null &&
        details.notificationResponse != null &&
        details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse!);
    }
  }

  static void _onSelectNotification(NotificationResponse notificationResponse) {
    //Navigator.of(Routes.navigatorKey!.currentContext!).pushReplacementNamed(Routes.initial);
  }

  static Future showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    Logger.debug(message: "showBigTextNotification called");

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "pomodoro_notif_channel_id",
      "Alarm notifications",
      channelDescription: "This channel is for sending big notifications",

      playSound: true,
      channelShowBadge: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      enableLights: true,
      showWhen: true,
      importance: Importance.max,
      priority: Priority.max,
      //sound: RawResourceAndroidNotificationSound('notificiation'),
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    await _instance.flutterLocalNotificationsPlugin.show(id, title, body, not);
  }

  static Future scheduleBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    required DateTime time,
    var payload,
  }) async {
    Logger.debug(message: "scheduleBigTextNotification called");

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "pomodoro_notif_channel_id", "Alarm notifications",
      channelDescription: "This channel is for sending big notifications",
      importance: Importance.max,
      priority: Priority.max,
      visibility: NotificationVisibility.public,
      playSound: true,
      channelShowBadge: true,
      enableVibration: true,
      fullScreenIntent: true,
      enableLights: true,
      showWhen: true,
      chronometerCountDown: true,
      usesChronometer: true,
      ledOnMs: 1000,
      ledOffMs: 1000,
      category: AndroidNotificationCategory.stopwatch,
      colorized: true,
      color: Colors.pink,
      ongoing: true,
      ledColor: Colors.pink,
      //sound: RawResourceAndroidNotificationSound('notificiation'),
    );

    NotificationDetails not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await _instance.flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      not,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
