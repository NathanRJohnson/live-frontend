import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
        children: <Widget> [
          Column(
            children: <Widget> [
              ReorderableListView(
                shrinkWrap: true,
                proxyDecorator: proxyDecorator,
                onReorderStart: (index) {
                  ref.read(groceryNotifierProvider.notifier)
                      .setMovingAtAs(index, true);
                },
                onReorderEnd: (index) {
                  ref.read(groceryNotifierProvider.notifier)
                      .setMovingAtAs(index, false);
                },
                onReorder: (oldIndex, newIndex) {
                  ref.read(groceryNotifierProvider.notifier)
                      .setMovingAtAs(oldIndex, false);
                  setState(() {
                    ref.read(groceryNotifierProvider.notifier)
                        .reorder(oldIndex, newIndex);
                  });
                },
                children: List.generate(groceryItems.length, (i) {
                  GroceryItem currentItem = groceryItems.elementAt(i);
                  return GestureDetector(
                    key: UniqueKey(),
                    onTap: () {
                      setState(() {});
                      ref.read(groceryNotifierProvider.notifier)
                        .toggleActiveAt(i);
                    },
                    child: GroceryItemCard(
                      key: UniqueKey(),
                      item: currentItem,
                      delete: () {
                        ref.read(groceryNotifierProvider.notifier)
                            .removeByID(currentItem.id!);
                      },
                    ));
                  }
                ),
              ),
              GroceryAddButton(key: UniqueKey()),
            ],
          ),
          _displayAddToFridgeButton(ref),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String message_text = ref.read(groceryNotifierProvider.notifier)
              .getShareGroceryText();
          await Clipboard.setData(ClipboardData(text: message_text));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("grocery list copied to clipboard",  style: TextStyle(fontSize: 16.0))),
            );
          }
        },
        backgroundColor: const Color(0xFF292929),
        shape: const CircleBorder(),
        child: const Icon(Icons.share,
          color: Colors.green,
        ),
        ),
      );
  }
}

Widget _displayAddToFridgeButton(WidgetRef ref) {
  return Visibility(
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
  );
}