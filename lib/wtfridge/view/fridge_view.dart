import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../components/fridge_speed_dial.dart';
import '../components/fridge_item_card.dart';
import '../provider/fridge_card_provider.dart';
import '../handler/handler.dart';

class FridgeView extends ConsumerStatefulWidget {
  const FridgeView({super.key});

  @override
  ConsumerState<FridgeView> createState() => _FridgeViewState();
}

class _FridgeViewState extends ConsumerState<FridgeView> {

  @override void initState() {
    Future(() => ref.read(fridgeCardNotifierProvider.notifier).syncToDB());
    super.initState();
  }

  Handler userHandler = Handler(client: Client());

  @override
  Widget build(BuildContext context) {
    final fridgeCards = ref.watch(fridgeCardNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // const Color(0xFFFFFFFF), //0xFF141414
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _displaySearchAndFilterBar(),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: fridgeCards.items.length,
                  itemBuilder: (context, i) {
                    FridgeItemCard currentCard = fridgeCards.items.elementAt(i);
                    return currentCard;
                  }
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
            width: 250,
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