import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/handler/product_handler.dart';
import 'package:project_l/wtfridge/model/product.dart';

/* Provide Renderables */
class ProductNotifier extends Notifier<List<Product>> {

  final ProductHandler handler = ProductHandler();

  @override
  List<Product> build() {
    /* TODO - Would be nice to find products
     that aren't already in either the fridge or grocery lists. Would be nice
     to be able to display frequently purchased products initially before searching happens
    */
    return [];
  }

  // TODO: this needs a better name
  Future<void> tryFetchServerUpdate() async {
    await handler.syncDB();
  }

  // TODO - union / exclusion logic should move to the handler when re-implemented
  void getDisplayProducts() async {

    // Set<String> currentFridgeItemNames = ref.read(fridgeCardNotifierProvider.notifier).getAllItemNames();
    // Set<String> currentGroceryItemNames = ref.read(groceryCardNotifierProvider.notifier).getAllItemNames();
    // Set<String> currentItems = currentFridgeItemNames.union(currentGroceryItemNames);

    // var availableProducts = allProducts
    //     .where((product) => !currentItems.contains(product.name));

    // TODO - will change once frequentProducts table is added
    state = await handler.getProductsFromLocalDB();
  }

  void getProductsBySearchTerm(String searchTerm) async {
    state = await handler.getProductsFromLocalDB(searchTerm: searchTerm);
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