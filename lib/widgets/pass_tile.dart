import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/passwords.dart';
import 'package:password_manager/widgets/pass_detail_dialog.dart';
import 'package:provider/provider.dart';

import 'create_new_password.dart';

class PassTile extends StatefulWidget {
  final Password password;
  const PassTile({required this.password, super.key});

  @override
  State<PassTile> createState() => _PassTileState();
}

class _PassTileState extends State<PassTile> {
  bool _showPassword = false;
  bool _hover = false;

  void showPasswordDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            GestureDetector(
              child: CircleAvatar(
                child: Text(widget.password.website[0]),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.password.website));
              },
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.password.website))
          ],
        ),
        content: PassDetailDialog(password: widget.password),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => CreateNewPassword(passwordDetails: {
                      'website': widget.password.website,
                      'username': widget.password.username,
                      'password': widget.password.password,
                    }),
                  );
                },
                child:
                    const Text('Edit', style: TextStyle(color: Colors.amber)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // show are you sure dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text(
                          'This action cannot be undone. Are you sure you want to delete this password?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<Passwords>(context, listen: false)
                                .deletePassword(widget.password);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        child: Card(
          color: _hover
              ? Theme.of(context).colorScheme.surfaceTint
              : Theme.of(context).cardColor,
          child: Center(
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              leading: CircleAvatar(
                child: Text(widget.password.website[0]),
              ),
              title: Text(
                widget.password.website,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${widget.password.username} :   ${_showPassword ? widget.password.password : ('* ' * widget.password.password.length)}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility),
              ),
            ),
          ),
        ),
        onTap: () => showPasswordDetails(context),
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: widget.password.password));
        },
      ),
    );
  }
}
