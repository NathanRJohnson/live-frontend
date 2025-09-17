import 'package:drift/drift.dart';
import 'package:project_l/wtfridge/storage/database.dart' as DB;

import '../model/grocery_item.dart';


class GroceryHandler {
  final database = DB.AppDatabase.instance;

  GroceryHandler();


  Future<void> pushToDB(GroceryItem newItem) async {
    await database.managers.groceryItems
      .create((i) => i(
        itemId: newItem.id!,
        index: newItem.index,
        name: newItem.name,
        isActive: false,
        quantity: newItem.quantity,
        notes: newItem.notes,
    ));
  }


  Future<List<GroceryItem>> getAllItems() async {
    List<DB.GroceryItem> dbItems = await database.managers.groceryItems.get();
    List<GroceryItem> items = dbItems.map((dbItem) {
      return GroceryItem(
        id: dbItem.itemId,
        index: dbItem.index,
        name: dbItem.name,
        isActive: dbItem.isActive,
        quantity: dbItem.quantity,
        notes: dbItem.notes,
      );
    }).toList();
    return items;
  }


  Future<void> deleteItemByID(int itemID) async {
    database.transaction(() async {
      DB.GroceryItem deletedItem = await database.managers.groceryItems.filter((
          g) => g.itemId.equals(itemID)).getSingle();
      int lastIndex = await database.managers.groceryItems.count();

      await database.managers.groceryItems.filter((g) =>
          g.itemId.equals(itemID)).delete();

      // reindex everything after the deleted item
      await database.updateGroceryIndicies(deletedItem.index, lastIndex);
    });
  }


  Future<void> updateItem(Map<String, dynamic> newValues) async {
    await database.managers.groceryItems
        .filter((g) => g.itemId.equals(newValues["item_id"]))
        .update((o) => o(
          name: Value(newValues["new_name"]),
          quantity: Value(newValues["new_quantity"]),
          notes: Value(newValues["new_notes"])
        ));
  }


  Future<void> toggleActiveByID(int itemID, bool newState) async {
    await database.managers.groceryItems
      .filter((g) => g.itemId.equals(itemID))
      .update((o) => o(
       isActive: Value(newState)
      ));
  }


  Future<void> sendActiveToFridge() async {
    await database.transaction(() async {
      List<DB.GroceryItem> activeItems = await database.managers.groceryItems
          .filter((g) => g.isActive.equals(true)).get();
      await database.transaction(() async {
        await database.managers.fridgeItems.bulkCreate((f) =>
            activeItems.map(
                    (groceryItem) =>
                    f(
                      itemId: groceryItem.itemId,
                      name: groceryItem.name,
                      dateAdded: DateTime.now(),
                      quantity: groceryItem.quantity,
                      notes: groceryItem.notes,
                    )
            ).toList()
        );

        await database.managers.groceryItems
            .filter((g) => g.isActive.equals(true)).delete();
      });
    });
  }


  Future<void> updateIndicies(int oldIndex, int newIndex) async {
    if (newIndex == oldIndex) {
      return;
    }

    // index offset
    newIndex += 1;
    oldIndex += 1;

    await database.transaction(() async {
      DB.GroceryItem shiftedItem = await database.managers.groceryItems
          .filter((g) => g.index.equals(oldIndex)).getSingle();

      await database.updateGroceryIndicies(oldIndex, newIndex);

      await database.managers.groceryItems
        .filter((g) => g.itemId.equals(shiftedItem.itemId))
        .update((o) => o(index: Value(newIndex)));
    });
  }

}