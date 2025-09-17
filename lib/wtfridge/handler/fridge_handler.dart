import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:project_l/wtfridge/storage/database.dart' as DB;

import '../model/fridge_item.dart';


class FridgeHandler {

  final database = DB.AppDatabase.instance;

  // constructor
  FridgeHandler() {}

  Future<void> pushToDB(FridgeItem i) async {
    await database.into(database.fridgeItems).insert(DB.FridgeItemsCompanion.insert(
        itemId: i.id!,
        name: i.name,
        dateAdded: i.dateAdded!,
        quantity: i.quantity,
        notes: i.notes
    ));
  }

  Future<List<FridgeItem>> getAllItems() async {
    List<DB.FridgeItem> dbItems = await database.select(database.fridgeItems).get();
  // TODO: would love to get rid of the quirk where I need to convert from the dbItem to the original data item
    List<FridgeItem> items = dbItems.map((dbItem) {
      return FridgeItem(
        id: dbItem.itemId,
        name: dbItem.name,
        dateAdded: dbItem.dateAdded,
        quantity: dbItem.quantity,
        notes: dbItem.notes,
      );
    }).toList();
    return items;
  }

  Future<void> deleteItemByID(int itemID) async {
    await database.managers.fridgeItems.filter((f) => f.itemId.equals(itemID)).delete();
  }

  Future<void> copyToGroceryByID(int itemID) async {

  }

  updateItem(Map<String, dynamic> newValues) async {
    if (newValues.containsKey("new_date")) {
      newValues["new_date"] = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(
          (newValues["new_date"] as DateTime).toUtc());
    }

    await database.managers.fridgeItems
        .filter((f) => f.itemId.equals(newValues["item_id"]))
        .update((o) => o(
          name: Value(newValues["new_name"]),
          quantity: Value(newValues["new_quantity"]),
          dateAdded: Value(DateTime.parse(newValues["new_date"])),
          notes: Value(newValues["new_notes"])
    ));
  }

}