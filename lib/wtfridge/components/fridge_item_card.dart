import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../provider/fridge_card_provider.dart';
import '../components/fridge_update_form.dart';
import '../model/fridge_item.dart';
import '../provider/grocery_card_provider.dart';

class FridgeItemCard extends ConsumerStatefulWidget {
  final FridgeItem item;
  late Client client;

  FridgeItemCard({super.key, required this.item, Client? client }) {
    this.client = client ?? Client();
  }

  @override
  FridgeItemCardState createState() => FridgeItemCardState();
}

class FridgeItemCardState extends ConsumerState<FridgeItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  bool isSelected = false;
  bool isVisible = true;
  final ExpansionTileController controller = ExpansionTileController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      end: const Color(0xFF444444),
      begin: Colors.orangeAccent,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    _animationController.forward(from: 0.0); // Restart animation from the beginning
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
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
                color: (isSelected) ? Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).colorScheme.outlineVariant,
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
        controller: controller,
        backgroundColor: (isSelected) ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.surfaceContainerLow,
        collapsedBackgroundColor: (isSelected) ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.surfaceContainerLow,
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: _displayNameAndQuantity(),
        trailing:  Builder(
          builder: (context) {
            return Transform.translate(
                offset: (widget.item.notes == "") ? const Offset(0, -2) : const Offset(0, -10),
                child: (isSelected) ? _displaySelectedStatus() : _displayTimeInFridge());
          }
        ),
        subtitle: _displaySubtitle(),
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: ref.read(fridgeCardNotifierProvider.notifier).isInitiallyExpanded(this),
        onExpansionChanged: (expandState) {
          if (expandState) {
            ref.read(fridgeCardNotifierProvider.notifier)
                .setCurrentlyExpandedTile(this);
          } else {
            ref.read(fridgeCardNotifierProvider.notifier)
                .setCurrentlyExpandedTile(null);
          }
          setState(() {});
        },
        children: [
          _displayNotesFull(),
          _displayActionButtons(),
        ],
      ),
    );
  }

  Widget? _displaySubtitle() {
    Widget a = Builder(builder: (context) {
        if (ExpansionTileController.of(context).isExpanded) {
          return  _displayDateAdded();
        } else if (widget.item.notes != "") {
          return _displayNotesHint();
        }
        return const Text("do not display");
    });
    return (a is Text) ? null : a;
  }

  SlidableAction editItemAction() {
    return SlidableAction(
      label: 'edit',
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
      icon: Icons.edit,
      onPressed: (context) {
        FridgeUpdateForm.displayUpdateItemForm(
          context,
          widget.item
        );
      }
    );
  }

  SlidableAction moveToGroceryItemAction() {
    return SlidableAction(
      label: 'to list',
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      icon: Icons.shopping_basket_outlined,
      onPressed: (context) {
        ref.read(groceryCardNotifierProvider.notifier)
            .addItemFromFridge(widget.client, widget.item);
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
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: (widget.item.quantity <= 1) ? const Text("") :
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Text(
                "x${widget.item.quantity}",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: (_animationController.isAnimating) ? _colorAnimation.value : Theme.of(context).colorScheme.onSurfaceVariant,
                  )
              );
            }
          )
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
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.access_time,
            size: Theme.of(context).textTheme.bodySmall!.fontSize,
            color: Theme.of(context).colorScheme.onSurface,
          ),
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
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
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
        widget.item.notes,
        textAlign: TextAlign.justify,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
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
        "Added: $s",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
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
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
            ),
          ),
          Text(
            (widget.item.notes != "") ? widget.item.notes : "No notes.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize
            ),
          )
        ],
      ),
    );
  }

  Widget _displayActionButtons() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              _buttonFormatting(
                GestureDetector(
                  onLongPressUp: () async {
                    ExpansionTileController.of(context).collapse();
                    ref.read(fridgeCardNotifierProvider.notifier)
                        .remove(widget.client, widget.item);
                  },
                  child:
                  ElevatedButton.icon(
                    onPressed: (isSelected) ? null : () async {
                      await reduceOrDelete(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
                    ),
                    label: const Text("Wasted"),
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
              _buttonFormatting(
                GestureDetector(
                  onLongPressUp: () async {
                    ExpansionTileController.of(context).collapse();
                    ref.read(fridgeCardNotifierProvider.notifier)
                        .remove(widget.client, widget.item);
                  },
                  child:
                  ElevatedButton.icon(
                    onPressed: (isSelected) ? null : () async {
                      await reduceOrDelete(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
                    ),
                    label: const Text("Eaten"),
                    icon: const Icon(Icons.restaurant_menu, size: 20.0,),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Future<void> reduceOrDelete(BuildContext context) async {
    if (isSelected) {
      return;
    }

    if (widget.item.quantity > 1) {
      var update = {
        "item_id": widget.item.id,
        "new_quantity": widget.item.quantity-1
      };
      ref.read(fridgeCardNotifierProvider.notifier)
          .updateItemByID(widget.client, update, rebuild: false);
      startAnimation();
      setState(() {
        widget.item.quantity -= 1;
      });
    } else {
      ExpansionTileController.of(context).collapse();
      ref.read(fridgeCardNotifierProvider.notifier)
          .remove(widget.client, widget.item);
    }
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


