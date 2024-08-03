import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';


import '../components/fridge_speed_dial.dart';
import '../components/fridge_item_card.dart';
import '../components/no_connection_message.dart';
import '../provider/fridge_card_provider.dart';
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
    final fridgeCards = ref.watch(fridgeCardNotifierProvider);
    return !ref.read(fridgeCardNotifierProvider.notifier).isConnected ?
      Container(
        color: const Color(0xFF141414),
        child: Center(
            child: NoConnectionMessage(
              onRetry: () async {
                await ref.read(fridgeCardNotifierProvider.notifier).syncToDB(IOClient());
              },
            )),
      ) :
      Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
          children: <Widget>[
            ListView(
              children: List.generate(fridgeCards.length, (i) {
                  FridgeItemCard currentCard = fridgeCards.elementAt(i);
                  return currentCard;
              }).toList(),
          )],
        ),
      floatingActionButton: FridgeSpeedDial()
    );
  }

}