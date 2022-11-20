import 'package:flutter/material.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/passwords.dart';
import 'package:password_manager/screens/settings_screen.dart';
import 'package:password_manager/widgets/pass_tile.dart';
import 'package:provider/provider.dart';

import '../widgets/create_new_password.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});
  static const routeName = '/app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordManager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: Consumer<Passwords>(
        builder: (context, passwords, child) => ListView.builder(
          itemCount: passwords.passwords.length,
          itemBuilder: (context, index) {
            Password password = passwords.passwords.values.elementAt(index);
            return PassTile(password: password);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateNewPassword(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
