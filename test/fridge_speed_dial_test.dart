
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_l/wtfridge/components/grocery_add_button.dart';

import '../lib/wtfridge/components/fridge_add_form.dart';
import '../lib/wtfridge/components/fridge_speed_dial.dart';
import '../lib/wtfridge/components/common/item_action_form.dart';

void main() {
  testWidgets('Grocery add button displays 3 options on tap', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(floatingActionButton: FridgeSpeedDial()),
    ));

    final groceryAddButtonFinder = find.byType(FridgeSpeedDial);
    await tester.tap(groceryAddButtonFinder);
    await tester.pumpAndSettle(Durations.short1);

    final option1Finder = find.byIcon(Icons.keyboard_alt_outlined);
    expect(option1Finder, findsOneWidget);

    final option2Finder = find.byIcon(Icons.add_a_photo);
    expect(option2Finder, findsOneWidget);

    final option3Finder = find.byIcon(Icons.barcode_reader);
    expect(option3Finder, findsOneWidget);
  });

  testWidgets('manual add option displays add form on tap', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(floatingActionButton: FridgeSpeedDial()),
    ));

    final groceryAddButtonFinder = find.byType(FridgeSpeedDial);
    await tester.tap(groceryAddButtonFinder);
    await tester.pumpAndSettle(Durations.short1);

    final manualAddOptionFinder = find.byIcon(Icons.keyboard_alt_outlined);
    await tester.tap(manualAddOptionFinder);
    await tester.pumpAndSettle(Durations.short1);

    final addFormFinder = find.byType(FridgeAddForm);
    expect(addFormFinder, findsOneWidget);
  });


}