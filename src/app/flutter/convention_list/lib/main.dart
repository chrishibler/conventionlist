import 'dart:io';
import 'dart:ui';

import 'package:convention_list/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'router.dart';
import 'theme/mocha.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // injection
  configureDependencies();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  HttpOverrides.global = _AppHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Convention List',
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: CatppuccinMocha.base,
        inputDecorationTheme: CatppuccinMocha.inputTheme,
        appBarTheme: CatppuccinMocha.appBarTheme,
        textTheme: CatppuccinMocha.textTheme,
      ),
    );
  }
}

class _AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
