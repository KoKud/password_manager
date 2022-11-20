import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/password.dart';
import '../../providers/passwords.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/create_new_password.dart';
import '../../widgets/pass_tile.dart';

class AppTablet extends StatelessWidget {
  const AppTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordManager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CreateNewPassword(),
              );
            },
          ),
        ],
      ),
      body: Consumer<Passwords>(
        builder: (context, passwords, child) => GridView.builder(
          itemCount: passwords.passwords.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 100,
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            Password password = passwords.passwords.values.elementAt(index);
            return PassTile(password: password);
          },
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
