

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/model/product.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';
import 'package:project_l/wtfridge/view/product_selection_view.dart';
import '../components/under_construction_message.dart';

class MealsView extends ConsumerStatefulWidget {
  const MealsView({super.key});

  @override
  ConsumerState<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends ConsumerState<MealsView> {


  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productNotifierProvider);
    return Scaffold(
      body: Container(
        color: const Color(0xFF141414),
        child: const Center(
          child: UnderConstructionMessage(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _dialogBuilder(context, products);
        },
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, List<Product> products) {
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
              child: const Dialog.fullscreen(
                  backgroundColor: Colors.amber,
                  child: ProductSelectionView()
              ),
            )
        );
      },
    );
  }


}