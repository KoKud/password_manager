import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/password.dart';

class PassDetailDialog extends StatefulWidget {
  const PassDetailDialog({required this.password, super.key});
  final Password password;
  @override
  State<PassDetailDialog> createState() => _PassDetailDialogState();
}

class _PassDetailDialogState extends State<PassDetailDialog> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        widget.password.username,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: widget.password.username));
                },
                child: const Text('Copy'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Password: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                          width: 12.0,
                          child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 12.0,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: _showPassword
                          ? Text(widget.password.password)
                          : Text('*' * widget.password.password.length),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: widget.password.password));
                },
                child: const Text('Copy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
