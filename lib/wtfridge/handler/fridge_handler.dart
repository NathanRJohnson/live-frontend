import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:project_l/wtfridge/handler/handler.dart';
import 'package:project_l/wtfridge/storage/secure_storage.dart';
import 'package:project_l/wtfridge/storage/storage.dart';

import '../model/fridge_item.dart';
import 'package:http/http.dart';

import '../storage/web_storage.dart';

// TODO: read in an API token
class FridgeHandler {

  final Uri url = Uri.http("3.96.14.111", "/fridge/");
  Client client = Client();
  Storage storage = kIsWeb ? WebStorage() : SecureStorage();
  late Handler userHandler;

  // constructor
  FridgeHandler({Client? client, Storage? storage}) {
    if (client != null) {
      this.client = client;
    }
    if (storage != null) {
      this.storage = storage;
    }
  }

  Future<void> pushToDB(Client client, FridgeItem i) async {
    var body = jsonEncode(i);
    var response = await userHandler.makeRequest(client.post, url, {
      #headers: {"Authorization": "Bearer "},
      #body: body,
    });

    await client.post(url, headers: {"Authorization": "Bearer "}, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
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

  updateItem(Client client, Map<String, dynamic> newValues) async {
    if (newValues.containsKey("new_date")) {
      newValues["new_date"] = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format((newValues["new_date"] as DateTime).toUtc());
    }

    String body = json.encode(newValues);
    var response = await client.put(url, body: body);
    if (response.statusCode != 200) {
      throw ClientException("Failed to update item: ${response.body}");
    }
  }

}