

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../provider/fridge_provider.dart';
import '../components/grocery_item_card.dart';
import '../handler/grocery_handler.dart';
import '../model/grocery_item.dart';

class GroceryCardNotifier extends Notifier<List<GroceryItemCard>> {
  final GroceryHandler groceryHandler = GroceryHandler();

  @override
  List<GroceryItemCard> build() {
    return [];
  }

  Future<void> syncToDB(Client client) async {
    List<GroceryItem> dbItems = await groceryHandler.getAllItems(client);
    List<GroceryItemCard> cards = [];
    for (GroceryItem item in dbItems) {
      GroceryItemCard g = GroceryItemCard(key: UniqueKey(), item: item);
      cards.add(g);
    }
    cards.sort((a,b) => a.item.index.compareTo(b.item.index));
    state = cards;
  }

  Future<void> addItem(Client client, String itemName, [int? id]) async {
    GroceryItem newItem = GroceryItem(name: itemName, id: id, index: state.length+1);
    state = <GroceryItemCard>[...state, GroceryItemCard(key: UniqueKey(), item: newItem)];
    await groceryHandler.pushToDB(client, newItem);
  }

  Future<void> remove(Client client, GroceryItem item) async {
    if (state.isEmpty) {
      return;
    }
    state = state.where((c) => c.item.id != item.id).toList();
    await groceryHandler.deleteItemByID(client, item.id!);
  }

  Future<void> updateNameByID(Client client, int updateID, String newName) async {
    GroceryItem item = state.where((c) => c.item.id == updateID).first.item;
    item.name = newName;
    await groceryHandler.renameItemByID(client, updateID, newName);
  }

  Future<void> reorder(Client client, int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final GroceryItemCard card = state.removeAt(oldIndex);
    state.insert(newIndex, card);
    await groceryHandler.updateIndicies(client, oldIndex, newIndex);
  }

  void setMovingAtAs(int index, bool isMoving) {
    if (index >= state.length) {
      index -= 1;
    }
    state.elementAt(index).isMoving = isMoving;
  }

  Future<void> toggleActive(Client client, GroceryItem item) async {
    List<GroceryItemCard> currentList = state;
    // currentList.first.item.isActive = !currentList.first.item.isActive;
    state.where((card) => card.item.id == item.id).first.item.isActive = !item.isActive;
    state = List.from(currentList);
    await groceryHandler.toggleActiveByID(client, item.id!);
  }

  Future<void> sendActiveToFridge(Client client, WidgetRef ref) async {
    ref.read(fridgeNotifierProvider.notifier)
        .extendItemsWithGroceriesLocally(getActive());
    removeActiveLocally();
    await groceryHandler.sendActiveToFridge(client);
  }

  List<GroceryItem> getActive() {
    List<GroceryItem> items = [];
    for (GroceryItemCard card in state) {
      if (card.item.isActive) {
        items.add(card.item);
      }
    }
    return items;
  }

  Future<void> removeActiveLocally() async {
    state = state.where((c) => !c.item.isActive).toList();
  }

  int countActive() {
    int count = 0;
    for (GroceryItemCard c in state) {
      count += c.item.isActive ? 1 : 0;
    }
    return count;
  }

  String getShareGroceryText() {
    String message = "Grocery List:\n";
    for (GroceryItemCard c in state) {
      if (!c.item.isActive) {
        message += "- ${c.item.toString()}\n";
      }
    }
    return message;
  }
}

final groceryCardNotifierProvider = NotifierProvider<GroceryCardNotifier, List<GroceryItemCard>>(
  () {
    return GroceryCardNotifier();
  }
);