import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/handler/product_handler.dart';
import 'package:project_l/wtfridge/model/product.dart';

class AsyncState {
  final bool isLoading;
  final List<Product> products;

  AsyncState({this.isLoading = false, this.products=const []});
}

class ProductNotifier extends Notifier<AsyncState> {

  final ProductHandler handler = ProductHandler();
   int _searchVersion = 0;

  @override
  AsyncState build() {
    /* TODO - Would be nice to find products
     that aren't already in either the fridge or grocery lists. Would be nice
     to be able to display frequently purchased products initially before searching happens
    */
    return AsyncState(
      isLoading: true,
      products: [],
    );
  }

  // TODO: this needs a better name
  Future<void> tryFetchServerUpdate() async {
    await handler.syncDB();
  }

  // TODO - union / exclusion logic should move to the handler when re-implemented
  void getDisplayProducts() async {
    state = AsyncState(isLoading: true);
    // Set<String> currentFridgeItemNames = ref.read(fridgeCardNotifierProvider.notifier).getAllItemNames();
    // Set<String> currentGroceryItemNames = ref.read(groceryCardNotifierProvider.notifier).getAllItemNames();
    // Set<String> currentItems = currentFridgeItemNames.union(currentGroceryItemNames);

    // var availableProducts = allProducts
    //     .where((product) => !currentItems.contains(product.name));

    // TODO - will change once frequentProducts table is added
    List<Product> products = await handler.getProductsFromLocalDB();
    state = AsyncState(
      isLoading: false,
      products: products
    );
  }

  void getProductsBySearchTerm(String searchTerm) async {
    final int version = ++_searchVersion;
    state = AsyncState(isLoading: true);
    List<Product> products = await handler.getProductsFromLocalDB(searchTerm: searchTerm);

    // debounce to prevent race condition where old requests would
    // update isLoading to false while latest request was in progress
    if (version != _searchVersion) {
      return;
    }

    state = AsyncState(
      isLoading: false,
      products: products
    );
  }

  void removeItem(int removeId) {
    state = AsyncState(
      isLoading: false,
      products: state.products.where((product) => product.id != removeId).toList(),
    );
  }
}


final productNotifierProvider = NotifierProvider<ProductNotifier, AsyncState>(
    () {
      return ProductNotifier();
    }
);