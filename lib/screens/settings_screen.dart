import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
                const SizedBox(height: 10),
                const Icon(Icons.lock, size: 90),
                const SizedBox(height: 10),
                const Text('Password Manager', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 100),
                const Text('Import and Export', style: TextStyle(fontSize: 20)),
                const Divider(),
                ListTile(
                  title: const Text('Import passwords from another profile'),
                  leading: const Icon(Icons.import_export),
                  onTap: () {
                    showDialog(
                        context: context, builder: (_) => const ImportDialog());
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
                  title: const Text(
                      'Import passwords from csv file (coma separated)'),
                  leading: const Icon(Icons.import_export),
                  onTap: () async {
                    final filePickerResult =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv'],
                      allowMultiple: false,
                    );
                    if (filePickerResult == null) return;

                    // ignore: use_build_context_synchronously
                    Provider.of<Passwords>(context, listen: false)
                        .importUnencryptedPasswords(
                            File(filePickerResult.files.single.path ?? ''));
                  },
                ),
                ListTile(
                  title: const Text('Export to CSV - unencrypted'),
                  leading: const Icon(Icons.import_export),
                  onTap: () {
                    final exportedPasswords =
                        Provider.of<Passwords>(context, listen: false)
                            .exportUnencryptedPasswords();
                    exportPasswords(context, exportedPasswords);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void exportPasswords(BuildContext context, String exportedPasswords) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exported passwords'),
        content: SingleChildScrollView(child: Text(exportedPasswords)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close')),
          TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: exportedPasswords));
              },
              child: const Text('Copy to clipboard')),
          if (!Platform.isAndroid && !Platform.isIOS)
            TextButton(
                onPressed: () async {
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Please select an output file:',
                    fileName: 'passwords.csv',
                  );
                  if (outputFile == null) return;
                  File(outputFile).writeAsString(exportedPasswords);
                },
                child: const Text('Save to file')),
        ],
      ),
    );
  }
}
