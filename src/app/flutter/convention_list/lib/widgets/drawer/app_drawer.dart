import 'package:convention_list/widgets/drawer_item.dart';
import 'package:convention_list/widgets/paypal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection.dart';
import '../../theme/mocha.dart';
import 'app_drawer_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    this.additionalItems,
  });

  final List<Widget>? additionalItems;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppDrawerCubit>(),
      child: BlocBuilder<AppDrawerCubit, AppDrawerState>(
        builder: (context, state) {
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
                if (state.isLoggedIn) const Divider(),
                DrawerItem(
                  icon: state.isLoggedIn ? Icons.logout : Icons.login,
                  text: state.isLoggedIn ? "Logout" : "Login",
                  onTap: () async {
                    await context.read<AppDrawerCubit>().loginLogout();
                  },
                ),
                if (state.isLoggedIn) ..._getAuthItems(context),
                if (additionalItems?.isNotEmpty == true) const Divider(),
                ...?additionalItems,
                const Divider(),
                const FractionallySizedBox(
                  widthFactor: 0.7,
                  child: PayPalButton(),
                ),
              ],
            ),
          );
        },
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
      DrawerItem(
        icon: Icons.edit,
        text: 'Manage Conventions',
        onTap: () => context.push('/manage'),
      ),
    ];
  }
}
