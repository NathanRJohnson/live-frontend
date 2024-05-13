import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../components/fridge_speed_dial.dart';
import '../components/fridge_item_card.dart';
import '../provider/fridge_provider.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
          children: <Widget>[ListView(), ListView(
            children: List.generate(fridgeItems.length, (i) {
              FridgeItem currentItem = fridgeItems.elementAt(i);
              return FridgeItemCard(item: currentItem, delete: () {
                ref.read(fridgeNotifierProvider.notifier).removeByID(currentItem.id!);
              });
            }).toList(),
          )],
        ),
      floatingActionButton: FridgeSpeedDial()
    );
  }

}