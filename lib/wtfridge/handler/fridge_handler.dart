import 'dart:convert';

import '../model/fridge_item.dart';
import 'package:http/http.dart';

// TODO: read in an API token
class FridgeHandler {

  final Uri url = Uri.http("3.96.14.111", "/fridge/");

  // constructor
  FridgeHandler();

  Future<void> pushToDB(Client client, FridgeItem i) async {
    var body = jsonEncode(i);
    var response = await client.post(url, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Item added!");
    } else {
      throw ClientException("Failed to add Item: [${response.statusCode}] ${response.body}");
    }
  }

  // TODO: fix api to not return the word null on empty list
  Future<List<FridgeItem>> getAllItems(Client client) async {
    List<FridgeItem> dbItems = [];

    var response = await client.get(url);

    if (response.statusCode != 200) {
      throw ClientException("Unable to access items from db: [${response.statusCode}]");
    }

    else if (response.body.isNotEmpty && response.body != "null") {
      List<dynamic> jsonItems = json.decode(response.body);
      for (Map<String, dynamic> itemMap in jsonItems) {
        try {
          FridgeItem newItem = FridgeItem.fromJSON(itemMap);
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
      throw ClientException("Failed to delete Item!");
    }
  }

  Future<void> copyToGroceryByID(Client client, int itemID) async {
    var request = url.resolve("to_grocery/$itemID");

    var response = await client.post(request);
    if (response.statusCode != 200) {
      throw ClientException("Failed send fridge item to groceries");
    }
  }

}