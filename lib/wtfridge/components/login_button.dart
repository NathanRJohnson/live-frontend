import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/components/login_form.dart';

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: <Widget>[
        TextButton(
          onPressed: (){ openSheetRefAddForm(context); },
          child: Text(
            "Login",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant
            ),
          )
        ),
      ],
    );
  }
}

Future<void> openSheetRefAddForm(BuildContext context) async {
  return await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: const LoginForm(),
    )
  );
}