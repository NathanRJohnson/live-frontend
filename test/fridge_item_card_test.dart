import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/wtfridge/components/fridge_item_card.dart';
import '../lib/wtfridge/components/update_item_form.dart';
import '../lib/wtfridge/model/fridge_item.dart';

void main() {
  testWidgets('FridgeItemCard displays correct text', (tester) async {
    final item = FridgeItem(name: "Test Item", timeInFridge: "5 days");
    await tester.pumpWidget(
        MaterialApp(
            home: Scaffold(
                body: FridgeItemCard(item: item)
            )
        )
    );

    final nameFinder = find.text("Test Item");
    expect(nameFinder, findsOneWidget);

    final tifFinder = find.text("5 days");
    expect(tifFinder, findsOneWidget);
  });

  testWidgets('right swipe on card displays edit and send to fridge options', (tester) async {
    final item = FridgeItem(name: "Test Item", timeInFridge: "5 days");
    await tester.pumpWidget(
        MaterialApp(
            home: Scaffold(
                body: FridgeItemCard(item: item)
            )
        )
    );

    final widgetFinder = find.byType(FridgeItemCard);
    await tester.startGesture(tester.getCenter(widgetFinder)).then((gesture) async {
      await gesture.moveBy(const Offset(200, 0));
      await gesture.up();
    });

    await tester.pumpAndSettle(Durations.short2);

    final editFinder = find.byIcon(Icons.edit);
    final toGroceriesFinder = find.byIcon(Icons.shopping_basket_outlined);

    expect(editFinder, findsOneWidget);
    expect(toGroceriesFinder, findsOneWidget);
  });

  testWidgets('tapping on edit option displays edit form', (tester) async {
    final item = FridgeItem(name: "Test Item", timeInFridge: "5 days");
    await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
              home: Scaffold(
                  body: FridgeItemCard(item: item)
              )
          )
        )
    );

    final cardFinder = find.byType(FridgeItemCard);
    await tester.startGesture(tester.getCenter(cardFinder)).then((gesture) async {
      await gesture.moveBy(const Offset(200, 0));
      await gesture.up();
    });

    await tester.pumpAndSettle(Durations.short2);
    final editFinder = find.byIcon(Icons.edit);
    await tester.tap(editFinder);
    await tester.pumpAndSettle(Durations.short2);

    final formFinder = find.byType(UpdateItemForm);
    expect(formFinder, findsOneWidget);
  });
}