import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/form_utils.dart';
import '../components/common/item_action_form.dart';
import '../provider/grocery_card_provider.dart';

class GroceryAddForm extends ConsumerStatefulWidget {
  const GroceryAddForm({super.key});

  @override
  ConsumerState<GroceryAddForm> createState() => _GroceryAddFormState();
}

class _GroceryAddFormState extends ConsumerState<GroceryAddForm> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    quantityController = TextEditingController(text: "1");
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _action() async {
    var addForm = <String, String> {
      "item_name": nameController.text.trim(),
      "quantity": quantityController.text.trim(),
      "notes": notesController.text.trim(),
    };
    await ref.read(groceryCardNotifierProvider.notifier).addItem(addForm);
  }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
      formKey: formKey,
      title: "Add new item",
      fields: [
        FormUtils.textField(context: context, labelText: "Name", controller: nameController, validator: FormUtils.requiredFieldValidator),
        FormUtils.textField(context: context, labelText: "Quantity", controller: quantityController, validator: (value) {
          String? r =  FormUtils.requiredFieldValidator(value);
          if (r != null) return null;
          String? i =  FormUtils.integerFieldValidator(value);
          return i;
        }, keyboardType: TextInputType.number),
        FormUtils.textField(context: context, labelText: "Notes", controller: notesController, validator: (string){ return null; }),
      ],
      actionButtons: [
        FormUtils.cancelActionButton(context),
        FormUtils.actionButton(context, formKey, "Add", _action),
        FormUtils.actionAndRepeatButton(context, formKey, "Add & Continue", _action)
      ],
    );
  }
}
