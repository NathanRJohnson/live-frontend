

import 'package:flutter/material.dart';

class PageLoadingIndicator extends StatelessWidget {

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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text("Signing in...",
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
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