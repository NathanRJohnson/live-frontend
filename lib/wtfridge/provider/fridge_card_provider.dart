
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../components/fridge_item_card.dart';
import '../handler/fridge_handler.dart';
import '../model/fridge_item.dart';
import '../model/grocery_item.dart';

class FridgeCardNotifier extends Notifier<List<FridgeItemCard>> {
  FridgeHandler fridgeHandler = FridgeHandler();
  bool isConnected = true;

  // initial value
  @override
  List<FridgeItemCard> build() {
    return [
      FridgeItemCard(item: FridgeItem(name: "Test Item 1", timeInFridge: "3 days", id: 0, dateAdded: DateTime(2022))),
      FridgeItemCard(item: FridgeItem(name: "Test Item 2", timeInFridge: "7 days", id: 1, dateAdded: DateTime(2022))),
      FridgeItemCard(item: FridgeItem(name: "Test Item 3", timeInFridge: "11 days", id: 2, dateAdded: DateTime(2022))),

      FridgeItemCard(item: FridgeItem(name: "Test Item 4", timeInFridge: "3 days", id: 0, dateAdded: DateTime(2022))),
      FridgeItemCard(item: FridgeItem(name: "Test Item 5", timeInFridge: "7 days", id: 1, dateAdded: DateTime(2022))),
      FridgeItemCard(item: FridgeItem(name: "Test Item 6", timeInFridge: "11 days", id: 2, dateAdded: DateTime(2022))),

      FridgeItemCard(item: FridgeItem(name: "Test Item 7", timeInFridge: "3 days", id: 0, dateAdded: DateTime(2022))),
      FridgeItemCard(item: FridgeItem(name: "Test Item 8", timeInFridge: "7 days", id: 1, dateAdded: DateTime(2022))),
      FridgeItemCard(item: FridgeItem(name: "Test Item 9", timeInFridge: "11 days", id: 2, dateAdded: DateTime(2022))),

      // FridgeItemCard(item: FridgeItem(name: "Test Item 10", timeInFridge: "3 days", id: 0, dateAdded: DateTime(2022))),
      // FridgeItemCard(item: FridgeItem(name: "Test Item 11", timeInFridge: "7 days", id: 1, dateAdded: DateTime(2022))),
      // FridgeItemCard(item: FridgeItem(name: "Test Item 12", timeInFridge: "11 days", id: 2, dateAdded: DateTime(2022))),

    ];
  }

  // methods to update state
  // river pod state needs to be reassigned, not just updated
  void addItemLocally(FridgeItem item) {
    state = <FridgeItemCard>[...state,
      FridgeItemCard(
          key: UniqueKey(),
          item: item,
      )];
  }

  Future<void> addItem(Client client, String itemName, [int? id]) async {
    FridgeItem item = FridgeItem(name: itemName, id: id, dateAdded: DateTime.now());
    addItemLocally(item);
    await fridgeHandler.pushToDB(client, item);
  }

  void extendItemsWithGroceriesLocally(List<GroceryItem> items) {
    for (GroceryItem g in items){
      FridgeItem f = FridgeItem(name: g.name, id: g.id, dateAdded: DateTime.now());
      addItemLocally(f);
    }
  }

  Future<void> remove(Client client, FridgeItem item) async {
    if (state.isEmpty) return;

    state = state.where((c) => c.item.id! != item.id).toList();
    await fridgeHandler.deleteItemByID(client, item.id!);
  }

  Future<void> removeByID(Client client, int removeId) async {
    await fridgeHandler.deleteItemByID(client, removeId);
    state = state.where((i) => i.item.id != removeId).toList();
  }

  Future<void> syncToDB(Client client) async {
    try {
      List<FridgeItem> dbItems = await fridgeHandler.getAllItems(client);
      List<FridgeItemCard> cards = [];
      for (FridgeItem item in dbItems) {
        FridgeItemCard c = FridgeItemCard(item: item);
        cards.add(c);
      }
      state = cards;
      isConnected = true;
    } on ClientException catch(e) {
      print(e.message);
      isConnected = false;
    }
  }

  int length() {
    return state.length;
  }

  FridgeItemCard elementAt(int index) {
    FridgeItemCard item = state.elementAt(index);
    return item;
  }

}

final fridgeCardNotifierProvider = NotifierProvider<FridgeCardNotifier, List<FridgeItemCard>>(
        () {
      return FridgeCardNotifier();
    }
);