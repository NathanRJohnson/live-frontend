
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/provider/grocery_provider.dart';

import '../model/grocery_item.dart';

class GroceryItemCard extends ConsumerStatefulWidget {
  final GroceryItem item;
  final Function() delete;
  const GroceryItemCard({required super.key, required this.item, required this.delete});

  @override
  ConsumerState<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends ConsumerState<GroceryItemCard> {
  bool isBeingDismissed = false;

  Color getColor() {
    if (isBeingDismissed) {
      return Colors.red;
    } else if (widget.item.isMoving) {
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
      visible: widget.item.visible,
      child: Dismissible(
        key: widget.key!,
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _handleDeleteDismiss(context);
          }
        },
        onUpdate: (details) {
          if (details.progress > 0.01){
            setState(() { isBeingDismissed = true; });
          } else {
            setState(() { isBeingDismissed = false; });
          }
        },
        child: Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  heightFactor: 2,
                  child: Text( (widget.item.isActive) ? done_item_text : widget.item.name,
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
          ),
        ),
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
              isBeingDismissed = false;
            });
          },
        ),
        duration: const Duration(seconds: 2),
      ));
      Timer(const Duration(seconds: 2), () {
        if (!widget.item.visible) {
            widget.delete();
            isBeingDismissed = false;
        }
    });
  }

}