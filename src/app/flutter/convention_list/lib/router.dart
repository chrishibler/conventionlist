import 'package:convention_list/pages/add_edit_page.dart';
import 'package:convention_list/pages/flutter_map_page.dart';
import 'package:convention_list/pages/manage_page.dart';
import 'package:go_router/go_router.dart';

import 'models/convention.dart';
import 'pages/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddEditPage(),
    ),
    GoRoute(
      path: '/edit',
      builder: (context, state) {
        Convention? convention = state.extra as Convention;
        return AddEditPage(
          convention: convention,
        );
      },
    ),
    GoRoute(
      path: '/manage',
      builder: (context, state) => const ManagePage(),
    ),
    GoRoute(
      path: '/map',
      //builder: (context, state) => const MapPage(),
      builder: (context, state) => const FlutterMapPage(),
    )
  ],
);
