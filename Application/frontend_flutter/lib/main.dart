import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/app/notifications_helper.dart';
import 'package:frontend_flutter/data_providers/appointments_provider.dart';
import 'package:frontend_flutter/data_providers/chat_provider.dart';
import 'package:frontend_flutter/data_providers/locations_provider.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';
import 'package:frontend_flutter/data_providers/profile_provider.dart';
import 'package:frontend_flutter/screens/forgot_password.dart';
import 'package:frontend_flutter/screens/home.dart';
import 'package:frontend_flutter/screens/login.dart';
import 'package:frontend_flutter/screens/register.dart';
import 'package:frontend_flutter/screens/splash.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await initializeNotifications();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => LocationsProvider()),
        ChangeNotifierProvider(create: (_) => PredictionsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> initializeNotifications() async {
  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'appointment_reminders',
        channelName: 'Appointment Reminders',
        channelDescription: 'Notifications for appointment reminders',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
  );

  // Request notification permission if not already granted
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DermatoAI',
      theme: ThemeData(
        primaryColor: AppMainTheme.blueLevelFive,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
