
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/provider/grocery_provider.dart';

import '../model/grocery_item.dart';

class GroceryItemCard extends ConsumerStatefulWidget {
  final GroceryItem item;
  const GroceryItemCard({required this.item});

  @override
  ConsumerState<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends ConsumerState<GroceryItemCard> {
  bool isBeingDeleted = false;

  Color getColor() {
    if (widget.item.isBeingDeleted) {
      return Colors.red;
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
      visible: !isBeingDeleted,
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            widget.item.isBeingDeleted = true;
          });
        },

        onLongPressMoveUpdate: (details) {
          Offset position = details.localPosition;

          // Determine if pointer left bounds
          if (position.dx < 0 || position.dy < 0 ||
              position.dx > context.size!.width ||
              position.dy > context.size!.height) {
            // Pointer left bounds, handle it here
            // For example, cancel the long press
            setState(() {
              widget.item.isBeingDeleted = false;
            });
          }
        },

      onLongPressUp: () {
        if (widget.item.isBeingDeleted) {
          setState(() {
            isBeingDeleted = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                "Removed ${widget.item.name}",
                style: const TextStyle(
                  fontSize: 16.0
                ),
              ),
            action: SnackBarAction(
              label: "Undo",
              textColor: Colors.green,
              onPressed: () {
               setState(() {
                 widget.item.isBeingDeleted = isBeingDeleted = false;
               });
              },
            ),
            duration: const Duration(seconds: 2),
            ));
          Timer(const Duration(seconds: 2), () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (isBeingDeleted) {
              ref.read(groceryNotifierProvider.notifier)
                  .removeByID(widget.item.id!);
              isBeingDeleted = false;
            }
          });
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
}