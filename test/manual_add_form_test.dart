
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_l/wtfridge/components/manual_add_form.dart';

void main() {

  testWidgets('Add button closes alert if text is provided', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: ManualAddForm(action_type: "test")))
    );

    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final textFieldFinder = find.byType(TextFormField);
    await tester.enterText(textFieldFinder, 'Test Item');

    final addButton = find.widgetWithText(TextButton, "Add");
    await tester.tap(addButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(alertDialogFinder, findsNothing);
  });

  testWidgets('Add button displays error if no text is provided', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: ManualAddForm(action_type: "test")))
    );
    final errorFinder = find.text("Please enter a name for the item.");
    expect(errorFinder, findsNothing);
    
    final addButton = find.widgetWithText(TextButton, "Add");
    
    await tester.tap(addButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(errorFinder, findsOneWidget);
  });

  testWidgets('Add & Continue button refreshes alert dialog if text is provided', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: ManualAddForm(action_type: "test")))
    );

    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final textFieldFinder = find.byType(TextFormField);
    await tester.enterText(textFieldFinder, 'Test Item');

    expect(find.text('Test Item'), findsOneWidget);

    final addAndContinueButton = find.widgetWithText(TextButton, "Add & Continue");
    await tester.tap(addAndContinueButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(find.text('Test Item'), findsNothing);
    expect(alertDialogFinder, findsOneWidget);
  });

  testWidgets('Add & Continue button displays error if no text is provided', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: ManualAddForm(action_type: "test")))
    );
    final errorFinder = find.text("Please enter a name for the item.");
    expect(errorFinder, findsNothing);

    final addAndContinueButton = find.widgetWithText(TextButton, "Add & Continue");

    await tester.tap(addAndContinueButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(errorFinder, findsOneWidget);
  });

  testWidgets('Cancel button closes alert dialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: AlertDialog(content: ManualAddForm(action_type: "test")))
    );

    var alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final cancelButton = find.widgetWithText(TextButton, "Cancel");
    await tester.tap(cancelButton);
    await tester.pumpAndSettle(Durations.short1);

    expect(alertDialogFinder, findsNothing);
  });

}