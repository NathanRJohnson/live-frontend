import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_l/wtfridge/components/update_item_form.dart';

import '../model/fridge_item.dart';

class FridgeItemCard extends StatefulWidget {
  final FridgeItem item;
  final Function() delete;
  final Function() toGroceries;
  const FridgeItemCard({super.key, required this.item, required this.delete, required this.toGroceries});

  @override
  _FridgeItemCardState createState() => _FridgeItemCardState();
}

class _FridgeItemCardState extends State<FridgeItemCard> {
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

  void _handleDeleteDismiss(BuildContext context) {
    setState(() { widget.item.visible = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Removed ${widget.item.name}",
          style: const TextStyle(fontSize: 16.0)
        ),
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.green,
          onPressed: () {
            setState(() {
              widget.item.visible = true;
            });
          },
        ),
        duration: const Duration(seconds: 2),
      ));
      Timer(const Duration(seconds: 2), () {
        if (!widget.item.visible) {
          widget.delete();
        }
      });
  }

  SlidableAction wasteItemAction() {
    return SlidableAction(
      label: 'wasted',
      backgroundColor: Colors.red[800]!,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      onPressed: (context) async {
        widget.delete();
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
        widget.delete();
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
        widget.toGroceries();
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
            wasteItemAction(),
            eatItemAction(),
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            editItemAction(),
            moveToFridgeItemAction()
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

