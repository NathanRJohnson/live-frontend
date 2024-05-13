import 'dart:convert';

import '../model/fridge_item.dart';
import 'package:http/http.dart';

// TODO: read in an API token
class FridgeHandler {

  final Uri url = Uri.http("3.96.14.111", "/fridge/");

  // constructor
  FridgeHandler();

  Future<void> pushToDB(FridgeItem i) async {
    var body = jsonEncode(i);

    var response = await post(url, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Item added!");
    } else {
      print("Failed to add Item: [${response.statusCode}] ${response.body}");
    }
  }

  Future<List<FridgeItem>> getAllItems() async {
    List<FridgeItem> dbItems = [];

    var response = await get(url);
    if (response.statusCode == 200) {
      // TODO: fix api to not return the word null on empty list
      if (response.body != "null" && response.body.isNotEmpty) {
        List<dynamic> jsonItems = json.decode(response.body);
        for (Map<String, dynamic> itemMap in jsonItems) {
          FridgeItem newItem = FridgeItem.fromJSON(itemMap);
          dbItems.add(newItem);
        }
      }
    }
    return dbItems;
  }

  Future<void> deleteItemByID(int itemID) async {
    // appends item id to request url
    var request = url.resolve(itemID.toString());

    var response = await delete(request);
    if (response.statusCode == 200) {
      print("Item deleted!");
    } else {
      print("Failed to delete Item!");
    }
  }

}