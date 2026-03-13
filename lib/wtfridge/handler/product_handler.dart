import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/storage/database.dart' as DB;
import 'package:shared_preferences/shared_preferences.dart';


class ProductHandler {

  final database = DB.AppDatabase.instance;
  final prefs = SharedPreferences.getInstance();

  ProductHandler();

  Future<void> syncDB() async {
    // request hash from server
    http.Response hashResponse;
    try {
      hashResponse = await http.get(Uri.parse('http://10.0.0.123:8000/database_hash'));
    } on http.ClientException catch (e) {
      print("Unable to fetch hash. Details: $e");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final currentHash = prefs.getString("productHash");

    // if hash is unavailable or is the same as stored, exit without changes
    if (hashResponse.statusCode != 200 || hashResponse.body == currentHash) {
      print("Product table will not be updated.");
      return;
    }

    List<Product> products = [];
    try {
    // if different, fetchProductsFromServer
       products = await fetchProductsFromServer();
    } on HttpException catch (e) {
      print("unable to fetch products from server: $e");
      return;
    }

    // delete all products not created by the user in order to ingest updates
    database.managers.products.filter((p) => p.userCreated.equals(false)).delete();

    database.batch((batch) {
      // TODO - loading a lot into memory here. Might need to change how
      // this is done once db is sufficiently large
      batch.insertAll(
        database.products,
        mode: InsertMode.insertOrIgnore,
        [for (Product p in products)
          DB.ProductsCompanion.insert(
            id: p.id,
            name: p.name,
            section: p.section,
            avgExpiryDays: p.avgExpiryDays,
            barcodes: Uint8List.fromList(utf8.encode(p.barcodes.join(','))),
            userCreated: false
          )]);
    });

    // store new hash
    prefs.setString("productHash", hashResponse.body);
  }

  Future<List<Product>> fetchProductsFromServer() async {
    final response = await http.get(Uri.parse('http://10.0.0.123:8000/database_full'));
    if (response.statusCode == 200) {
      return [
        for (Map<String, dynamic> p in json.decode(response.body))
          Product.fromJson(p)
      ];
    } else {
      throw const HttpException("Failed to fetch products from server");
    }
  }

  Future<List<Product>> getProductsFromLocalDB({String searchTerm = "", int numRows = 50}) async {

    // TODO: would be real nice if I could have this available as a view or stream
    // or anything that meant I wouldn't have to re-query this everytime the search term changed.
    final currentInventoryIds = database.selectOnly(database.fridgeItems)
      ..addColumns([database.fridgeItems.itemId])
      ..union(
        database.selectOnly(database.groceryItems)..addColumns([database.groceryItems.itemId])
      );

    final escapedTerm = searchTerm.replaceAll('%', r'\%'.replaceAll('_', r'\_'));

    final availableProducts = await (database.select(database.products)
      ..where((p) => p.id.isNotInQuery(currentInventoryIds))
      ..where((p) => p.name.like('${escapedTerm.toLowerCase()}%'))
      ..limit(numRows)).get();

    return [
      for (DB.Product product in availableProducts)
        Product(
          id: product.id,
          name: product.name,
          section: product.section,
          avgExpiryDays: product.avgExpiryDays
        )
    ];
  }

  Future<void> createProduct(Product p) async {
    await database.managers.products.create((i) => i(
        id: p.id,
        name: p.name,
        avgExpiryDays: p.avgExpiryDays,
        barcodes: Uint8List.fromList([for (String barcode in p.barcodes) int.parse(barcode)]),
        section: p.section,
        userCreated: true
    ));
  }
}