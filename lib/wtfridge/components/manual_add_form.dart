import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:project_l/wtfridge/provider/grocery_provider.dart';

import '../provider/fridge_provider.dart';


class ManualAddForm extends ConsumerStatefulWidget {
  final String action_type;
  const ManualAddForm({super.key, required this.action_type});

  @override
  ConsumerState<ManualAddForm> createState() => _ManualAddFormState();
}

class _ManualAddFormState extends ConsumerState<ManualAddForm> {
final nameController = TextEditingController();
final formKey = GlobalKey<FormState>();

Color unfocusedLabelColor = Colors.white60;
Color focusLabelColor = Colors.green;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

/* TODO: i hate this code, but it's the only think I can think of to get
         around the grocery add button being destroyed every time a new item is added.
         At worst it could be an enum. At best I make an addable interface.
 */
  void action() {
    if (widget.action_type == "test") {
      return;
    }

    if (widget.action_type == "grocery"){
      ref.read(groceryCardNotifierProvider.notifier).addItem(IOClient(), nameController.text.trim());
    } else {
      ref.read(fridgeNotifierProvider.notifier).addItem(nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                setState(() {
                  focusLabelColor = Colors.red;
                  unfocusedLabelColor = Colors.red;
                });
                return 'Please enter a name for the item.';
              }
              return null;
            },

            cursorColor: Colors.green,
            autofocus: true,

            // Input text
            style: const TextStyle(
              color: Colors.white,
              decorationColor: Colors.white60
            ),

            // Label text pre-focus
            decoration: InputDecoration(
              labelText: 'Name',
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

              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white60
                      ))
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        action();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                     "Add",
                      style: TextStyle(
                      color: Colors.green
                    ))
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        action();
                        nameController.clear();
                      }
                    },
                    child: const Text(
                        "Add & Continue",
                        style: TextStyle(
                            color: Colors.green
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
