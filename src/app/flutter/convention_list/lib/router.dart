import 'package:go_router/go_router.dart';

import 'pages/add_page.dart';
import 'pages/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddPage(),
    ),
  ],
);
