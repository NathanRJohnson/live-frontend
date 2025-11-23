import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';

class ProductSelectionView extends ConsumerStatefulWidget {
  const ProductSelectionView({super.key});

  @override
  ConsumerState<ProductSelectionView> createState() => _ProductSelectionViewState();
}

class _ProductSelectionViewState extends ConsumerState<ProductSelectionView> {

  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final products = ref.watch(productNotifierProvider);
    return Column(
      children: <Widget>[
        productSearchOptions(context),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, i) {
              return _productItemCard(context, ref.read(productNotifierProvider).elementAt(i));
            }
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
              width: 325,
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
                        print("Hello?  $searchString");
                        ref.read(productNotifierProvider.notifier).filterProductsBySearchTerm(searchString);
                        setState(() {

                        });
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

  Widget _productItemCard(BuildContext context, Product p) {
    return GestureDetector(
      onTap: () {
        // do I need to add a provider here?
      },
      child: ListTileTheme(
          contentPadding: const EdgeInsets.all(0),
          child: ListTile(
            tileColor: Theme
                .of(context)
                .colorScheme
                .surfaceContainer,
            minVerticalPadding: 0.0,
            titleAlignment: ListTileTitleAlignment.top,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)),
            title: Text(p.name),
          )
      ),
    );
  }
}