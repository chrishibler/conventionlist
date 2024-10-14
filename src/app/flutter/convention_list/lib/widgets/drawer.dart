import 'package:flutter/material.dart';

import '../theme/mocha.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
          ListTile(
            title: const Text('Login'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Sort by Distance'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Sort by Date'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
