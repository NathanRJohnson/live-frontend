import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';


import '../components/update_item_form.dart';
import '../model/fridge_item.dart';
import '../provider/fridge_card_provider.dart';
import '../provider/grocery_card_provider.dart';

class FridgeItemCard extends ConsumerStatefulWidget {
  final FridgeItem item;
  late Client client;

  FridgeItemCard({super.key, required this.item, Client? client }) {
    this.client = client ?? IOClient();
  }

  @override
  _FridgeItemCardState createState() => _FridgeItemCardState();
}

class _FridgeItemCardState extends ConsumerState<FridgeItemCard> {
  Color backgroundColor = const Color(0xFF292929);
  Color borderColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.item.visible,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0.0),
        child: displayItemDetails(),
      ),
    );
  }

  SlidableAction wasteItemAction() {
    return SlidableAction(
      label: 'wasted',
      backgroundColor: Colors.red[800]!,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      onPressed: (context) async {
        ref.read(fridgeCardNotifierProvider.notifier)
            .remove(widget.client, widget.item);
      },
    );
  }

  SlidableAction eatItemAction() {
    return SlidableAction(
      label: 'eaten',
      backgroundColor: Colors.green[800]!,
      foregroundColor: Colors.white,
      icon: Icons.done,
      onPressed: (context) async {
        ref.read(fridgeCardNotifierProvider.notifier)
            .remove(widget.client, widget.item);
      },
    );
  }

  SlidableAction editItemAction() {
    return SlidableAction(
      label: 'edit',
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      onPressed: (context) {
        UpdateItemForm.displayUpdateItemForm(
          context,
          (newName) => () {},
          widget.item.name
        );
      }
    );
  }

  SlidableAction moveToFridgeItemAction() {
    return SlidableAction(
      label: 'to list',
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
      icon: Icons.shopping_basket_outlined,
      onPressed: (context) {
        ref.read(groceryCardNotifierProvider.notifier)
            .addItem(widget.client, widget.item.name);
      },
    );
  }

  Widget displayItemDetails() {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(
            color: borderColor,
            width: 2.0,
          )
      ),
      margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0.0),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            editItemAction(),
            moveToFridgeItemAction(),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 16.0),
                child: Text(widget.item.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 16.0),
              child: Text(widget.item.timeInFridge,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

