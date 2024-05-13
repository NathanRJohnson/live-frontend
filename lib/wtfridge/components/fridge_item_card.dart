import 'package:flutter/material.dart';

import '../model/fridge_item.dart';

class FridgeItemCard extends StatefulWidget {
  final FridgeItem item;
  final Function() delete;
  const FridgeItemCard({required this.item, required this.delete});


  @override
  _FridgeItemCardState createState() => _FridgeItemCardState();
}

class _FridgeItemCardState extends State<FridgeItemCard> {
  Color backgroundColor = const Color(0xFF292929);
  Color borderColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0.0),
      child: Dismissible(
        key: ValueKey(widget.item.id),
        direction: DismissDirection.horizontal,
        background: displayDeleteDismissContainer(),
        secondaryBackground: displayToGroceriesDismissContainer(),
        onDismissed: (direction) {
          borderColor = Colors.green;

          if (direction == DismissDirection.endToStart) {
            // To grocery list
          } else if (direction == DismissDirection.startToEnd) {
            setState(() {
              widget.delete();  // Remove item
            });
          }
        },

        onUpdate: (details) {
          if (details.direction == DismissDirection.endToStart && details.progress > 0.01) {
            setState(() {
              borderColor = Colors.yellow;
            });
          } else if (details.direction == DismissDirection.startToEnd && details.progress > 0.01) {
            setState(() {
              borderColor = Colors.redAccent;
            });
          } else {
            setState(() {
              borderColor = Colors.green;
            });
          }
        },
        child: displayItemDetails()
        ),
    );
  }

  Widget displayDeleteDismissContainer() {
    return Container(
      color: Colors.redAccent,
      margin: const EdgeInsets.fromLTRB(16.0, 0, 0, 0.0),
      padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0.0),
      child: const  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Remove Item",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            Icon(Icons.double_arrow_rounded)
          ]),
    );
  }

  Widget displayToGroceriesDismissContainer() {
    return Container(
      color: Colors.yellow,
      margin: const EdgeInsets.fromLTRB(48.0, 0, 16.0, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Transform.flip(
                flipX: true,
                child: const Icon(Icons.double_arrow_rounded)
            ),
            const Text("To Groceries",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            )
          ]),
    );
  }

  Widget displayItemDetails() {
    return AnimatedContainer(
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
    );
  }


}

