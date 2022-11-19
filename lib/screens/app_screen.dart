import 'package:flutter/material.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/passwords.dart';
import 'package:provider/provider.dart';

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
            onPressed: () {}, //TODO: Add settings screen
          ),
        ],
      ),
      body: Consumer<Passwords>(
        builder: (context, passwords, child) => ListView.builder(
          itemCount: passwords.passwords.length,
          itemBuilder: (context, index) {
            Password password = passwords.passwords.values.elementAt(index);
            return ListTile(
              title: Text(password.website),
              subtitle: Text(password.username),
              trailing: Text('*' * password.password.length),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //TODO: Implement this
        onPressed: () {
          Provider.of<Passwords>(context, listen: false).createPassword(
              Password(
                  website: 'website2',
                  username: 'username',
                  password: 'password'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
