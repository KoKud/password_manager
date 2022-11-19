import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/encryptor.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AESMode _selectedAlgorithm = AESMode.cbc;
  final Map<String, String> _keysData = {
    'key1': '',
    'key2': '',
  };

  void _logintoProfile(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final encryptor = Provider.of<Encryptor>(context, listen: false);
    encryptor.createProfile(
        _keysData['key1']!, _keysData['key2']!, _selectedAlgorithm);
    Navigator.of(context).pushReplacementNamed('/app');
  }

  String? _keyValidator(String? value) =>
      ((value?.length ?? 0) < 4 || (value?.length ?? 0) > 32)
          ? 'Key must be between 4 and 32 characters'
          : null;

  void _selectAlgorithm(AESMode? value) {
    if (value == null) return;
    setState(() {
      _selectedAlgorithm = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordManager'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Welcome to PasswordManager'),
            const Text('Please authenticate yourself'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Key 1',
              ),
              obscureText: true,
              validator: _keyValidator,
              onSaved: (value) => _keysData['key1'] = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Key 2',
              ),
              obscureText: true,
              validator: _keyValidator,
              onSaved: (value) => _keysData['key2'] = value!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select Encryption Mode'),
                const SizedBox(width: 20),
                DropdownButton(
                  value: _selectedAlgorithm,
                  items: AESMode.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text('AES ${e.name}'),
                          ))
                      .toList(),
                  onChanged: _selectAlgorithm,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _logintoProfile(context),
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}
