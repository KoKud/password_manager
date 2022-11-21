import 'package:flutter/material.dart';
import 'package:password_manager/screens/auth_screen.dart';
import 'package:password_manager/widgets/create_new_password.dart';
import 'package:provider/provider.dart';

import '../providers/encryptor.dart';
import '../providers/passwords.dart';
import '../screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  RoundedRectangleBorder get settingsShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: const [
                        Icon(Icons.lock, size: 90),
                        SizedBox(height: 10),
                        Text('Password Manager'),
                      ],
                    ),
                  ),
                  ListTile(
                    shape: settingsShape,
                    hoverColor: Theme.of(context).colorScheme.surfaceTint,
                    title: const Text('Create new password'),
                    leading: const Icon(Icons.add),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => CreateNewPassword(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Column(
            children: [
              ListTile(
                shape: settingsShape,
                hoverColor: Theme.of(context).colorScheme.surfaceTint,
                title: const Text('Settings'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
              ListTile(
                shape: settingsShape,
                hoverColor: Theme.of(context).colorScheme.surfaceTint,
                title: const Text('About'),
                leading: const Icon(Icons.info),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Password Manager',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.lock),
                    applicationLegalese:
                        'Licensed under GNU General Public License v3.0 ',
                    children: const [
                      Divider(),
                      SizedBox(height: 10),
                      Text('Password Manager is a free, opensource software'),
                      Text('https://github.com/KoKud/password_manager.git'),
                      Text('Made with Flutter'),
                      Divider(),
                      SizedBox(height: 10),
                      Text('Developed by: Konrad Kudlak - KoKud - 2022'),
                      Text('Email: developer@kokud.dev'),
                      Text('Website: https://kokud.dev'),
                    ],
                  );
                },
              ),
              ListTile(
                shape: settingsShape,
                hoverColor: Theme.of(context).colorScheme.surfaceTint,
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Provider.of<Encryptor>(context, listen: false).logout();
                  Provider.of<Passwords>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, AuthScreen.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
