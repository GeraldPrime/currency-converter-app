

import 'package:currency_converter_app/firebase_options.dart';
import 'package:currency_converter_app/home_screen.dart';
import 'package:currency_converter_app/screens/login.dart';
import 'package:currency_converter_app/service/notification_service.dart'; // Import the NotificationService
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); //
  final notificationService = NotificationService();
  await notificationService.initNotifications(); // Initialize notifications
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CurrenSee',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      // home: HomeScreen(),
      home: LogIn(),
    );
  }
}
