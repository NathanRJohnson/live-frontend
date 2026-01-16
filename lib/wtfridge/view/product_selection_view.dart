import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/components/product_item_card.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';

class ProductSelectionView extends ConsumerStatefulWidget {
  const ProductSelectionView({super.key});

  @override
  ConsumerState<ProductSelectionView> createState() => _ProductSelectionViewState();
}

class _ProductSelectionViewState extends ConsumerState<ProductSelectionView> {

  final SearchController controller = SearchController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  @override void initState() {
    Future(() => ref.read(productNotifierProvider.notifier).tryFetchServerUpdate());
    Future(() => ref.read(productNotifierProvider.notifier).getDisplayProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final products = ref.watch(productNotifierProvider);
    print("WE HAVE PRODUCTS: ${products.length}");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        productSearchOptions(context),
        Container(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Center(
            child: Text(
              "Tap on an item to add it to your grocery list!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Expanded(
          child: AnimatedList(
              key: _listKey,
              initialItemCount: 10,
              itemBuilder: (context, index, animation) {
                final p = ref.read(productNotifierProvider).elementAt(index);
                return GestureDetector(
                  onTap: () {
                    // animation and removal logic
                    ref.read(productNotifierProvider.notifier).removeItem(p.id);
                    ref.read(groceryCardNotifierProvider.notifier).addItem(
                        p.toGroceryValues()
                    );
                    _playAnimation(index, p);
                  },
                  child: ProductItemCard(product: p));
              }
          ),
        ),
      ],
    );
  }

  Widget productSearchOptions(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_outlined)),
        _displaySearchAndFilterBar(context)
      ],
    );
  }

  Widget _displaySearchAndFilterBar(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: SizedBox(
              width: 250,
              height: 36,
              child: SearchAnchor(
                // searchController: controller,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      leading: Icon(Icons.search, color: Theme
                          .of(context)
                          .colorScheme
                          .onSurface),
                      hintText: "Search",
                      shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(4.0),
                                  right: Radius.circular(4.0)))),
                      backgroundColor: WidgetStatePropertyAll(Theme
                          .of(context)
                          .colorScheme
                          .surfaceContainer,
                      ),
                      elevation: const WidgetStatePropertyAll(0.0),
                      onChanged: (searchString) {
                        ref.read(productNotifierProvider.notifier).getProductsBySearchTerm(searchString);
                      },
                    );
                  },
                  suggestionsBuilder: (BuildContext context,
                      SearchController controller) {
                    return [];
                  }),
            )
        ),
      ],
    );
  }

  // Widget _productItemCard(BuildContext context, Product p, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       // do I need to add a provider here?
  //       _removeItem(index, p);
  //       ref.read(productNotifierProvider.notifier).removeItem(p.id);
  //       ref.read(groceryCardNotifierProvider.notifier).addItem(
  //         p.toGroceryValues()
  //       );
  //     },
  //     child: ListTileTheme(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //         child: ListTile(
  //           tileColor: Theme
  //               .of(context)
  //               .colorScheme
  //               .surfaceContainer,
  //           minVerticalPadding: 0.0,
  //           titleAlignment: ListTileTitleAlignment.top,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(0)),
  //           title: Text(p.name),
  //         )
  //     ),
  //   );
  // }

  void _playAnimation(int index, Product p) {
    _listKey.currentState!.removeItem(index, (context, animation) {
    final norm = ReverseAnimation(animation);

    final fadeToGreen = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(
        CurvedAnimation(parent: norm, curve: const Interval(0.0, 0.3, curve: Curves.easeInOut)));

    final slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0),
    ).animate(
      CurvedAnimation(parent: norm, curve: const Interval(0.7, 1.0)));

    return SlideTransition(
      position: slideOut,
      child: FadeTransition(
        opacity: fadeToGreen,
        // material is required to paint the background green!
        child: const Material(
          color: Colors.green,
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Icon(Icons.check, color: Colors.white),
          ),
        ),
      ),
    );

    },
    duration: const Duration(milliseconds: 500),
    );
  }

}