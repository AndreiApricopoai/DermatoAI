import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';

class Utils {
  static Future<void> initializeNotifications() async {
    AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: 'appointment_reminders',
          channelName: 'Appointment Reminders',
          channelDescription: 'Notifications for appointment reminders',
          defaultColor: AppMainTheme.blueLevelFive,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      try {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      } catch (e) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }
  }
}
