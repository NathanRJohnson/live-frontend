import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../handler/fridge_handler.dart';
import '../provider/fridge_provider.dart';


class ManualAddForm extends ConsumerStatefulWidget {
  const ManualAddForm({super.key});

  @override
  ConsumerState<ManualAddForm> createState() => _ManualAddFormState();
}

class _ManualAddFormState extends ConsumerState<ManualAddForm> {
final nameController = TextEditingController();
final handler = FridgeHandler();
final formKey = GlobalKey<FormState>();

Color unfocusedLabelColor = Colors.white60;
Color focusLabelColor = Colors.green;

@override
void dispose() {
  nameController.dispose();
  super.dispose();
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
              color: Colors.white60,
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
                        color: Colors.blueGrey
                      ))
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ref.read(fridgeNotifierProvider.notifier)
                          .addItemByName(nameController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                     "Add",
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
