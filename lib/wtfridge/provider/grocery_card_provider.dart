

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/fridge_card_provider.dart';
import '../model/fridge_item.dart';
import '../components/grocery_item_card.dart';
import '../handler/grocery_handler.dart';
import '../model/grocery_item.dart';

class GroceryCardNotifier extends Notifier<List<GroceryItemCard>> {
  final GroceryHandler groceryHandler = GroceryHandler();

  @override
  List<GroceryItemCard> build() {
    return [];
  }

  Future<void> syncToDB() async {
    List<GroceryItem> dbItems = await groceryHandler.getAllItems();
    List<GroceryItemCard> cards = [];
    for (GroceryItem item in dbItems) {
      GroceryItemCard g = GroceryItemCard(key: UniqueKey(), item: item);
      cards.add(g);
    }
    cards.sort((a,b) => a.item.index.compareTo(b.item.index));
    state = cards;
  }

  Future<void> addItem(Map<String, String> values, [int? id]) async {
    int quantity = values["quantity"] != null ? int.parse(values["quantity"]!) : 1;
    String notes = values["notes"] != null ? values["notes"]! : "";
    String section = values["section"] != "" ? values["section"]! : GroceryItem.getSections()[0];
    String store = values["store"] != "" ? values["store"]! : GroceryItem.getStores()[0];
    int insertionIndex = findInsertionPoint([for (var c in state) c.item], section);

    GroceryItem item = GroceryItem(
      name: values["item_name"]!,
      quantity: quantity,
      notes: notes,
      id: id,
      index: insertionIndex,
      isActive: false,
      section: section,
      store: store
    );
    await groceryHandler.pushToDB(item);
    syncToDB();
  }

  int findInsertionPoint(List<GroceryItem> items, String section) {
    if (items.isEmpty) {
      return 0;
    }

    final sections = GroceryItem.getSections();
    final lookup = {for (int i = 0; i < sections.length; i++) sections[i] : i};

    int l = 0;
    int r = items.length - 1;
    int insertPoint = items.length;
    int m = 0;

    // TODO: need better null guards
    int t = lookup[section]!;

    while (l <= r) {
      m = l + (r - l) ~/ 2;
      if (lookup[items[m].section]! == t) {
        l = m+1;
        insertPoint = m + 1;
      }
      else if (lookup[items[m].section]! < t) {
        l = m+1;
      }
      else if (lookup[items[m].section]! > t) {
        r = m-1;
        insertPoint = m;
      }
    }

    return insertPoint;
  }

  Future<void> addItemFromFridge(FridgeItem f) async {
      Map<String, String> map = {
        "item_name": f.name,
        "quantity": f.quantity.toString(),
        "notes": f.notes,
      };
      return await addItem(map);
  }

  void addItemLocally(GroceryItem item) {
    state = <GroceryItemCard>[...state,
      GroceryItemCard(
        key: UniqueKey(),
        item: item
      )];
  }

  Future<void> remove(GroceryItem item) async {
    if (state.isEmpty) {
      return;
    }
    state = state.where((c) => c.item.id != item.id).toList();
    await groceryHandler.deleteItemByID(item.id!);
  }

  Future<void> updateItemByID(Map<String, dynamic> newValues) async {
    GroceryItem item = state.where((c) => c.item.id == newValues["item_id"]!).first.item;
    await groceryHandler.updateItem(newValues);
    state = [
      for (GroceryItemCard current in state)
        if (item.id == current.item.id)
          GroceryItemCard(key: UniqueKey(), item: GroceryItem(
            id: item.id,
            name: newValues["new_name"] as String,
            index: item.index,
            isActive: item.isActive,
            quantity: newValues["new_quantity"] as int,
            notes: newValues["new_notes"] as String,
          ))
        else
          current
    ];
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final GroceryItemCard card = state.removeAt(oldIndex);
    state.insert(newIndex, card);
    await groceryHandler.updateIndicies(oldIndex, newIndex);
  }

  void setMovingAtAs(int index, bool isMoving) {
    if (index >= state.length) {
      index -= 1;
    }
    state.elementAt(index).isMoving = isMoving;
  }


  // TODO: this function is kind of a mess
  Future<void> toggleActive(GroceryItem item) async {
    List<GroceryItemCard> currentList = state;
    // currentList.first.item.isActive = !currentList.first.item.isActive;
    state.where((card) => card.item.id == item.id).first.item.isActive = !item.isActive;
    state = List.from(currentList);
    await groceryHandler.toggleActiveByID(item.id!, item.isActive);
  }

  Future<void> sendActiveToFridge(WidgetRef ref) async {
    ref.read(fridgeCardNotifierProvider.notifier)
        .extendItemsWithGroceriesLocally(getActive());
    removeActiveLocally();
    await groceryHandler.sendActiveToFridge();
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

  Set<String> getAllItemNames() {
    return {for (GroceryItemCard c in state) c.item.name};
  }

}

final groceryCardNotifierProvider = NotifierProvider<GroceryCardNotifier, List<GroceryItemCard>>(
  () {
    return GroceryCardNotifier();
  }
);