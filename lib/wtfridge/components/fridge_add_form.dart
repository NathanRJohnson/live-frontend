import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import '../components/common/form_utils.dart';
import '../components/common/item_action_form.dart';
import 'package:project_l/wtfridge/provider/fridge_card_provider.dart';

class FridgeAddForm extends ConsumerStatefulWidget {
  const FridgeAddForm({super.key});

  @override
  ConsumerState<FridgeAddForm> createState() => _FridgeAddFormState();
}

class _FridgeAddFormState extends ConsumerState<FridgeAddForm> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  late final TextEditingController dateController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      ref.read(fridgeCardNotifierProvider.notifier).addItem(addForm);
    }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
        formKey: formKey,
        title: "Add new item",
        fields: [
          FormUtils.textField(context: context, labelText: "Name", controller: nameController, validator: FormUtils.requiredFieldValidator),
          FormUtils.textField(context: context, labelText: "Quantity", controller: quantityController, validator: (value) {
            String? r = FormUtils.requiredFieldValidator(value);
            if (r != null) return null;
            String? i = FormUtils.integerFieldValidator(value);
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
          FormUtils.actionButton(context, formKey, "Add", _action),
          FormUtils.actionButton(context, formKey, "Add & Continue", _action, closeOnAction: false, resetOnAction: true)
        ],
    );
  }
}