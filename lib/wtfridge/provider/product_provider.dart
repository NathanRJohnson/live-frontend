
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/fridge_card_provider.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';

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
    Set<String> currentFridgeItemNames = ref.read(fridgeCardNotifierProvider.notifier).getAllItemNames();
    Set<String> currentGroceryItemNames = ref.read(groceryCardNotifierProvider.notifier).getAllItemNames();
    Set<String> currentItems = currentFridgeItemNames.union(currentGroceryItemNames);

    var availableProducts = allProducts
        .where((product) => !currentItems.contains(product.name));

    return availableProducts.toList();
  }

  void getAvailableProducts() {
    Set<String> currentFridgeItemNames = ref.read(fridgeCardNotifierProvider.notifier).getAllItemNames();
    Set<String> currentGroceryItemNames = ref.read(groceryCardNotifierProvider.notifier).getAllItemNames();
    Set<String> currentItems = currentFridgeItemNames.union(currentGroceryItemNames);

    var availableProducts = allProducts
        .where((product) => !currentItems.contains(product.name));

    state = availableProducts.toList();
  }

  void filterProductsBySearchTerm(String searchTerm) {
    state = allProducts.where((p) => p.name.startsWith(searchTerm)).toList();
  }

  void removeItem(int removeId) {
    state = state.where((product) => product.id != removeId).toList();
  }
}


final productNotifierProvider = NotifierProvider<ProductNotifier, List<Product>>(
    () {
      return ProductNotifier();
    }
);