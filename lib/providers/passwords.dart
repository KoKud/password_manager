import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/encryptor.dart';

class Passwords with ChangeNotifier {
  final Map<String, Password> _passwords = {};
  final _storage = const FlutterSecureStorage();
  final Encryptor _encryptor;
  Passwords(this._encryptor);

  Map<String, Password> get passwords => {..._passwords};

  void loadPasswords() async {
    final profileData = await _storage.read(key: _encryptor.profileKey);

    Map<String, String> passwordsData =
        Map<String, String>.from(jsonDecode(profileData ?? '{}'));
    for (var website in passwordsData.keys) {
      _passwords[website] =
          Password.fromJson(website, passwordsData[website]!, _encryptor);
    }
    notifyListeners();
  }

  void createPassword(Password password) async {
    final jsonArray = await _storage.read(key: _encryptor.profileKey);

    Map<String, String> storagePasswords =
        Map<String, String>.from(jsonDecode(jsonArray ?? '{}'));
    storagePasswords.addEntries([password.toJson(_encryptor)]);

    _storage.write(
      key: _encryptor.profileKey,
      value: jsonEncode(storagePasswords),
    );

    _passwords.addAll({password.website: password});
    notifyListeners();
  }
}
