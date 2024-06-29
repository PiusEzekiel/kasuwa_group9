import 'package:flutter/material.dart';
import 'package:kasuwa/components/my_drawer_tile.dart';
import 'package:kasuwa/screens/auth/views/profile_screen.dart';

import '../screens/auth/views/forum_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      child: Column(
        children: [
          //app logo
          Padding(
            padding: const EdgeInsets.only(top: 80.0, right: 50.0, left: 110.0),
            child: Row(
              children: [
                Image.asset(
                  'images/kasuwa_logo.png',
                  scale: 6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Divider(
              color: Theme.of(context).colorScheme.tertiary,
              thickness: 3,
            ),
          ),

          //home
          MyDrawerTile(
            text: 'H O M E',
            icon: Icons.home_outlined,
            onTap: () {
              Navigator.pop(context);
            },
          ),

          //profile
          MyDrawerTile(
            text: 'P R O F I L E',
            icon: Icons.person_outline,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProfileScreen();
              }));
            },
          ),
          //forum
          MyDrawerTile(
            text: 'F O R U M',
            icon: Icons.settings_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ForumScreen();
              }));
            },
          ),
          MyDrawerTile(
            text: 'C O N T R O L L E',
            icon: Icons.person_outline,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProfileScreen();
              }));
            },
          ),
          //logout
          const Spacer(),
          MyDrawerTile(
            text: 'L O G O U T',
            icon: Icons.logout_outlined,
            onTap: () {},
          ),
          const SizedBox(height: 40.0)
        ],
      ),
    );
  }
}
