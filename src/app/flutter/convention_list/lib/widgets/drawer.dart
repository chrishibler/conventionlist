import 'package:convention_list/services/auth_service.dart';
import 'package:convention_list/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/mocha.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key, this.additionalItems});

  final List<Widget>? additionalItems;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isLoggedIn = AuthService.credentials != null;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 128,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: CatppuccinMocha.mantle,
              ),
              child: Center(
                child: Text(
                  'Convention List',
                  style: TextStyle(
                    color: CatppuccinMocha.green,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          DrawerItem(
            icon: isLoggedIn ? Icons.logout : Icons.login,
            text: isLoggedIn ? "Logout" : "Login",
            onTap: () async {
              try {
                if (isLoggedIn) {
                  await AuthService().logout();
                  setState(() {
                    isLoggedIn = false;
                  });
                } else {
                  await AuthService().login();
                  setState(() {
                    isLoggedIn = true;
                  });
                }
              } catch (e) {
                print(e);
              }
            },
          ),
          if (isLoggedIn) ..._getAuthItems(context),
          const Divider(),
          ...?widget.additionalItems,
        ],
      ),
    );
  }

  List<Widget> _getAuthItems(BuildContext context) {
    return [
      const Divider(),
      DrawerItem(
        icon: Icons.add,
        text: 'Add Convention',
        onTap: () => context.push('/add'),
      ),
      DrawerItem(icon: Icons.edit, text: 'Manage Conventions', onTap: () {})
    ];
  }
}
