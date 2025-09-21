import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:project_l/wtfridge/components/grocery_add_form.dart';

import '../components/grocery_item_card.dart';
import '../provider/grocery_card_provider.dart';

class GroceryView extends ConsumerStatefulWidget {
  const GroceryView({super.key});

  @override
  ConsumerState<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends ConsumerState<GroceryView> {

  @override void initState() {
    Future(() => ref.read(groceryCardNotifierProvider.notifier).syncToDB());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryCardNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface, // 141414
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Text(
                "Grocery List",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget> [
                // Container(color: Colors.purple),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget> [
                      const SizedBox(height: 16),
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
                                .reorder(oldIndex, newIndex);
                          });
                        },
                        children: List.generate(groceryItems.length, (i) {
                          GroceryItemCard currentCard = groceryItems.elementAt(i);
                          return currentCard;
                        }),
                      ),
                    ],
                  ),
                ),
                _displayAddToFridgeButton(context, ref),
              ]),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _displayShareFAB(context, ref),
          const SizedBox(height: 8.0),
          _displayAddFAB(context),
          const SizedBox(height: 4.0),
        ],
      )
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

Widget _displayAddToFridgeButton(BuildContext context, WidgetRef ref) {
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
            onPressed: () async {
              await ref.read(groceryCardNotifierProvider.notifier).sendActiveToFridge(ref);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
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
    heroTag: null,
    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    shape: const CircleBorder(),
    onPressed: () async {
      String messageText = ref.read(groceryCardNotifierProvider.notifier)
          .getShareGroceryText();
      await Clipboard.setData(ClipboardData(text: messageText));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("grocery list copied to clipboard", style: TextStyle(fontSize: 16.0))),
        );
      }
    },
    child: Icon(Icons.share,
      color: Theme.of(context).colorScheme.onTertiaryContainer,
    ),
  );
}

Widget _displayAddFAB(BuildContext context) {
  return FloatingActionButton(
    heroTag: null,
    backgroundColor: Theme
        .of(context)
        .colorScheme
        .primaryContainer,
    shape: const CircleBorder(),
    onPressed: () async {
      openGroceryAddForm(context);
    },
    child: Icon(Icons.add,
      color: Theme
          .of(context)
          .colorScheme
          .onPrimaryContainer,
    ),
  );
}

Future<void> openGroceryAddForm(BuildContext context) async {
  return await showDialog<void>(
    context: context,
    builder: (context) =>  Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: const GroceryAddForm()
    ),
  );
}
