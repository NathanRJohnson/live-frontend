import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../handler/fridge_handler.dart';
import '../model/fridge_item.dart';

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
  Future<void> addItemByName(String itemName) async {
    FridgeItem item = FridgeItem(name: itemName, timeInFridge: "< 1 day", dateAdded: DateTime.now());
    state = <FridgeItem>[...state, item];
    await fridgeHandler.pushToDB(item);
  }

  Future<void> removeByID(int removeId) async {
    state = state.where((i) => i.id != removeId).toList();
    await fridgeHandler.deleteItemByID(removeId);
  }

  Future<void> syncToDB() async {
    List<FridgeItem> dbItems = await fridgeHandler.getAllItems();
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