import 'package:flutter/material.dart';

import '../responsive/app_screen/app_desktop.dart';
import '../responsive/app_screen/app_mobile.dart';
import '../responsive/app_screen/app_tablet.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});
  static const routeName = '/app';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return const AppMobile();
      } else if (constraints.maxWidth < 1000) {
        return const AppTablet();
      } else {
        return const AppDesktop();
      }
    });
  }
}
