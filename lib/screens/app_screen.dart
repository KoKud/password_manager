import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});
  static const routeName = '/app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordManager'),
      ),
      body: const Center(
        child: Text('Welcome to PasswordManager'),
      ),
    );
  }
}
