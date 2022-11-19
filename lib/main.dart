import 'package:flutter/material.dart';
import 'package:password_manager/providers/encryptor.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Encryptor()),
      ],
      child: MaterialApp(
        title: 'Password Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          AppScreen.routeName: (_) => const AppScreen(),
        },
      ),
    );
  }
}
