

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';

class ProductItemCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductItemCard({super.key, required this.product});

  @override
  ConsumerState<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends ConsumerState<ProductItemCard> {

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
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
}

