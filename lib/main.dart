import 'package:flutter/material.dart';
import 'package:password_manager/providers/encryptor.dart';
import 'package:password_manager/providers/passwords.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/settings_screen.dart';
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
        Provider<Encryptor>(create: (_) => Encryptor()),
        ChangeNotifierProxyProvider<Encryptor, Passwords>(
          create: (_) => Passwords(Encryptor()),
          update: (_, encryptor, __) => Passwords(encryptor)..loadPasswords(),
        ),
      ],
      child: MaterialApp(
        title: 'Password Manager',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.orange),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch(
                  brightness: Brightness.dark, primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.orange),
        ),
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          AppScreen.routeName: (_) => const AppScreen(),
          SettingsScreen.routeName: (_) => const SettingsScreen(),
        },
      ),
    );
  }
}
