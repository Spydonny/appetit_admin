import 'package:appetit_admin/core/core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

/// Фоновый обработчик пушей
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("FCM background: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Firebase init ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- FCM background handler ---
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // --- Request permissions (Android 13+ / iOS) ---
  await FirebaseMessaging.instance.requestPermission();



  // --- Dependency injection ---
  dependencyInjection();

  runApp(const MyApp());

  // --- Foreground messages ---
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint("FCM foreground: ${message.notification?.title}");
  });

  // --- Opened from push ---
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint("FCM opened: ${message.data}");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Appetit admin',
      theme: AppTheme.lightTheme,
      routerConfig: router,

    );
  }
}

