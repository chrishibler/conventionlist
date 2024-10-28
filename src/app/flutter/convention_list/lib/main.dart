import 'dart:io';

import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/mocha.dart';

void main() {
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
