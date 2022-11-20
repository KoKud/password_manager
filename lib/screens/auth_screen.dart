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
        title: const Text('Password Manager'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Welcome to Password Manager',
                style: TextStyle(fontSize: 20)),
            const Text('Please authenticate yourself'),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Key 1',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: _keyValidator,
                  onSaved: (value) => _keysData['key1'] = value!,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Key 2',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: _keyValidator,
                  onSaved: (value) => _keysData['key2'] = value!,
                ),
              ),
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColorLight,
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size(200, 55),
              ),
              onPressed: () => _logintoProfile(context),
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}
