import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../lib/wtfridge/components/grocery_item_card.dart';
import '../lib/wtfridge/components/update_item_form.dart';
import '../lib/wtfridge/model/grocery_item.dart';
import '../lib/wtfridge/provider/grocery_card_provider.dart';
import 'grocery_handler_test.mocks.dart';

void main() {
  testWidgets('GroceryItemCard displays correct text', (tester) async {
    final item = GroceryItem(name: "Test Item");
    await tester.pumpWidget(MaterialApp(
      home: GroceryItemCard(key: UniqueKey(), item: item)
    ));

    final textFinder = find.text("Test Item");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('GroceryItemCard toggles item\'s active state on tap', (tester) async {
    final item = GroceryItem(id: 123, name: "Test Item");

    final client = MockClient();
    when(client
        .patch(Uri.http("3.96.14.111", "/grocery/123")))
        .thenAnswer((_) async =>
        Response('', 200));

    final card =  GroceryItemCard(key: UniqueKey(), item: item, client: client);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: card)
      ),
    );

    final element = tester.element(find.byType(GroceryItemCard));
    final container = ProviderScope.containerOf(element);

    container.read(groceryCardNotifierProvider).add(card);

    await tester.tap(find.byType(GroceryItemCard));
    expect(item.isActive, true);

    await tester.tap(find.byType(GroceryItemCard));
    expect(item.isActive, false);
  });

  testWidgets('GroceryItemCard displays delete and edit on swipe right', (tester) async {
    final item = GroceryItem(id: 123, name: "Test Item");
    final card =  GroceryItemCard(key: UniqueKey(), item: item, client: MockClient());

    await tester.pumpWidget(
      ProviderScope(
          child: MaterialApp(home: card)
      ),
    );

    final widgetFinder = find.byType(GroceryItemCard);
    await tester.startGesture(tester.getCenter(widgetFinder)).then((gesture) async {
      await gesture.moveBy(const Offset(200, 0));
      await gesture.up();
    });

    await tester.pumpAndSettle(Durations.short2);

    final optionFinder = find.byType(SlidableAction);
    expect(optionFinder, findsNWidgets(2));
  });

  testWidgets('GroceryItemCard edit button displays update form on tap', (tester) async {
    final item = GroceryItem(id: 123, name: "Test Item");
    final card =  GroceryItemCard(key: UniqueKey(), item: item, client: MockClient());

    await tester.pumpWidget(
      ProviderScope(
          child: MaterialApp(home: card)
      ),
    );

    final cardFinder = find.byType(GroceryItemCard);
    await tester.startGesture(tester.getCenter(cardFinder)).then((gesture) async {
      await gesture.moveBy(const Offset(200, 0));
      await gesture.up();
    });

    await tester.pumpAndSettle(Durations.short2);
    final iconFinder = find.byIcon(Icons.edit);
    await tester.tap(iconFinder);
    await tester.pumpAndSettle(Durations.short2);
    final formFinder = find.byType(UpdateItemForm);
    expect(formFinder, findsOneWidget);
  });

  testWidgets('GroceryItemCard delete button hides item on tap', (tester) async {
    final item = GroceryItem(id: 123, name: "Test Item");

    final card =  GroceryItemCard(key: UniqueKey(), item: item, client: MockClient());
    await tester.pumpWidget(
      ProviderScope(
          child: MaterialApp(home: card)
      ),
    );

    final cardFinder = find.byType(GroceryItemCard);
    await tester.startGesture(tester.getCenter(cardFinder)).then((gesture) async {
      await gesture.moveBy(const Offset(200, 0));
      await gesture.up();
    });

    await tester.pumpAndSettle(Durations.short2);
    final iconFinder = find.byIcon(Icons.delete);
    iconFinder.evaluate();
    await tester.tap(iconFinder);
    await tester.pumpAndSettle(Durations.extralong4);
    final cardFinder2 = find.byType(GroceryItemCard);
    expect(cardFinder2.hitTestable(), findsNothing);
  });
}

