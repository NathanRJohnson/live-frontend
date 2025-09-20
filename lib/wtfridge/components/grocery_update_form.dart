import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:project_l/wtfridge/components/common/form_utils.dart';
import '../provider/grocery_card_provider.dart';
import '../components/common/item_action_form.dart';
import '../model/grocery_item.dart';

class GroceryUpdateForm extends ConsumerStatefulWidget {
  final GroceryItem currentItem;

  const GroceryUpdateForm({super.key, required this.currentItem});

  @override
  ConsumerState<GroceryUpdateForm> createState() => _GroceryUpdateFormState();

  static void displayUpdateItemForm(BuildContext context, GroceryItem currentItem) async {
    return await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: GroceryUpdateForm(currentItem: currentItem)
        )
    );
  }
}

class _GroceryUpdateFormState extends ConsumerState<GroceryUpdateForm> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  final formKey = GlobalKey<FormState>();

  @override void initState() {
    nameController = TextEditingController(text: widget.currentItem.name);
    quantityController = TextEditingController(text: widget.currentItem.quantity.toString());
    notesController = TextEditingController(text: widget.currentItem.notes);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _action() async {
    if ( nameController.text.trim() == widget.currentItem.name
        && int.parse(quantityController.text.trim()) == widget.currentItem.quantity
        && notesController.text.trim() == widget.currentItem.notes
    ){ return; }

    var formValues = <String, dynamic> {
      "item_id": widget.currentItem.id,
      "new_name": nameController.text.trim(),
      "new_quantity": int.parse(quantityController.text.trim()),
      "new_notes": notesController.text.trim(),
    };

    await ref.read(groceryCardNotifierProvider.notifier).updateItemByID(formValues);
  }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
      formKey: formKey,
      title: "Update item",
      fields: [
        FormUtils.textField(context: context, labelText: "Name", controller: nameController, validator: FormUtils.requiredFieldValidator),
        FormUtils.textField(context: context, labelText: "Quantity", controller: quantityController,
          validator: (value) {
            String? r =  FormUtils.requiredFieldValidator(value);
            if (r != null) return null;
            String? i =  FormUtils.integerFieldValidator(value);
            return i;
          },
          keyboardType: TextInputType.number
        ),
        FormUtils.textField(context: context, labelText: "Notes", controller: notesController, validator: (string){ return null; }),
      ],
      actionButtons: [
        FormUtils.cancelActionButton(context),
        FormUtils.actionButton(context, formKey, "Update", _action),
      ],
    );
  }
}