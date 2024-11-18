import 'package:convention_list/navigation/edit_extra_parameter.dart';
import 'package:convention_list/pages/add_edit/add_edit_page.dart';
import 'package:convention_list/pages/manage/manage_page.dart';
import 'package:convention_list/pages/map/map_page.dart';
import 'package:go_router/go_router.dart';

import 'pages/home/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddEditPage(),
        ),
        GoRoute(
            path: '/manage',
            builder: (context, state) => const ManagePage(
                  showSearchField: false,
                ),
            routes: [
              GoRoute(
                path: '/edit',
                builder: (context, state) {
                  EditExtraParameter param = state.extra as EditExtraParameter;
                  return AddEditPage(
                    convention: param.convention,
                  );
                },
              ),
            ]),
        GoRoute(
          path: '/map',
          builder: (context, state) => MapPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const ManagePage(
            showSearchField: false,
          ),
        ),
      ],
    ),
  ],
);
