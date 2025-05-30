import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:project_l/wtfridge/handler/handler.dart';

import '../model/fridge_item.dart';


// TODO: read in an API token
class FridgeHandler {

  final Uri url = Uri.http("3.96.14.111", "/fridge/");
  Client client = Client();
  late Handler handler;

  // constructor
  FridgeHandler({Client? client}) {
    if (client != null) {
      this.client = client;
    }
    handler = Handler(client: this.client);
  }

  Future<void> pushToDB(Client client, FridgeItem i) async {
    var body = jsonEncode(i);

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.post, url, {
        #headers: {"Authorization": "Bearer $sessionToken"},
        #body: body,
      });
    } else {
      response = await client.post(url, body: body);
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ClientException("Failed to add Item: [${response.statusCode}] ${response.body}");
    }
  }

  // TODO: fix api to not return the word null on empty list
  Future<List<FridgeItem>> getAllItems(Client client) async {
    List<FridgeItem> dbItems = [];

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.get, url, {
        #headers: {"Authorization": "Bearer $sessionToken"}
      });
    } else {
      response = await client.get(url);
    }

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
          continue;
        }
      }
    }

    return dbItems;
  }

  Future<void> deleteItemByID(Client client, int itemID) async {
    var request = url.resolve(itemID.toString());

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.delete, request, {
        #headers: {"Authorization": "Bearer $sessionToken"}
      });
    } else {
      response = await client.delete(request);
    }
    if (response.statusCode != 200) {
      print("[${response.statusCode}]: ${response.body}");
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

  updateItem(Client client, Map<String, dynamic> newValues) async {
    if (newValues.containsKey("new_date")) {
      newValues["new_date"] = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format((newValues["new_date"] as DateTime).toUtc());
    }

    String body = json.encode(newValues);
    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.put, url, {
        #headers: {"Authorization": "Bearer $sessionToken"},
        #body: body
      });
    } else {
      response = await client.put(url, body: body);
    }

    if (response.statusCode != 200) {
      throw ClientException("Failed to update item: ${response.body}");
    }
  }

}