

import 'package:flutter_test/flutter_test.dart';
import 'package:project_l/wtfridge/model/grocery_item.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';

void main() {
  late GroceryCardNotifier provider;
  late List<GroceryItem> items;

  setUp(() {
    provider = GroceryCardNotifier();
    items = [
      GroceryItem(name: "Bakery", index: 1, section: "Bakery"),
      GroceryItem(name: "Seafood", index: 2, section: "Seafood"),
      GroceryItem(name: "Dairy", index: 3, section: "Dairy"),
    ];
  });

  group('find insertion index', () {

    test('empty list', () {
      items = [];
      int index = provider.findInsertionPoint(items, "Seafood");
      expect(index, 0);
    });

    test('beginning of non-empty list', () {
      int index = provider.findInsertionPoint(items, "Fruit");
      expect(index, 0);
    });

    test('first group', () {
      int index = provider.findInsertionPoint(items, "Bakery");
      expect(index, 1);
    });

    test('middle of the list, no existing group', () {
      int index = provider.findInsertionPoint(items, "Meat");
      expect(index, 2);
    });

    test('middle of the list, group exists', () {
      int index = provider.findInsertionPoint(items, "Seafood");
      expect(index, 2);
    });

    test('end of list, no existing groups', () {
      int index = provider.findInsertionPoint(items, "Frozen");
      expect(index, 3);
    });

    test('end of list, group exists', () {
      int index = provider.findInsertionPoint(items, "Dairy");
      expect(index, 3);
    });
  });
}