
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/fridge_item_card.dart';
import '../handler/fridge_handler.dart';
import '../model/fridge_item.dart';
import '../model/grocery_item.dart';

class AsyncState {
  final bool isLoading;
  final List<FridgeItemCard> items;
  final Exception? exception;

  AsyncState({this.isLoading = false, this.items=const [], this.exception=const CertificateException()});
}


class FridgeCardNotifier extends Notifier<AsyncState> {
  FridgeHandler fridgeHandler = FridgeHandler();
  bool isConnected = true;
  FridgeItemCardState? currentExpandedTileState;

  // initial value
  @override
  AsyncState build() {
    return AsyncState(
        isLoading: false,
        items: [],
        exception: const CertificateException("Could not connect to backend services.")
      );
  }

  // methods to update state
  // river pod state needs to be reassigned, not just updated
  void addItemLocally(FridgeItem item) {
    state = AsyncState(
     isLoading: false,
     items: <FridgeItemCard>[...state.items,
       FridgeItemCard(
         key: UniqueKey(),
         item: item,
       )],
    );
  }

  Future<void> addItem(Map<String, String> values, [int? id]) async {
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
    await fridgeHandler.pushToDB(item);
  }

  void extendItemsWithGroceriesLocally(List<GroceryItem> items) {
    for (GroceryItem g in items) {
      FridgeItem f = FridgeItem(name: g.name, id: g.id, dateAdded: DateTime.now());
      addItemLocally(f);
    }
  }

  Future<void> remove(FridgeItem item) async {
    if (state.items.isEmpty) return;

    state = AsyncState(
        items: state.items.where((c) => c.item.id! != item.id).toList()
    );
    await fridgeHandler.deleteItemByID(item.id!);
  }

  Future<void> removeByID(int removeId) async {
    await fridgeHandler.deleteItemByID(removeId);
    state = AsyncState(
        items: state.items.where((i) => i.item.id != removeId).toList()
    );
  }

  updateItemByID(Map<String, dynamic> newValues, {bool rebuild=true}) async {
    FridgeItem item = state.items.where((c) => c.item.id == newValues["item_id"]!).first.item;
    await fridgeHandler.updateItem(Map.from(newValues));

    if (rebuild){
      List<FridgeItemCard> updatedItems = [
        for (FridgeItemCard current in state.items)
          if (item.id == current.item.id)
            FridgeItemCard(key: UniqueKey(), item: FridgeItem(
              id: item.id,
              name: newValues.containsKey("new_name") ? newValues["new_name"] as String : item.name,
              dateAdded: newValues.containsKey("new_date") ? newValues["new_date"] as DateTime : item.dateAdded,
              quantity: newValues.containsKey("new_quantity") ? newValues["new_quantity"] as int : item.quantity,
              notes: newValues.containsKey("new_notes") ? newValues["new_notes"] as String : item.notes,
            ))
          else
            current
      ];
      state = AsyncState(
        items: updatedItems
      );
    }
  }

  Future<void> syncToDB() async {
    state = AsyncState(isLoading: true);
    try {
      List<FridgeItem> dbItems = await fridgeHandler.getAllItems();
      List<FridgeItemCard> cards = [];
      for (FridgeItem item in dbItems) {
        FridgeItemCard c = FridgeItemCard(item: item);
        cards.add(c);
      }
      state = AsyncState(items: cards, exception: null);
      isConnected = true;
    } on Exception catch(e) {
      state = AsyncState(exception: e);
    }
  }

  bool isInitiallyExpanded(FridgeItemCardState etc) {
    return currentExpandedTileState == etc;
  }

  void setCurrentlyExpandedTile(FridgeItemCardState? etc) {
    if (currentExpandedTileState?.controller.isExpanded ?? false) {
      currentExpandedTileState?.controller.collapse();
      currentExpandedTileState = null;
    }
    currentExpandedTileState = etc;
  }

  int length() {
    return state.items.length;
  }

  FridgeItemCard elementAt(int index) {
    FridgeItemCard item = state.items.elementAt(index);
    return item;
  }

  Set<String> getAllItemNames() {
    return {for (FridgeItemCard c in state.items) c.item.name};
  }

}

final fridgeCardNotifierProvider = NotifierProvider<FridgeCardNotifier, AsyncState>(
        () {
      return FridgeCardNotifier();
    }
);