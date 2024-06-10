import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationsHelper {
  static Future<void> setNotification(DateTime dateTime, int id, String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'appointment_reminders',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: dateTime),
    );
  }
}
