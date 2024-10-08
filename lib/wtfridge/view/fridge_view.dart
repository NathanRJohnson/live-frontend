import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../components/fridge_speed_dial.dart';
import '../components/fridge_item_card.dart';
import '../components/no_connection_message.dart';
import '../provider/fridge_card_provider.dart';

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
      !ref.read(fridgeCardNotifierProvider.notifier).isConnected ?
      Container(
        color: Theme.of(context).colorScheme.surface, // const Color(0xFFFFFFFF),
        child: Center(
            child: NoConnectionMessage(
              onRetry: () async {
                await ref.read(fridgeCardNotifierProvider.notifier).syncToDB(IOClient());
              },
            )),
      ) :
      Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // const Color(0xFFFFFFFF), //0xFF141414
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
                  const SizedBox(height: 50.0)
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
          label: const SizedBox(),
          icon: const Icon(Icons.filter_alt_outlined)
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
                return SearchBar(
                  leading: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                  hintText: "Search",
                  shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(4.0), right: Radius.circular(4.0)))),
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surfaceContainer),
                  elevation: const WidgetStatePropertyAll(0.0),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return [];
              }),
            )
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          )
        ],
    );
  }

}