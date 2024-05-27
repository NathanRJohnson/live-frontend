

import 'dart:convert';

import 'package:http/http.dart';

import '../model/grocery_item.dart';

class GroceryHandler {

  final Uri url = Uri.http("3.96.14.111", "/grocery/");

  GroceryHandler();

  Future<void> pushToDB(GroceryItem i) async {
    var body = jsonEncode(i);

    var response = await post(url, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Item added!");
    } else {
      print("Failed to add Item: [${response.statusCode}] ${response.body}");
    }
  }

  Future<List<GroceryItem>> getAllItems() async {
    List<GroceryItem> dbItems = [];

    var response = await get(url);
    if (response.statusCode == 200) {
      // TODO: fix api to not return the word null on empty list
      if (response.body != "null" && response.body.isNotEmpty) {
        List<dynamic> jsonItems = json.decode(response.body);
        for (Map<String, dynamic> itemMap in jsonItems) {
          try {
            GroceryItem newItem = GroceryItem.fromJSON(itemMap);
            dbItems.add(newItem);
          } on Exception catch (e) {
            print(e.toString());
            continue;
          }
        }
      }
    }
    return dbItems;
  }

  Future<void> deleteItemByID(int itemID) async {
    var request = url.resolve(itemID.toString());

    var response = await delete(request);
    if (response.statusCode == 200) {
      print("Grocery item deleted!");
    } else {
      print("Failed to delete grocery item");
    }
  }

  Future<void> toggleActiveByID(int itemID) async {
    var request = url.resolve(itemID.toString());

    var response = await patch(request);
    if (response.statusCode == 200) {
      print("Grocery item toggled active!");
    } else {
      print("Failed to toggle grocery item");
    }
  }

  Future<void> sendActiveToFridge() async {
    var request = url.resolve("to_fridge");

    var response = await post(request);
    if (response.statusCode == 200) {
      print("Active grocery items sent to fridge!");
    } else {
      print("Failed send active grocery items to fridge");
    }
  }

}