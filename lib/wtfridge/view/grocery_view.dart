import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/grocery_add_button.dart';
import '../components/grocery_item_card.dart';
import '../model/fridge_item.dart';
import '../model/grocery_item.dart';
import '../provider/grocery_provider.dart';

class GroceryView extends ConsumerStatefulWidget {
  const GroceryView({super.key});

  @override
  ConsumerState<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends ConsumerState<GroceryView> {
    List<FridgeItem> t = [FridgeItem(name: "Jon Doe", timeInFridge: "5 days")];


  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
        children: <Widget> [ListView(),
          ListView(
            children: List.generate(groceryItems.length + 1, (i) {
              if (i < groceryItems.length){
                GroceryItem currentItem = groceryItems.elementAt(i);
                return GestureDetector(
                  onTap: () {
                    setState(() {});
                    ref.read(groceryNotifierProvider.notifier)
                      .toggleActiveAt(i);
                  },

                  child: GroceryItemCard(item: currentItem));
              } else {
                return GroceryAddButton();
              }
            }),
          ),
          Visibility(
            visible: ref.read(groceryNotifierProvider.notifier).countActive() > 0,
            child: Positioned(
              left: 100.0,
              right: 100.0,
              bottom: 100.0,
              child: SizedBox(
                width: 100,
                height: 55,
                child: ElevatedButton(
                  onPressed: (){
                    ref.read(groceryNotifierProvider.notifier).sendActiveToFridge(ref);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )
                  )
                  ),
                  child: Text(
                      "Add to Fridge (${ref.read(groceryNotifierProvider.notifier).countActive()})"
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: const Color(0xFF292929),
        shape: const CircleBorder(),
        child: const Icon(Icons.share,
          color: Colors.green,
        ),
        ),
      );
  }
}