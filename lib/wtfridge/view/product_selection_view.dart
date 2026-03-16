import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/components/grocery_add_form.dart';
import 'package:project_l/wtfridge/components/product_add_form.dart';
import 'package:project_l/wtfridge/components/product_item_card.dart';
import 'package:project_l/wtfridge/model/grocery_item.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';

class ProductSelectionView extends ConsumerStatefulWidget {
  const ProductSelectionView({super.key});

  @override
  ConsumerState<ProductSelectionView> createState() => _ProductSelectionViewState();

  static Future<void> displayAsFullScreen(BuildContext context) {
    return showGeneralDialog(context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations
          .of(context)
          .modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(color: Colors.green);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn
              ),
              child: Dialog.fullscreen(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: const ProductSelectionView()
              ),
            )
        );
      },
    );
  }
}

class _ProductSelectionViewState extends ConsumerState<ProductSelectionView> {

  final TextEditingController controller = TextEditingController();
  GlobalKey<AnimatedListState> _listKey = GlobalKey();
  bool showAddNewItemCard = false;
  String targetList = "Grocery";
  String targetStore = GroceryItem.getStores()[0];

  @override
  @override void initState() {
    Future(() => ref.read(productNotifierProvider.notifier).updateAndDisplay());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productNotifierState = ref.watch(productNotifierProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
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
              child: (productNotifierState.isLoading) ?
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ) :
                AnimatedList(
                  key: _listKey,
                  initialItemCount:
                  (showAddNewItemCard) ?
                  productNotifierState.products.length + 1:
                  productNotifierState.products.length,

                  itemBuilder: (context, index, animation) {
                    Product? product;
                    if (showAddNewItemCard) {
                      product = (index!=0) ? productNotifierState.products.elementAt(index-1) : null;
                    } else {
                      product = productNotifierState.products.elementAt(index);
                    }
      
                    if (product == null) {
                      if (index != 0) {
                        return Container(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                        );
                      }
                      if (showAddNewItemCard && !productNotifierState.searchHasExactMatch) {
                        return _addNewProductTile(context);
                      } else {
                        return _updateProductTile(context);
                      }
                    } else {
                      return GestureDetector(
                          onTap: () {
                            if (targetList == "Grocery") {
                              _playAnimation(index, product!);
                              ref.read(productNotifierProvider.notifier).removeItem(product.id);
                              ref.read(groceryCardNotifierProvider.notifier).addItem(
                                  product.toGroceryValues()
                              );
                            }
                          },
                          onLongPress: () async {
                            if (targetList == "Grocery") {
                              await _openGroceryAddForm(context, formDefaults: {
                                "name": product!.name,
                                "section": product.section,
                                "store": targetStore
                              });
                            }
                          },
                          child: ProductItemCard(product: product)
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addNewProductTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProductAddForm.displayForm(context, controller.text);
      },
      child: ListTileTheme(
        tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ListTile(
          title: Text("Create new '${controller.text}' product"),
        ),
      ),
    );
  }

  Widget _updateProductTile(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ListTileTheme(
        tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ListTile(
          title: Text("Update '${controller.text}' product"),
        ),
      ),
    );
  }

  Widget productSearchOptions(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back_outlined)),
              _displaySearchAndFilterBar(context),
            ],
          ),
          _displayAdditionalActions(context),
        ],
      ),
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
              width: 200,
              height: 36,
              child: SearchAnchor(
                  builder: (BuildContext context, SearchController _controller) {
                    return SearchBar(
                      controller: controller,
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
                        _listKey = GlobalKey();
                        showAddNewItemCard = searchString.isNotEmpty;
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

  Widget _displayAdditionalActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsGeometry.directional(start: 16),
            child: DropdownButton(
              hint: const Text("Target List"),
              focusColor: Theme.of(context).colorScheme.surface,
              value: targetList,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  color: Theme.of(context).colorScheme.onSurface
              ),
              items: const [
                DropdownMenuItem(value: "Grocery", child: Text("Grocery")),
                DropdownMenuItem(value: "Fridge", child: Text("Fridge")),
              ],
              onChanged: (value) {
                setState(() {
                  targetList = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsGeometry.directional(start: 16),
            child: DropdownButton(
              focusColor: Theme.of(context).colorScheme.surface,
              value: targetStore,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                color: Theme.of(context).colorScheme.onSurface
              ),
              items: GroceryItem.getStores().map<DropdownMenuItem<String>>((String storeName) {
                return DropdownMenuItem<String>(
                    value: storeName,
                    child: Text(storeName)
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  targetStore = value!;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsGeometry.directional(start: 4, end: 16),
          child: IconButton(
            icon: const Icon(Icons.add_card),
            onPressed: () {
              _openGroceryAddForm(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openGroceryAddForm(BuildContext context, {Map<String, String>? formDefaults}) async {
    return await showDialog<void>(
      context: context,
      builder: (context) =>  Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: GroceryAddForm(formDefaults: formDefaults)
      ),
    );
  }

  void _playAnimation(int index, Product p) {
    _listKey.currentState!.removeItem(index, (context, animation) {
    final norm = ReverseAnimation(animation);

    final fadeToGreen = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(
        CurvedAnimation(parent: norm, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));

    final slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0),
    ).animate(
      CurvedAnimation(parent: norm, curve: const Interval(0.7, 1.0, curve: Curves.easeOut)));

    return SlideTransition(
      position: slideOut,
      child: FadeTransition(
        opacity: fadeToGreen,
        // material is required to paint the background green!
        child: Material(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: const ListTile(
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