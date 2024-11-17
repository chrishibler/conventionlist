import 'package:convention_list/services/auth_service.dart';
import 'package:convention_list/util/permissions.dart';
import 'package:convention_list/widgets/drawer_item.dart';
import 'package:convention_list/widgets/paypal_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../injection.dart';
import '../theme/mocha.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key, this.additionalItems});

  final List<Widget>? additionalItems;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService authService = getIt<AuthService>();
  late bool isLoggedIn = authService.credentials != null;
  late bool isAdmin = authService.permissions.contains(Permissions.manageAllConventions);

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
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              context.go('/');
            },
          ),
          DrawerItem(
            icon: Icons.map,
            text: 'Map',
            onTap: () {
              context.go('/map');
            },
          ),
          if (isLoggedIn) const Divider(),
          DrawerItem(
            icon: isLoggedIn ? Icons.logout : Icons.login,
            text: isLoggedIn ? "Logout" : "Login",
            onTap: () async {
              try {
                if (isLoggedIn) {
                  await authService.logout();
                  setState(() {
                    isLoggedIn = false;
                  });
                } else {
                  await authService.login();
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
          if (widget.additionalItems?.isNotEmpty == true) const Divider(),
          ...?widget.additionalItems,
          const Divider(),
          const FractionallySizedBox(
            widthFactor: 0.7,
            child: PayPalButton(),
          ),
        ],
      ),
    );
  }

  List<Widget> _getAuthItems(BuildContext context) {
    bool isAdmin = authService.permissions.contains(Permissions.manageAllConventions);
    return [
      const Divider(),
      DrawerItem(
        icon: Icons.add,
        text: 'Add Convention',
        onTap: () => context.push('/add'),
      ),
      DrawerItem(
        icon: Icons.edit,
        text: 'Manage Conventions',
        onTap: () => context.go('/manage'),
      ),
      if (isAdmin) const Divider(),
      if (isAdmin)
        DrawerItem(
          icon: Icons.admin_panel_settings,
          text: 'Admin',
          onTap: () => context.go('/admin'),
        ),
    ];
  }
}
