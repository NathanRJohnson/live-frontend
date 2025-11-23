
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/model/product.dart';

class ProductNotifier extends Notifier<List<Product>> {

  static const allProducts = [
    Product(id: 1, name: "apples", section: "Fruit"),
    Product(id: 2, name: "salmon", section: "Seafood"),
    Product(id: 3, name: "spinach Pizza", section: "Frozen")
  ];

  @override
  List<Product> build() {
    /* TODO -- pull products from database. Would be nice to find products
     that aren't already in either the fridge or grocery lists. Would be nice
     to be able to display frequently purchased products initially before searching happens
    */


    return allProducts;
  }

  void filterProductsBySearchTerm(String searchTerm) {
    state = allProducts.where((p) => p.name.startsWith(searchTerm)).toList();
    print(state);
  }

}


final productNotifierProvider = NotifierProvider<ProductNotifier, List<Product>>(
    () {
      return ProductNotifier();
    }
);