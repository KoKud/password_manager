import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/passwords.dart';
import '../widgets/import_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                children: [
                  const Icon(Icons.lock, size: 90),
                  const SizedBox(height: 10),
                  const Text('Password Manager',
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 200), //TODO create more settings
                  const Text('Import and Export',
                      style: TextStyle(fontSize: 20)),
                  const Divider(),
                  ListTile(
                    title: const Text('Import passwords from another profile'),
                    leading: const Icon(Icons.import_export),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => const ImportDialog());
                    },
                  ),
                  ListTile(
                    title: const Text('Export passwords - this profile'),
                    leading: const Icon(Icons.import_export),
                    onTap: () {
                      final exportedPasswords =
                          Provider.of<Passwords>(context, listen: false)
                              .exportPasswords();
                      exportPasswords(context, exportedPasswords);
                    },
                  ),
                  ListTile(
                    title: const Text('Import Google Chrome passwords'),
                    leading: const Icon(Icons.import_export),
                    onTap: () {
                      //TODO implement import from chrome
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void exportPasswords(BuildContext context, String exportedPasswords) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Exported passwords'),
              content: Text(exportedPasswords),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close')),
                TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: exportedPasswords));
                    },
                    child: const Text('Copy to clipboard')),
              ],
            ));
  }
}
