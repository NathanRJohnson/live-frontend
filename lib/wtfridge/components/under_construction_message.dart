
import 'package:flutter/material.dart';

class UnderConstructionMessage extends StatelessWidget {
  const UnderConstructionMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF292929),
          border: Border.all(
            color: Colors.yellow,
            width: 2.0
          ),
        ),
        child: Column(
          children: <Widget>[
            _displayIcon(),
            _displayErrorMessage(),
            _displayErrorDetails(),
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
          color: Colors.yellow,
        ),
      ),
    );
  }

  Widget _displayErrorMessage() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(42.0, 0, 42.0, 16.0),
      child: Center(
        child: Text(
          "Page under construction",
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
          "Thank you for you patience",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white60,
              fontSize: 16.0
          ),
        ),
      ),
    );
  }

}

