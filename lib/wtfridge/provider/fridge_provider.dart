import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../handler/fridge_handler.dart';
import '../model/fridge_item.dart';
import '../model/grocery_item.dart';
import '../provider/grocery_provider.dart';

class FridgeNotifier extends Notifier<List<FridgeItem>> {
  FridgeHandler fridgeHandler = FridgeHandler();

  // initial value
  @override
  List<FridgeItem> build() {
    return [
      // FridgeItem(name: 'Banana', time_in_fridge: '5 days', id: 0),
      // FridgeItem(name: 'Turkey', time_in_fridge: '2 days', id: 1),
      // FridgeItem(name: 'Frutopia', time_in_fridge: '24 weeks', id: 2),
    ];
  }

  // methods to update state
  // river pod state needs to be reassigned, not just updated
  void addItemLocally(FridgeItem item) {
    state = <FridgeItem>[...state, item];
  }

  Future<void> addItem(String itemName, [int? id]) async {
    FridgeItem item = FridgeItem(name: itemName, id: id, dateAdded: DateTime.now());
    addItemLocally(item);
    await fridgeHandler.pushToDB(IOClient(), item);
  }

  void extendItemsWithGroceriesLocally(List<GroceryItem> items) {
    for (GroceryItem g in items){
      FridgeItem f = FridgeItem(name: g.name, id: g.id, dateAdded: DateTime.now());
      addItemLocally(f);
    }
  }

  Future<void> removeByID(int removeId) async {
    state = state.where((i) => i.id != removeId).toList();
    await fridgeHandler.deleteItemByID(IOClient(), removeId);
  }

  Future<void> syncToDB() async {
    List<FridgeItem> dbItems = await fridgeHandler.getAllItems(IOClient());
    state.clear();
    state = dbItems;
  }

  int length() {
    return state.length;
  }

  FridgeItem elementAt(int index) {
    FridgeItem item = state.elementAt(index);
    return item;
  }

}

final fridgeNotifierProvider = NotifierProvider<FridgeNotifier, List<FridgeItem>>(
    () {
      return FridgeNotifier();
    }
);