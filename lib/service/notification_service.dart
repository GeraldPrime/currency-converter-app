// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your_channel_id', 'your_channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initializes the notification settings and creates the notification channel.
  Future<void> initNotifications() async {
    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Create notification channel (for Android 8.0 and above)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // id
      'your_channel_name', // title
      description: 'Your channel description',
      importance: Importance.max,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  // Method to show a notification
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // channel ID
      'your_channel_name', // channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0, // notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Handle notification taps
  void handleNotificationTap() {
    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details?.didNotificationLaunchApp ?? false) {
        // Handle navigation or other actions when a notification is tapped
        // For example, navigate to a specific screen
        // Navigator.pushNamed(context, '/details', arguments: details?.notificationResponse?.payload);
      }
    });
  }
}
