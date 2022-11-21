import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/password.dart';
import '../providers/passwords.dart';

class CreateNewPassword extends StatelessWidget {
  CreateNewPassword({
    passwordDetails,
    Key? key,
  })  : passwordDetails = (passwordDetails != null)
            ? passwordDetails
            : {
                'website': '',
                'username': '',
                'password': '',
              },
        super(key: key);
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> passwordDetails;

  final _websiteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _saveForm(BuildContext context) {
    final prefWebsite = passwordDetails['website'];
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    Navigator.of(context).pop(passwordDetails);
    if (prefWebsite?.isNotEmpty ?? false) {
      Provider.of<Passwords>(context, listen: false).deletePassword(
        Password(website: prefWebsite!, username: '', password: ''),
      );
    }
    _formKey.currentState!.save();

    Provider.of<Passwords>(context, listen: false).createPassword(
      Password(
        website: passwordDetails['website']!,
        username: passwordDetails['username']!,
        password: passwordDetails['password']!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _websiteController.text = passwordDetails['website']!;
    _usernameController.text = passwordDetails['username']!;
    _passwordController.text = passwordDetails['password']!;
    return AlertDialog(
      title: const Text('Create new password'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website',
                ),
                maxLength: 255,
                onSaved: (value) {
                  passwordDetails['website'] = value!;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                onSaved: (value) {
                  passwordDetails['username'] = value!;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (value) {
                  passwordDetails['password'] = value!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => _saveForm(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
