import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/mocha.dart';

void main() {
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
