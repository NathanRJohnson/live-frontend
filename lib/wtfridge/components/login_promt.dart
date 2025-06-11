

import 'package:flutter/material.dart';
import 'package:project_l/wtfridge/components/login_form.dart';

class LoginPrompt extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: SizedBox(
              width: 340,
              height: 420,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Text("Welcome to WTFridge",
                       style: TextStyle(
                         fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                         color: Theme.of(context).colorScheme.onSurface,
                       ),
                     ),
                    const LoginForm()
                   ],
                  ),
                )
              ),
            ),
        )

        )
      ),
    );
  }

}