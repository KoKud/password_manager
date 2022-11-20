import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/passwords.dart';

class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key});
  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _formKey = GlobalKey<FormState>();
  AESMode _selectedAlgorithm = AESMode.cbc;

  final Map<String, String> _keysData = {
    'passwordsJson': '',
    'key1': '',
    'key2': '',
  };

  void _selectAlgorithm(AESMode? value) {
    if (value == null) return;
    setState(() {
      _selectedAlgorithm = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import passwords'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Passwords json',
              ),
              onSaved: (value) => _keysData['passwordsJson'] = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Profile key1',
              ),
              onSaved: (value) => _keysData['key1'] = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Profile key2',
              ),
              onSaved: (value) => _keysData['key2'] = value!,
            ),
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
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close')),
        TextButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              _formKey.currentState!.save();
              final passwords = Provider.of<Passwords>(context, listen: false);
              try {
                passwords.importPasswords(
                  _keysData['passwordsJson']!,
                  _keysData['key1']!,
                  _keysData['key2']!,
                  _selectedAlgorithm,
                );
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Passwords imported'),
                    content: const Text('Passwords imported successfully'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'))
                    ],
                  ),
                );
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'Error decrypting passwords. Check your keys and algorithm'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'))
                    ],
                  ),
                );
              }
            },
            child: const Text('Import')),
      ],
    );
  }
}
