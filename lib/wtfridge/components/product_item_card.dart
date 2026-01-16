

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';

class ProductItemCard extends ConsumerStatefulWidget {
  final Product product;

  ProductItemCard({required this.product});

  @override
  ConsumerState<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends ConsumerState<ProductItemCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: (_isSelected) ? const ListTile(
          tileColor: Colors.green,
          titleAlignment: ListTileTitleAlignment.center,
          title: Icon(Icons.check),
        ) :
        ListTile(
          tileColor: Theme
              .of(context)
              .colorScheme
              .surfaceContainer,
          minVerticalPadding: 0.0,
          titleAlignment: ListTileTitleAlignment.top,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0)),
          title: Text(widget.product.name),
        )
    );
  }

  // FadeTransition? playAnimation(Animation animation) {
  //   if (widget.animation == null) {
  //     throw Exception("Cannot play animation when ProductItem does not have an associated animation");
  //   }
  //   return FadeTransition(
  //     opacity:
  //         widget.animation!.drive(
  //       Tween(
  //         begin: 0.0,
  //         end: 1.0,
  //       ).chain(CurveTween(curve: Curves.easeOut)),
  //     ),
  //     child: const ListTile(
  //       tileColor: Colors.green,
  //       titleAlignment: ListTileTitleAlignment.center,
  //       title: Icon(Icons.check),
  //     ),
  //   );
  // }

  // void _wipeItem(int index, Product p) {
  //   print(p);
  //   _listKey.currentState!.removeItem(index, (context, animation) {
  //     return FadeTransition(
  //       opacity: animation.drive(
  //         Tween(
  //           begin: 0.0,
  //           end: 1.0,
  //         ).chain(CurveTween(curve: Curves.easeOut)),
  //       ),
  //       child: _productItemCard(context, p, index),
  //     );
  //   },
  //     duration: const Duration(milliseconds: 300),
  //   );
  // }

}

