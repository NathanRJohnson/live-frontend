import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../components/grocery_add_button.dart';
import '../components/grocery_item_card.dart';
import '../provider/grocery_card_provider.dart';

class GroceryView extends ConsumerStatefulWidget {
  const GroceryView({super.key});

  @override
  ConsumerState<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends ConsumerState<GroceryView> {

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryCardNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // 141414
      body: Stack(
        children: <Widget> [
          SingleChildScrollView(
            child: Column(
              children: <Widget> [
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  proxyDecorator: _proxyDecorator,
                  onReorderStart: (index) {
                    ref.read(groceryCardNotifierProvider.notifier)
                        .setMovingAtAs(index, true);
                  },
                  onReorderEnd: (index) {
                    ref.read(groceryCardNotifierProvider.notifier)
                        .setMovingAtAs(index, false);
                  },
                  onReorder: (oldIndex, newIndex) {
                    ref.read(groceryCardNotifierProvider.notifier)
                        .setMovingAtAs(oldIndex, false);
                    setState(() {
                      ref.read(groceryCardNotifierProvider.notifier)
                          .reorder(IOClient(), oldIndex, newIndex);
                    });
                  },
                  children: List.generate(groceryItems.length, (i) {
                    GroceryItemCard currentCard = groceryItems.elementAt(i);
                    return currentCard;
                  }),
                ),
                GroceryAddButton(key: UniqueKey()),
              ],
            ),
          ),
          _displayAddToFridgeButton(ref),
        ]),
      floatingActionButton: _displayShareFAB(context, ref),
      );
  }
}

Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
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

Widget _displayAddToFridgeButton(WidgetRef ref) {
  return Visibility(
    visible: ref.watch(groceryCardNotifierProvider.notifier).countActive() > 0,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 64.0),
        child: SizedBox(
          width: 175,
          height: 55,
          child: ElevatedButton(
            onPressed: (){
              ref.read(groceryCardNotifierProvider.notifier).sendActiveToFridge(IOClient(), ref);
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
              "Add to Fridge (${ref.read(groceryCardNotifierProvider.notifier).countActive()})"
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _displayShareFAB(BuildContext context, WidgetRef ref) {
  return FloatingActionButton(
    backgroundColor: const Color(0xFF292929),
    shape: const CircleBorder(),
    onPressed: () async {
      String message_text = ref.read(groceryCardNotifierProvider.notifier)
          .getShareGroceryText();
      await Clipboard.setData(ClipboardData(text: message_text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("grocery list copied to clipboard", style: TextStyle(fontSize: 16.0))),
        );
      }
    },
    child: const Icon(Icons.share,
      color: Colors.green,
    ),
  );
}