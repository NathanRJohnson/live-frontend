import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
    return
      // !ref.read(fridgeCardNotifierProvider.notifier).isConnected ?
      // Container(
      //   color: const Color(0xFF141414),
      //   child: Center(
      //       child: NoConnectionMessage(
      //         onRetry: () async {
      //           await ref.read(fridgeCardNotifierProvider.notifier).syncToDB(IOClient());
      //         },
      //       )),
      // ) :
      Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), //0xFF141414
      body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _displaySearchAndFilterBar(),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(fridgeCards.length, (i) {
                        FridgeItemCard currentCard = fridgeCards.elementAt(i);
                        return currentCard;
                    }).toList(),
                            ),
                ],
              ),
            )],
        ),
      floatingActionButton: FridgeSpeedDial()
    );
  }

  Widget _displaySearchBar() {
    return SearchBar(
      trailing: <Widget>[
        ElevatedButton.icon(
          onPressed: (){},
          label: SizedBox(),
          icon: Icon(Icons.filter_alt_outlined)
        )
      ]
    );
  }

  Widget _displaySearchAndFilterBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB( 16.0, 16.0, 8.0, 16.0),
          child: SizedBox(
            width: 325,
            height: 36,
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return const SearchBar(
                  leading: Icon(Icons.search),
                  hintText: "Search",
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(4.0), right: Radius.circular(4.0)))),
                  backgroundColor: MaterialStatePropertyAll(Color(0xFFF7F9F7)),
                  elevation: MaterialStatePropertyAll(0.0),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return [];
              }),
            )
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.filter_alt_outlined)
          )
        ],
    );
  }

}