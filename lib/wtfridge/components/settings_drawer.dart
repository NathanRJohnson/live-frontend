import 'package:flutter/material.dart';
import 'package:project_l/wtfridge/components/login_button.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          LoginButton(),
        ],
      ),
    );
  }
}