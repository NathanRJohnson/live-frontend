import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../components/fridge_speed_dial.dart';
import '../components/fridge_item_card.dart';
import '../components/no_connection_message.dart';
import '../provider/fridge_provider.dart';
import '../provider/grocery_provider.dart';
import '../model/fridge_item.dart';

class FridgeView extends ConsumerStatefulWidget {
  const FridgeView({super.key});

  @override
  ConsumerState<FridgeView> createState() => _FridgeViewState();
}

class _FridgeViewState extends ConsumerState<FridgeView> {

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fridgeItems = ref.watch(fridgeNotifierProvider);
    return !ref.read(fridgeNotifierProvider.notifier).isConnected ?
      Container(
        color: const Color(0xFF141414),
        child: Center(
            child: NoConnectionMessage(
              onRetry: () async {
                await ref.read(fridgeNotifierProvider.notifier).syncToDB();
              },
            )),
      ) :
      Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
          children: <Widget>[ListView(
            children: List.generate(fridgeItems.length, (i) {
              FridgeItem currentItem = fridgeItems.elementAt(i);
              return FridgeItemCard(
                key: UniqueKey(),
                item: currentItem,
                delete: () {
                  ref.read(fridgeNotifierProvider.notifier).removeByID(currentItem.id!);
                },
                toGroceries: () {
                  ref.read(groceryNotifierProvider.notifier).addItem(currentItem.name);
                },
              );
            }).toList(),
          )],
        ),
      floatingActionButton: FridgeSpeedDial()
    );
  }

}