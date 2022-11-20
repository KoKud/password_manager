import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/password.dart';
import '../../providers/passwords.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/create_new_password.dart';
import '../../widgets/pass_tile.dart';

class AppMobile extends StatelessWidget {
  const AppMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordManager'),
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
      drawer: const AppDrawer(),
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
