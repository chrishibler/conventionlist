import 'package:convention_list/navigation/edit_extra_parameter.dart';
import 'package:convention_list/pages/add_edit/add_edit_page.dart';
import 'package:convention_list/pages/add_edit/admin_add_edit_page.dart';
import 'package:convention_list/pages/admin_manage_page.dart';
import 'package:convention_list/pages/map_page.dart';
import 'package:convention_list/pages/user_manage_page.dart';
import 'package:go_router/go_router.dart';

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
    GoRoute(path: '/manage', builder: (context, state) => UserManagePage(), routes: [
      GoRoute(
        path: '/edit',
        builder: (context, state) {
          EditExtraParameter param = state.extra as EditExtraParameter;
          return AddEditPage(
            convention: param.convention,
            refresh: param.refresh,
          );
        },
      ),
    ]),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(path: '/admin', builder: (context, state) => const AdminManagePage(), routes: [
      GoRoute(
        path: '/edit',
        builder: (context, state) {
          EditExtraParameter param = state.extra as EditExtraParameter;
          return AdminAddEditPage(
            convention: param.convention,
            refresh: param.refresh,
          );
        },
      ),
    ]),
  ],
);
