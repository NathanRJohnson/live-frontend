import 'dart:convert';

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
    final hashResponse = await http.get(Uri.parse('http://localhost:8000/database_hash'));

    final prefs = await SharedPreferences.getInstance();
    final currentHash = prefs.getString("productHash");

    // if hash is unavailable or is the same as stored, exit without changes
    if (hashResponse.statusCode != 200 || jsonDecode(hashResponse.body) == currentHash) {
      print("Product table will not be updated.");
      return;
    }

    // if different, fetchProductsFromServer
    List<Product> products = await fetchProductsFromServer();

    // reload products table
    database.managers.products.delete();
    database.batch((batch) {
      // TODO - loading a lot into memory here. Might need to change how
      // this is done once db is sufficiently large
      batch.insertAll(database.products, [
        for (Product p in products)
          DB.ProductsCompanion.insert(
            id: p.id,
            name: p.name,
            section: p.section,
            avgExpiryDays: p.avgExpiryDays,
            barcodes: Uint8List.fromList(utf8.encode(p.barcodes.join(','))),
          )
      ]);
    });

    // store new hash
    prefs.setString("productHash", hashResponse.body);
  }

  Future<List<Product>> fetchProductsFromServer() async {
    final response = await http.get(Uri.parse('http://localhost:8000/database_full'));
    if (response.statusCode == 200) {
      return [
        for (Map<String, dynamic> p in json.decode(response.body))
          Product.fromJson(p)
      ];
    } else {
      throw Exception("Failed to fetch products from server");
    }
  }

  Future<List<Product>> getProductsFromLocalDB({String searchTerm = "", int numRows = 10}) async {
    List<DB.Product> dbProducts = await database.managers.products.filter((p) => p.name.startsWith(searchTerm)).get(limit: numRows);
    return [
      for (DB.Product product in dbProducts)
        Product(
          id: product.id,
          name: product.name,
          section: product.section,
          avgExpiryDays: product.avgExpiryDays
        )
    ];
  }
}