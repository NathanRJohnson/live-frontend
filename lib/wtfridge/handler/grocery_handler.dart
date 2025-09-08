import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:project_l/wtfridge/handler/handler.dart';

import '../model/grocery_item.dart';

class GroceryHandler {

  final Uri url = Uri.http("3.96.14.111", "/grocery/");
  Client client = Client();
  late Handler handler;

  GroceryHandler({Client? client}) {
    if (client != null) {
      this.client = client;
    }
    handler = Handler(client: this.client);
  }

  Future<void> pushToDB(Client client, GroceryItem i) async {
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

  Future<List<GroceryItem>> getAllItems(Client client) async {
    List<GroceryItem> dbItems = [];

    return dbItems;

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response = Response("", 404);
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.get, url, {
        #headers: {"Authorization": "Bearer $sessionToken"}
      });
    } else {
      // throw ClientException("No session token available.");
      try {
        response = await client.get(url);
      } on Exception catch (e) {
        print(e.toString());
      }
    }

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
      throw ClientException("Failed to delete grocery item");
    }
  }

    Future<void> updateItem(Client client, Map<String, dynamic> newValues) async {
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

  Future<void> toggleActiveByID(Client client, int itemID) async {
    var request = url.resolve(itemID.toString());

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.patch, request, {
        #headers: {"Authorization": "Bearer $sessionToken"},
      });
    } else {
      response = await client.patch(request);
    }

    if (response.statusCode != 200) {
      throw ClientException("Failed to toggle grocery item");
    }
  }

  Future<void> sendActiveToFridge(Client client) async {
    var request = url.resolve("to_fridge");

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.post, request, {
        #headers: {"Authorization": "Bearer $sessionToken"},
      });
    } else {
      response = await client.post(request);
    }

    if (response.statusCode != 200) {
      throw ClientException("Failed send active grocery items to fridge");
    }
  }

  Future<void> updateIndicies(Client client, int oldIndex, int newIndex) async {
    String body = jsonEncode({
      'old_index': oldIndex+1,
      'new_index': newIndex+1,
    });

    final sessionToken = await handler.storage.read(key: Handler.SESSION_KEY);
    Response response;
    if (sessionToken != null && sessionToken.isNotEmpty) {
      response = await handler.makeRequest(client.patch, url, {
        #headers: {"Authorization": "Bearer $sessionToken"},
        #body: body
      });
    } else {
      response = await client.patch(url);
    }

    if (response.statusCode != 200) {
      throw ClientException("unable to rearrange items: ${response.statusCode}");
    }

  }

}