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


  Future<void> addItem(String itemName, [int? id]) async {
    GroceryItem item = GroceryItem(name: itemName, id: id, index: state.length+1);
    addItemLocally(item);
    await groceryHandler.pushToDB(IOClient(), item);
  }

  void addItemLocally(GroceryItem item) {
    state = <GroceryItem>[...state, item];
  }

  Future<void> syncToDB() async {
    List<GroceryItem> dbItems = await groceryHandler.getAllItems(IOClient());
    state.clear();
    dbItems.sort((a,b) => a.index.compareTo(b.index));
    state = dbItems;
  }

  Future<void> removeByID(int removeID) async {
    state = state.where((i) => i.id != removeID).toList();
    groceryHandler.deleteItemByID(IOClient(), removeID);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final GroceryItem i = state.removeAt(oldIndex);
    state.insert(newIndex, i);
    await groceryHandler.updateIndicies(IOClient(), oldIndex, newIndex);
  }

  void setMovingAtAs(int index, bool isMoving) {
    if (index >= state.length) {
      index -= 1;
    }
    state.elementAt(index).isMoving = isMoving;
  }

  Future<void> sendActiveToFridge(WidgetRef ref) async {
    ref.read(fridgeNotifierProvider.notifier)
        .extendItemsWithGroceriesLocally(getActive());
    removeActiveLocally();
    await groceryHandler.sendActiveToFridge(IOClient());
}

  Future<void> removeActiveLocally() async {
    state = state.where((i) => !i.isActive).toList();
  }

  void toggleActiveAt(int index) async {
    state.elementAt(index).isActive = !state.elementAt(index).isActive;
    await groceryHandler.toggleActiveByID(IOClient(), state.elementAt(index).id!);
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

  int length() {
    return state.length;
  }

  GroceryItem elementAt(int index) {
    return state.elementAt(index);
  }

  String getShareGroceryText() {
    String message = "Grocery List:\n";
    for (GroceryItem i in state) {
      if (!i.isActive) {
        message += "- ${i.toString()}\n";
      }
    }
    return message;
  }

}

final groceryNotifierProvider = NotifierProvider<GroceryNotifier, List<GroceryItem>>(
    () {
      return GroceryNotifier();
    }
);