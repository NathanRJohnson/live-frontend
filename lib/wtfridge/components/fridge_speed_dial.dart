
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../components/fridge_add_form.dart';

import 'common/item_action_form.dart';

import '../provider/fridge_provider.dart';

class FridgeSpeedDial extends ConsumerWidget {

  Future<void> openFridgeAddForm(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (context) => const Dialog(
        backgroundColor: Color(0xFFFFFFFF),
        child: FridgeAddForm()
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      direction: SpeedDialDirection.up,
      animationCurve: Curves.elasticInOut,
      overlayColor: Colors.black54,
      overlayOpacity: 0.5,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      activeForegroundColor: Theme.of(context).colorScheme.primaryContainer,
      activeBackgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      isOpenOnStart: false,
      label: const Text('Add'),
      activeLabel: const Text('Close'),
      spaceBetweenChildren: 4,
      childrenButtonSize: const Size(64, 64),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.keyboard_alt_outlined),
          shape: const CircleBorder(),
          foregroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          onTap: () async {
            openFridgeAddForm(context);
          }
        ),
        SpeedDialChild(
          child: const Icon(Icons.barcode_reader),
          shape: const CircleBorder(),
          foregroundColor: Colors.white24,
          backgroundColor: Colors.grey,
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_a_photo),
          shape: const CircleBorder(),
          foregroundColor: Colors.white24,
          backgroundColor: Colors.grey,
        )
      ]
    );
  }
}