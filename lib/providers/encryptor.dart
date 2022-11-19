import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;

class Encryptor with ChangeNotifier {
  Encrypter? encrypter;
  String? _profileKey;
  AESMode _profileAlgorithm = AESMode.cbc;

  void _createEncrypter(String password, AESMode mode) {
    String passwordParser = password;
    if (passwordParser.length < 32) {
      passwordParser = password * (32 / password.length).ceilToDouble().toInt();
    }
    passwordParser = passwordParser.characters.take(32).toString();
    final key = Key.fromUtf8(passwordParser);

    encrypter = Encrypter(AES(key, mode: mode));
    _profileAlgorithm = mode;
  }

  String encrypt(String text) {
    if (encrypter == null) {
      throw Exception('Encrypter is null');
    }
    return encrypter!.encrypt(text, iv: IV.fromLength(16)).base64;
  }

  String decrypt(String text) {
    if (encrypter == null) {
      throw Exception('Encrypter is null');
    }
    return encrypter!.decrypt64(text, iv: IV.fromLength(16));
  }

  void createProfile(String key1, String key2, AESMode mode) {
    _createEncrypter(key1, mode);
    final encryptedKey = md5.convert(utf8.encode(encrypt(key2)));
    _profileKey = encryptedKey.toString();
    _createEncrypter('$_profileKey', _profileAlgorithm);
  }
}
