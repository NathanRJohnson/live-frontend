import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../handler/grocery_handler.dart';
import '../model/grocery_item.dart';
import '../provider/fridge_provider.dart';

class GroceryNotifier extends Notifier<List<GroceryItem>> {
  final GroceryHandler groceryHandler = GroceryHandler();

  @override
  List<GroceryItem> build() {
    return [
      // GroceryItem(name: "apples"),
      // GroceryItem(name: "yogurt"),
      // GroceryItem(name: "croque matin")
    ];
  }

  void addItemLocally(GroceryItem item) {
    state = <GroceryItem>[...state, item];
  }

  Future<void> addItem(String itemName, [int? id]) async {
    GroceryItem item = GroceryItem(name: itemName, id: id);
    addItemLocally(item);
    await groceryHandler.pushToDB(item);
  }

  Future<void> syncToDB() async {
    List<GroceryItem> dbItems = await groceryHandler.getAllItems(IOClient());
    state.clear();
    state = dbItems;
  }

  Future<void> removeByID(int removeID) async {
    state = state.where((i) => i.id != removeID).toList();
    groceryHandler.deleteItemByID(removeID);
  }

  Future<void> sendActiveToFridge(WidgetRef ref) async {
    ref.read(fridgeNotifierProvider.notifier)
        .extendItemsWithGroceriesLocally(getActive());
    removeActiveLocally();
    await groceryHandler.sendActiveToFridge();
}

  Future<void> removeActiveLocally() async {
    state = state.where((i) => !i.isActive).toList();
  }

  void considerDeleting(GroceryItem item) {
    item.isBeingDeleted = true;
  }

  void cancelDeleting(GroceryItem item) {
    item.isBeingDeleted = false;
  }

  int length() {
    return state.length;
  }

  GroceryItem elementAt(int index) {
    return state.elementAt(index);
  }

  void toggleActiveAt(int index) async {
    state.elementAt(index).isActive = !state.elementAt(index).isActive;
    await groceryHandler.toggleActiveByID(state.elementAt(index).id!);
  }

  int countActive() {
    int count = 0;
    for (GroceryItem g in state) {
      count += g.isActive ? 1 : 0;
    }
    return count;
  }

  List<GroceryItem> getActive() {
    List<GroceryItem> items = [];
    for (GroceryItem g in state) {
      if (g.isActive) {
        items.add(g);
      }
    }
    return items;
  }

}

final groceryNotifierProvider = NotifierProvider<GroceryNotifier, List<GroceryItem>>(
    () {
      return GroceryNotifier();
    }
);