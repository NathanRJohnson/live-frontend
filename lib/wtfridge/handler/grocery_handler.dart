

import 'dart:convert';

import 'package:http/http.dart';

import '../model/grocery_item.dart';

class GroceryHandler {

  final Uri url = Uri.http("3.96.14.111", "/grocery/");

  GroceryHandler();

  Future<void> pushToDB(Client client, GroceryItem i) async {
    var body = jsonEncode(i);

    var response = await client.post(url, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ClientException("Failed to add Item: [${response.statusCode}] ${response.body}");
    }
  }

  // TODO: fix api to not return the word null on empty list
  Future<List<GroceryItem>> getAllItems(Client client) async {
    List<GroceryItem> dbItems = [];

    var response = await client.get(url);

    if (response.statusCode != 200) {
      throw ClientException("Unable to access items from db: [${response.statusCode}]");
    }

    else if (response.body.isNotEmpty && response.body != "null") {
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

    return dbItems;
  }

  Future<void> deleteItemByID(Client client, int itemID) async {
    var request = url.resolve(itemID.toString());

    var response = await client.delete(request);
    if (response.statusCode != 200) {
      throw ClientException("Failed to delete grocery item");
    }
  }

  Future<void> toggleActiveByID(Client client, int itemID) async {
    var request = url.resolve(itemID.toString());

    var response = await client.patch(request);
    if (response.statusCode != 200) {
      throw ClientException("Failed to toggle grocery item");
    }
  }

  Future<void> sendActiveToFridge(Client client) async {
    var request = url.resolve("to_fridge");

    var response = await client.post(request);
    if (response.statusCode != 200) {
      throw ClientException("Failed send active grocery items to fridge");
    }
  }

  Future<void> updateIndicies(Client client, int oldIndex, int newIndex) async {
    String body = jsonEncode({
      'old_index': oldIndex+1,
      'new_index': newIndex+1,
    });
    var response = await client.patch(url, body: body);
    if (response.statusCode != 200) {
      throw ClientException("unable to rearrange items: ${response.statusCode}");
    }

  }

}