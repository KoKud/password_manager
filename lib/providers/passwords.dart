import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/encryptor.dart';

class Passwords with ChangeNotifier {
  final Map<String, Password> _passwords = {};
  final Encryptor _encryptor;
  Passwords(this._encryptor);

  Map<String, Password> get passwords => {..._passwords};
  late Box<dynamic> encryptedBox;

  Future<void> openHiveEncryptedBox() async {
    const secureStorage = FlutterSecureStorage();

    final storageKey = await secureStorage.read(key: 'key');
    if (storageKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    encryptedBox = await Hive.openBox(_encryptor.profileKey,
        encryptionCipher: HiveAesCipher(encryptionKey));
  }

  void loadPasswords() async {
    await openHiveEncryptedBox();
    for (var key in encryptedBox.keys) {
      final password = Password.fromJson(
        key,
        encryptedBox.get(key),
        _encryptor,
      );
      _passwords.putIfAbsent(key, () => password);
    }
    notifyListeners();
  }

  void createPassword(Password password) {
    encryptedBox.put(password.website, password.toJson(_encryptor).value);
    _passwords.addAll({password.website: password});
    notifyListeners();
  }

  void deletePassword(Password password) {
    encryptedBox.delete(password.website);
    _passwords.remove(password.website);
    notifyListeners();
  }

  void logout() {
    encryptedBox.close();
    _passwords.clear();
    notifyListeners();
  }

  void importPasswords(String json, String key1, String key2, AESMode mode) {
    Map<String, dynamic> passwords = jsonDecode(json);
    final encriptionProfile = Encryptor()..createProfile(key1, key2, mode);
    passwords.forEach((key, value) {
      final password = Password.fromJson(
        key,
        value,
        encriptionProfile,
      );
      encryptedBox.put(password.website, password.toJson(_encryptor).value);
      _passwords.putIfAbsent(key, () => password);
    });
    notifyListeners();
  }

  String exportPasswords() {
    final passwords = encryptedBox.toMap();
    final json = jsonEncode(passwords);
    return json;
  }

  Future<void> importUnencryptedPasswords(File file) async {
    final fromFile = file.readAsLinesSync();
    final passwords = fromFile.join('\n');

    final passwordsList =
        const CsvToListConverter(eol: '\n').convert(passwords);

    final urlIndex = passwordsList[0].indexOf('url');
    final usernameIndex = passwordsList[0].indexOf('username');
    final passwordIndex = passwordsList[0].indexOf('password');

    passwordsList
        .skip(1)
        .map(
          (e) => Password(
              website: '${e[urlIndex]}',
              username: '${e[usernameIndex]}',
              password: '${e[passwordIndex]}'),
        )
        .forEach((password) {
      encryptedBox.put(password.website, password.toJson(_encryptor).value);
      _passwords.putIfAbsent(password.website, () => password);
    });
    notifyListeners();
  }

  String exportUnencryptedPasswords() {
    List<List<dynamic>> rows = [
      ['url', 'username', 'password']
    ];
    for (var password in _passwords.values) {
      rows.add([
        password.website,
        password.username,
        password.password,
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }
}
