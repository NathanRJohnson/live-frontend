

import 'package:flutter/material.dart';
import '../components/no_connection_message.dart';

class MealsView extends StatefulWidget {
  const MealsView({super.key});

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141414),
      child: Center(
        child: NoConnectionMessage(
          onRetry: (){},
        ),
      ),
    );
  }
}