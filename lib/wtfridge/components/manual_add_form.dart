import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

import '../provider/grocery_card_provider.dart';
import '../provider/fridge_card_provider.dart';

class ManualAddForm extends ConsumerStatefulWidget {
  final String action_type;
  const ManualAddForm({super.key, required this.action_type});

  @override
  ConsumerState<ManualAddForm> createState() => _ManualAddFormState();
}

class _ManualAddFormState extends ConsumerState<ManualAddForm> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late final TextEditingController notesController;
  late final TextEditingController dateController;
  final formKey = GlobalKey<FormState>();
  DateTime dateAdded = DateTime.now();

  Color unfocusedLabelColor = const Color(0xFF49454F);
  Color focusLabelColor = const Color(0xFF2562FF);

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
    quantityController.dispose();
    nameController.dispose();
    super.dispose();
  }

/* TODO: i hate this code, but it's the only think I can think of to get
         around the grocery add button being destroyed every time a new item is added.
         At worst it could be an enum. At best I make an addable interface.
 */
  void action() {
    if (widget.action_type == "test") {
      return;
    }

    var addForm = <String, String> {
      "item_name": nameController.text.trim(),
      "quantity": quantityController.text.trim(),
      "notes": notesController.text.trim(),
      "date_added": dateController.text.trim()
    };

    if (widget.action_type == "grocery"){
      ref.read(groceryCardNotifierProvider.notifier).addItem(IOClient(), nameController.text.trim());
    } else {
      ref.read(fridgeCardNotifierProvider.notifier).addItem(IOClient(), addForm);
    }
  }

  Widget _displayField(String labelText, TextEditingController controller, String? Function(String? value) validator, {IconButton? suffixIcon, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        autofocus: true,

        // Input text
        style: const TextStyle(
          color: Color(0xFF1D1B20),
          decorationColor: Colors.black
        ),

        // Label text pre-focus
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: unfocusedLabelColor,
          ),

          // Label text post-focus
          floatingLabelStyle: TextStyle(
            color: focusLabelColor
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusLabelColor,
            ),
          ),

          suffixIcon: suffixIcon

        ),
      ),
    );
  }

  String? integerFieldValidator(String? value) {
    if (value == null || value.contains(".")) {
      return 'Quantity must be an integer.';
    }

    if (int.parse(value) <= 0 ) {
      return 'Value must be greater than 0';
    }
    return null;
  }

  String? requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        focusLabelColor = Colors.red;
        unfocusedLabelColor = Colors.red;
      });
      return 'Please enter a quantity for the item.';
    }
    return null;
  }

  String _formatDateTimeToString(DateTime t) {
    return "${t.year}-${t.month}-${t.day}";
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      initialDate: dateAdded,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue
            )
          ),
          child: child!);
      }
    );
    if (picked != null && picked != dateAdded) {
      setState(() {
        dateAdded = picked;
        dateController.value = TextEditingValue(text: DateFormat('yyyy-MM-dd').format(dateAdded));
      });
    }
  }

  Widget _displayDateInputField() {
    return GestureDetector(
      onTap: () async {
        await _selectDate(context);
      },
      child: AbsorbPointer(
        child: _displayField(
          "Date Added",
          dateController,
          (value) {
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
            },
          suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: (){},
            )
          ),
        )
      );
  }

  Widget _displayFormTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
      child: Text(
        "Add new item",
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _displayFormTitle(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _displayField("Name", nameController, requiredFieldValidator),
                  _displayField("Quantity", quantityController,
                  (value) {
                    String? r = requiredFieldValidator(value);
                    if (r != null) return null;
                    String? i = integerFieldValidator(value);
                    return i;
                  },
                  keyboardType: TextInputType.number),
                  _displayDateInputField(),
                  _displayField("Notes", notesController, (string){ return null; }),
                ],
              ),
            ),
          ),



          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF1D1B20)
                      ))
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        action();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                     "Add",
                      style: TextStyle(
                      color: focusLabelColor
                    ))
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      action();
                      nameController.clear();
                    }
                  },
                  child: Text(
                    "Add & Continue",
                    style: TextStyle(
                      color: focusLabelColor
                    ))
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
