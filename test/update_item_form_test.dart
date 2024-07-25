

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_l/wtfridge/components/update_item_form.dart';

String action(String s) {
  return s;
}

void main() {

  testWidgets('Edit form submitted without text displays error', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: UpdateItemForm(action: action, currentContent: "Test")))
    );

    final errorFinder = find.text("Item name must contain a character.");
    expect(errorFinder, findsNothing);

    final textFieldFinder = find.byType(TextFormField);
    await tester.enterText(textFieldFinder, '');

    final updateButton = find.widgetWithText(TextButton, "Update");
    await tester.tap(updateButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(errorFinder, findsOneWidget);
  });

  testWidgets('Edit form submitted with old text closes AlertDialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: UpdateItemForm(action: action, currentContent: "Test")))
    );

    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final updateButton = find.widgetWithText(TextButton, "Update");
    await tester.tap(updateButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(alertDialogFinder, findsNothing);
  });

  testWidgets('Edit form submitted with new text closes AlertDialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: UpdateItemForm(action: action, currentContent: "Test")))
    );

    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final textFieldFinder = find.byType(TextFormField);
    await tester.enterText(textFieldFinder, 'New Item');

    final updateButton = find.widgetWithText(TextButton, "Update");
    await tester.tap(updateButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(alertDialogFinder, findsNothing);
  });

  testWidgets('Edit form submitted with old text closes AlertDialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: UpdateItemForm(action: action, currentContent: "Test")))
    );

    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final cancelButton = find.widgetWithText(TextButton, "Cancel");
    await tester.tap(cancelButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(alertDialogFinder, findsNothing);
  });



}