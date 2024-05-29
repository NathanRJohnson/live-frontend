
import 'package:flutter/material.dart';

class NoConnectionMessage extends StatelessWidget {
  final void Function() onRetry;
  const NoConnectionMessage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF292929),
          border: Border.all(
            color: Colors.redAccent,
            width: 2.0
          ),
        ),
        child: Column(
          children: <Widget>[
            _displayIcon(),
            _displayErrorMessage(),
            _displayErrorDetails(),
            _displayRetryButton(onRetry)
          ],
        ),
      ),
    );
  }

  Widget _displayIcon() {
    return const Padding(
      padding: EdgeInsets.all(42.0),
      child: Center(
        child: Icon(
          Icons.warning_amber,
          size: 42.0,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _displayErrorMessage() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(42.0, 0, 42.0, 16.0),
      child: Center(
        child: Text(
          "Unable to connect to backend services",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0
          ),
        ),
      ),
    );
  }

  Widget _displayErrorDetails() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(42.0, 0, 42.0, 42.0),
      child: Center(
        child: Text(
          "Status Code: 500",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white60,
              fontSize: 16.0
          ),
        ),
      ),
    );
  }

  Widget _displayRetryButton(void Function() onRetry) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
      child: Center(
        child: TextButton(
          onPressed: onRetry,
          child: const Text(
            "Retry",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green,
                fontSize: 16.0
            ),
          ),
        ),
      ),
    );
  }

}

