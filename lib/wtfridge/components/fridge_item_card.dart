import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';


import '../components/update_item_form.dart';
import '../model/fridge_item.dart';
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
  Color backgroundColor = const Color(0xFFFFFFFF);
  Color borderColor = const Color(0xFFDDDDDD);
  Color onBackgroundPrimaryColor = const Color(0xFF2C2C2C);
  Color onBackgroundSecondaryColor = const Color(0xFF444444);
  Color selectedBackgroundColor = const Color(0xFFEEF7FF);
  Color selectedBorderColor = const Color(0xFF528DFF);
  Color inactiveActionColor = const Color(0xFFD7D7D7);


  bool isExpanded = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.item.visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              isSelected = !isSelected; //temporary until system is properly implemented
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: (isSelected) ? selectedBorderColor : borderColor,
                width: 1.0
              )
            ),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  editItemAction(),
                  moveToGroceryItemAction(),
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
      child: ExpansionTile(
        backgroundColor: (isSelected) ? selectedBackgroundColor : backgroundColor,
        collapsedBackgroundColor: (isSelected) ? selectedBackgroundColor : backgroundColor,
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: _displayNameAndQuantity(),
        trailing:  Transform.translate(
            offset: const Offset(0, -7),
            child: (isSelected) ? _displaySelectedStatus() : _displayTimeInFridge()),
        subtitle: (isExpanded) ? _displayDateAdded() : _displayNotesHint(),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        onExpansionChanged: (expandState) {
          setState(() {
            isExpanded = expandState;
          });
        },
        children: [
          _displayNotesFull(),
          _displayActionButtons(),
        ],
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

  SlidableAction moveToGroceryItemAction() {
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

  Widget _displayNameAndQuantity() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(widget.item.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: onBackgroundPrimaryColor,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("x2",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: onBackgroundSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayTimeInFridge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(widget.item.timeInFridge,
            style: TextStyle(
              color: onBackgroundSecondaryColor,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(Icons.access_time, size: Theme.of(context).textTheme.bodySmall!.fontSize),
        )
      ],
    );
  }

  Widget _displaySelectedStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text("Selected",
            style: TextStyle(
              color: selectedBorderColor,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.check_circle_outline,
            color: selectedBorderColor,
            size: Theme.of(context).textTheme.bodySmall!.fontSize
          ),
        )
      ],
    );
  }

  Widget _displayNotesHint() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
      child: Text(
        "Lorem ipsum dolor sit amet and one for the road",
        textAlign: TextAlign.justify,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: onBackgroundSecondaryColor,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
        ),
      ),
    );
  }

  Widget _displayDateAdded() {
    String s = "";
    if (widget.item.dateAdded != null) {
      DateTime d = widget.item.dateAdded!;
      s = "${d.day}/${d.month}/${d.year}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Text(
        "Added: ${s}",
        style: TextStyle(
          color: onBackgroundSecondaryColor,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
        ),
      ),
    );
  }

  Widget _displayNotesFull() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes:",
            style: TextStyle(
              color: onBackgroundPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
            ),
          ),
          Text(
            "Lorem ipsum dolor sit amet and one for the road",
            style: TextStyle(
              color: onBackgroundSecondaryColor,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
            ),
          )
        ],
      ),
    );
  }

  Widget _displayActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          _buttonFormatting(
            ElevatedButton.icon(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: (isSelected) ? inactiveActionColor : Colors.redAccent,
                foregroundColor: (isSelected) ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
              ),
              label: const Text("Wasted"),
              icon: Icon(
                Icons.delete_forever_outlined,
                color: (isSelected) ? Colors.black : Colors.white,
                size: 20.0,
              ),
            ),
          ),
          _buttonFormatting(
            ElevatedButton.icon(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: (isSelected) ? inactiveActionColor : const Color(0xFFE8EEFF),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
              ),
              label: const Text("Eaten"),
              icon: const Icon(Icons.restaurant_menu, size: 20.0,),
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonFormatting(Widget w) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: w
        ),
      ),
    );
  }

}


