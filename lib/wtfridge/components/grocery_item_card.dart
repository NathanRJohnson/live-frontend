
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../provider/grocery_card_provider.dart';
import '../components/update_item_form.dart';
import '../model/grocery_item.dart';

class GroceryItemCard extends ConsumerStatefulWidget {
  final GroceryItem item;
  late Client client;
  bool isVisible = true;
  bool isMoving = false;

  GroceryItemCard({required super.key, required this.item, Client? client }) {
    this.client = client ?? IOClient();
  }

  @override
  ConsumerState<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends ConsumerState<GroceryItemCard> {

  Color getColor() {
    if (widget.isMoving) {
      return Colors.yellow;
    } else if (widget.item.isActive) {
      return Colors.green;
    } else {
      return Colors.white60;
    }
  }

  @override
  Widget build(BuildContext context) {
    String done_item_text = "--${widget.item.name}--";
    return Visibility(
      visible: widget.isVisible,
      child: GestureDetector(
        onTap: () {
          setState(() {
            ref.read(groceryCardNotifierProvider.notifier)
              .toggleActive(widget.client, widget.item);
          });
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF292929),
            border: Border(
              left: BorderSide(
                color: getColor(),
                width: 4
              )
            ),
            borderRadius: BorderRadius.circular(4.0)
          ),
          child: Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await _handleDeleteDismiss(context);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  onPressed: (context) {
                    UpdateItemForm.displayUpdateItemForm(
                      context,
                      (newName) => setState(() {
                        ref.read(groceryCardNotifierProvider.notifier).updateNameByID(widget.client, widget.item.id!, newName);
                      }),
                     widget.item.name
                    );
                  },
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
              ],
            ),
            child: _displayItemCard(done_item_text)
          ),
        ),
      ),
    );
  }

  Widget _displayItemCard(String doneItemText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            heightFactor: 2,
            child: Text( (widget.item.isActive) ? doneItemText : widget.item.name,
              style: TextStyle(
                fontSize: 16.0,
                color: getColor(),
                decorationThickness: 3,
                decorationColor: getColor(),
                decoration: (widget.item.isActive) ? TextDecoration.lineThrough : TextDecoration.none
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleDeleteDismiss(BuildContext context) async {
    setState(() { widget.isVisible = false; });
    await ref.read(groceryCardNotifierProvider.notifier).remove(widget.client, widget.item);
    // if (!widget.isVisible) {
    // }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       "Removed ${widget.item.name}",
    //       style: const TextStyle(fontSize: 16.0)
    //     ),
    //     action: SnackBarAction(
    //       label: "Undo",
    //       textColor: Colors.green,
    //       onPressed: () {
    //         setState(() {
    //           widget.isVisible = true;
    //         });
    //       },
    //     ),
    //     duration: const Duration(seconds: 2),
    //   ));
    //   Timer(const Duration(seconds: 2), () {

    // });
  }
}