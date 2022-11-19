import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;

class Encryptor {
  Encrypter? _encrypter;
  String? _profileKey;

  String get profileKey => _profileKey!;

  void _createEncrypter(String password, AESMode mode) {
    String passwordParser = password;
    if (passwordParser.length < 32) {
      passwordParser = password * (32 / password.length).ceilToDouble().toInt();
    }
    passwordParser = passwordParser.characters.take(32).toString();
    final key = Key.fromUtf8(passwordParser);

    _encrypter = Encrypter(AES(key, mode: mode));
  }

  String encrypt(String text) {
    if (_encrypter == null) {
      throw Exception('Encrypter is null');
    }
    return _encrypter!.encrypt(text, iv: IV.fromLength(16)).base64;
  }

  String decrypt(String text) {
    if (_encrypter == null) {
      throw Exception('Encrypter is null');
    }
    return _encrypter!.decrypt64(text, iv: IV.fromLength(16));
  }

  void createProfile(String key1, String key2, AESMode mode) {
    _createEncrypter(key1, mode);
    _profileKey = md5.convert(utf8.encode(key1)).toString();
    final encryptedKey = md5.convert(utf8.encode(encrypt(key2)));
    _createEncrypter('$encryptedKey', mode);
  }
}
