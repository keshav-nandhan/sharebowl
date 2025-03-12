import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //final initfuture =MobileAds.instance.initialize();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyB23mx2Ksh-oNDSHcMC-PzXEJ7mSbdQEyg',
      appId: '1:917036182592:android:f64356c0ed7dda582243a5',
      messagingSenderId: 'sharebowl-91b81.appspot.com',
      projectId: 'sharebowl-91b81',
      storageBucket: 'sharebowl-91b81.appspot.com',
    ));

    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage(analytics: analytics, observer: observer),
    );
  }
}
