import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import '../provider/grocery_card_provider.dart';
import '../components/common/item_action_form.dart';

class GroceryAddForm extends ItemActionForm {
  late VoidCallback onSubmit = (){};

  GroceryAddForm({super.key, super.fields, super.actionButtons, super.title, required super.formKey});

  @override
  GroceryAddFormState createState() => GroceryAddFormState();
}

class GroceryAddFormState extends ItemActionFormState {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  late final TextEditingController dateController;

  DateTime dateAdded = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    quantityController = TextEditingController(text: "1");
    notesController = TextEditingController();
    dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
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
    await ref.read(groceryCardNotifierProvider.notifier).addItem(IOClient(), addForm);
  }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
      formKey: widget.formKey,
      title: "Add new item",
      fields: [
        textField(labelText: "Name", controller: nameController, validator: requiredFieldValidator),
        textField(labelText: "Quantity", controller: quantityController, validator: (value) {
          String? r = requiredFieldValidator(value);
          if (r != null) return null;
          String? i = integerFieldValidator(value);
          return i;
        }, keyboardType: TextInputType.number),
        textField(labelText: "Notes", controller: notesController, validator: (string){ return null; }),
      ],
      actionButtons: [
        cancelActionButton(),
        actionButton("Add", _action),
        actionAndRepeatButton("Add & Continue", _action)
      ],
    );
  }
}
