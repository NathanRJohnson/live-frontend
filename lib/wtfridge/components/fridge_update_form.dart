import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:project_l/wtfridge/components/common/form_utils.dart';
import '../model/fridge_item.dart';
import '../provider/fridge_card_provider.dart';
import '../components/common/item_action_form.dart';

class FridgeUpdateForm extends ConsumerStatefulWidget {
  final FridgeItem currentItem;

  const FridgeUpdateForm({super.key, required this.currentItem});

  @override
  ConsumerState<FridgeUpdateForm> createState() => _FridgeUpdateFormState();

  static void displayUpdateItemForm(BuildContext context, FridgeItem currentItem) async {
    return await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: FridgeUpdateForm(currentItem: currentItem)
        )
    );
  }
}

class _FridgeUpdateFormState extends ConsumerState<FridgeUpdateForm> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  late final TextEditingController dateController;

  final formKey = GlobalKey<FormState>();

  @override void initState() {
    nameController = TextEditingController(text: widget.currentItem.name);
    quantityController = TextEditingController(text: widget.currentItem.quantity.toString());
    notesController = TextEditingController(text: widget.currentItem.notes);
    dateController = TextEditingController(text: widget.currentItem.dateAdded.toString());
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    notesController.dispose();
    dateController.dispose();
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
      "new_date": DateTime.parse(dateController.text.trim()),
      "new_quantity": int.parse(quantityController.text.trim()),
      "new_notes": notesController.text.trim(),
    };

    await ref.read(fridgeCardNotifierProvider.notifier).updateItemByID(IOClient(), formValues);
  }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
      formKey: formKey,
      title: "Update item",
      fields: [
        FormUtils.textField(context: context, labelText: "Name", controller: nameController, validator: FormUtils.requiredFieldValidator),
        FormUtils.textField(context: context, labelText: "Quantity", controller: quantityController, validator: (value) {
          String? r =  FormUtils.requiredFieldValidator(value);
          if (r != null) return null;
          String? i =  FormUtils.integerFieldValidator(value);
          return i;
        }, keyboardType: TextInputType.number),
        FormUtils.dateField(context: context, labelText: "Date Added", controller: dateController,
            validator: (value) {
              try {
                DateTime.parse(value!);
              } on Exception {
                return 'Please enter a valid date added for the item.';
              }
              return null;
            }
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