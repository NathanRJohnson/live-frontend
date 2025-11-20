

import 'dart:convert';

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:project_l/wtfridge/storage/database.dart' as DB;

import '../lib/wtfridge/handler/grocery_handler.dart';
import '../lib/wtfridge/model/grocery_item.dart';
import 'fridge_handler_test.mocks.dart';

// dart run build_runner build
@GenerateMocks([Client])
void main() {
  late GroceryHandler handler;
  late DB.AppDatabase database;
  
  final List<GroceryItem> items = [
    GroceryItem(name: "Apple", index: 1, id: 1),
    GroceryItem(name: "Banana", index: 2, id: 2),
    GroceryItem(name: "Cantaloupe", index: 3, id: 3)
  ];
  
  setUp(() {
    database = DB.AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      )
    );
    handler = GroceryHandler(database: database);
  });
  
  tearDown(() async {
    await database.close();
  });

  group('basic operations', () {
    test('adding items', () async {
      for (int i = 0; i < 3; i++) {
        handler.pushToDB(items[i]);
      }

      final ioi = await database.managers.groceryItems.count();

      expect(ioi, 3);
    });
  });

  group('reordering items', () {
    test('moving last item to top', () async {
      for (int i = 0; i < 3; i++) {
        handler.pushToDB(items[i]);
      }

      List<GroceryItem> current = await handler.getAllItems();
      assert(current[0].id == 1 && current[0].index == 1);
      assert(current[2].id == 3 && current[2].index == 3);

      await handler.updateIndicies(2, 0);

      current = await handler.getAllItems();
      for (GroceryItem c in current)  {
        print("${c.name}: ${c.index}");
      }
      expect(current[0].index, 2);
      expect(current[1].index, 3);
      expect(current[2].index, 1);
    });

    test('moving first item to bottom', () async {
      for (int i = 0; i < 3; i++) {
        handler.pushToDB(items[i]);
      }

      List<GroceryItem> current = await handler.getAllItems();
      assert(current[0].id == 1 && current[0].index == 1);
      assert(current[2].id == 3 && current[2].index == 3);

      await handler.updateIndicies(0, 2);

      current = await handler.getAllItems();
      for (GroceryItem c in current)  {
        print("${c.name}: ${c.index}");
      }

      expect(current[0].index, 3);
      expect(current[1].index, 1);
      expect(current[2].index, 2);
    });
  });
}