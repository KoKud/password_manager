import 'dart:convert';

import 'package:password_manager/providers/encryptor.dart';

class Password {
  String website;
  String username;
  String password;
  Password({
    required this.website,
    required this.username,
    required this.password,
  });

  Password.fromJson(
    this.website,
    String data,
    Encryptor encryptor,
  )   : username = jsonDecode(encryptor.decrypt(data))['username'],
        password = jsonDecode(encryptor.decrypt(data))['password'];

  MapEntry<String, String> toJson(Encryptor encryptor) => MapEntry(
        website,
        encryptor.encrypt(jsonEncode({
          'username': username,
          'password': password,
        })),
      );

  @override
  String toString() =>
      'Password(website: $website, username: $username, password: $password)';
}
