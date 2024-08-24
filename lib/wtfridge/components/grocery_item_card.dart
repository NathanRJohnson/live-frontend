
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

  bool isMoving = false;

  GroceryItemCard({required super.key, required this.item, Client? client }) {
    this.client = client ?? IOClient();
  }

  @override
  ConsumerState<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends ConsumerState<GroceryItemCard> {
  bool isVisible = true;


  Color backgroundColor = const Color(0xFFFFFFFF);
  Color borderColor = const Color(0xFFDDDDDD);
  Color onBackgroundPrimaryColor = const Color(0xFF2C2C2C);
  Color onBackgroundSecondaryColor = const Color(0xFF444444);
  Color selectedBackgroundColor = const Color(0xFFEEF7FF);
  Color selectedBorderColor = Colors.green; // const Color(0xFF528DFF);
  Color inactiveActionColor = const Color(0xFFD7D7D7);

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
    return Visibility(
        visible: isVisible,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                ref.read(groceryCardNotifierProvider.notifier)
                    .toggleActive(widget.client, widget.item);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                      color: (widget.item.isActive) ? selectedBorderColor : borderColor,
                      width: 1.0
                  )
              ),
              child: Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      editItemAction(),
                      deleteItemAction()
                    ],
                  ),
                  child: itemTile()
              ),
            ),
          ),
        )
    );
  }

  Widget itemTile() {
    return ListTileTheme(
      contentPadding: const EdgeInsets.all(0),
      child: ListTile(
        tileColor: backgroundColor,
        minVerticalPadding: 0.0,
        titleAlignment: ListTileTitleAlignment.top,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: Padding(
          padding: const EdgeInsets.only(left:16.0, bottom: 3.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (widget.item.isActive) ? Icon(Icons.check_box, color: selectedBorderColor) : const Icon(Icons.check_box_outline_blank),
              ]),
        ),
        title: _displayNameAndQuantity(),
        subtitle: () {
          if (widget.item.notes != "") {
            return _displayNotesFull();
          }
        }(),
      ),
    );
  }

  Widget _displayNameAndQuantity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.item.name,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: onBackgroundPrimaryColor,
              fontWeight: FontWeight.bold
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: (widget.item.quantity <= 1) ? const Text("") :
          Text("x${widget.item.quantity}",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: onBackgroundSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayNotesFull() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:0.0, horizontal: 0.0),
      child: Text(
        widget.item.notes,
        style: TextStyle(
          color: onBackgroundSecondaryColor,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
        ),
      ),
    );
  }


  SlidableAction editItemAction() {
    return SlidableAction(
        label: 'edit',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
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

  SlidableAction deleteItemAction() {
    return SlidableAction(
        label: 'delete',
        onPressed: (context) async {
          await _handleDeleteDismiss(context);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
    );
  }


  Future<void> _handleDeleteDismiss(BuildContext context) async {
    setState(() { isVisible = false; });
    await ref.read(groceryCardNotifierProvider.notifier).remove(widget.client, widget.item);
  }
}