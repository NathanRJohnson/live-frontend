
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';

import '../components/grocery_update_form.dart';
import '../provider/grocery_card_provider.dart';
import '../model/grocery_item.dart';

class GroceryItemCard extends ConsumerStatefulWidget {
  final GroceryItem item;
  late Client client;

  bool isMoving = false;

  GroceryItemCard({required super.key, required this.item, Client? client }) {
    this.client = client ?? Client();
  }

  @override
  ConsumerState<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends ConsumerState<GroceryItemCard> {
  bool isVisible = true;

  Color getColor() {
    if (widget.isMoving) {
      return Theme.of(context).colorScheme.tertiary;
    } else if (widget.item.isActive) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.outlineVariant;
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
                      color: getColor(),
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
        tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        minVerticalPadding: 0.0,
        titleAlignment: ListTileTitleAlignment.top,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: Padding(
          padding: const EdgeInsets.only(left:16.0, bottom: 3.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (widget.item.isActive) ? Icon(Icons.check_box, color: Theme.of(context).colorScheme.primary) : const Icon(Icons.check_box_outline_blank),
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
              color:  (widget.isMoving) ? Theme.of(context).colorScheme.onErrorContainer : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: (widget.item.quantity <= 1) ? const Text("") :
          Text("x${widget.item.quantity}",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Theme.of(context).colorScheme.onSurface,
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
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
        ),
      ),
    );
  }


  SlidableAction editItemAction() {
    return SlidableAction(
        label: 'edit',
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
        icon: Icons.edit,
        onPressed: (context) {
          GroceryUpdateForm.displayUpdateItemForm(
              context,
              widget.item
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
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
        icon: Icons.delete,
    );
  }


  Future<void> _handleDeleteDismiss(BuildContext context) async {
    setState(() { isVisible = false; });
    await ref.read(groceryCardNotifierProvider.notifier).remove(widget.client, widget.item);
  }
}