import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/password.dart';
import '../../providers/passwords.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/pass_tile.dart';

class AppDesktop extends StatelessWidget {
  const AppDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppDrawer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            child: Container(color: Theme.of(context).dividerColor),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraits) {
              final width = constraits.maxWidth;
              return Consumer<Passwords>(
                builder: (context, passwords, child) => GridView.builder(
                  itemCount: passwords.passwords.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 100,
                    crossAxisCount: (width / 300).floor(),
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    Password password =
                        passwords.passwords.values.elementAt(index);
                    return PassTile(password: password);
                  },
                ),
              );
            }),
          )
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
