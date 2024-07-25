import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/provider/grocery_provider.dart';

class UpdateItemForm extends ConsumerStatefulWidget {
  final Function action;
  final String currentContent;
  const UpdateItemForm({super.key, required this.action, required this.currentContent});

  @override
  ConsumerState<UpdateItemForm> createState() => _UpdateItemFormState();

  static void displayUpdateItemForm(BuildContext context, Function action, String currentContent) async {
    return await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF292929),
            elevation: 0,
            title:  Text("Update Item",
                style: TextStyle(
                    color: Colors.grey[200]
                )),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                    color: Colors.white60
                )
            ),
            content: UpdateItemForm(
              currentContent: currentContent,
              action: action,
            )
        )
    );
  }
}

class _UpdateItemFormState extends ConsumerState<UpdateItemForm> {
  late final nameController;
  final formKey = GlobalKey<FormState>();

  Color unfocusedLabelColor = Colors.white60;
  Color focusLabelColor = Colors.blueAccent;

  @override void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentContent);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void action() {
    if (nameController.text.trim() == widget.currentContent){
      return;
    }
    widget.action(nameController.text.trim());
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
                return "Item name must contain a character.";
              }
              return null;
            },
            cursorColor: Colors.blueAccent,
            autofocus: true,

            style: const TextStyle(
              color: Colors.white,
              decorationColor: Colors.white60
            ),

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
                  color: Colors.blueAccent,
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
                        "Update",
                        style: TextStyle(
                            color: Colors.blueAccent
                        ))
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


