import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import '../components/common/item_action_form.dart';
import 'package:project_l/wtfridge/provider/fridge_card_provider.dart';

class FridgeAddForm extends ItemActionForm {
  FridgeAddForm({super.key, super.fields, super.actionButtons, super.title, required super.formKey}){
    formKey = GlobalKey<FormState>();
  }

  @override
  FridgeAddFormState createState() => FridgeAddFormState();
}

class FridgeAddFormState extends ItemActionFormState {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  late final TextEditingController dateController;

  DateTime dateAdded = DateTime.now();

  @override
  void initState() {
    nameController = TextEditingController();
    quantityController = TextEditingController(text: "1");
    notesController = TextEditingController();
    dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
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
      "date_added": dateController.text.trim()
    };
      ref.read(fridgeCardNotifierProvider.notifier).addItem(IOClient(), addForm);
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
          dateField(labelText: "Date Added", controller: dateController,
              validator: (value) {
                try {
                  DateTime.parse(value!);
                } on Exception {
                  setState(() {
                    focusLabelColor = Colors.red;
                    unfocusedLabelColor = Colors.red;
                  });
                  return 'Please enter a valid date added for the item.';
                }
                return null;
              }
          ),
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
