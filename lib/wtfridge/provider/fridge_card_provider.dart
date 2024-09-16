
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/src/io_client.dart';

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
      FridgeItemCard(item: FridgeItem(id: 100, name:"yogurt", quantity: 3))
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

  Future<void> addItem(Client client, Map<String, String> values, [int? id]) async {
    int quantity = values["quantity"] != null ? int.parse(values["quantity"]!) : 1;
    DateTime dateAdded = values["date_added"] != null ? DateTime.parse(values["date_added"]!) : DateTime.now();
    String notes = values["notes"] != null ? values["notes"]! : "oya";

    FridgeItem item = FridgeItem(
      name: values["item_name"]!,
      quantity: quantity,
      notes: notes,
      id: id,
      dateAdded: dateAdded
    );
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

  updateItemByID(IOClient client, Map<String, dynamic> newValues) async {
    FridgeItem item = state.where((c) => c.item.id == newValues["item_id"]!).first.item;
    await fridgeHandler.updateItem(client, Map.from(newValues));

    state = [
      for (FridgeItemCard current in state)
        if (item.id == current.item.id)
          FridgeItemCard(key: UniqueKey(), item: FridgeItem(
            id: item.id,
            name: newValues["new_name"] as String,
            dateAdded: newValues["new_date"] as DateTime,
            quantity: newValues["new_quantity"] as int,
            notes: newValues["new_notes"] as String,
          ))
        else
          current
    ];
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