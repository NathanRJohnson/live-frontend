
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/grocery_provider.dart';
import 'manual_add_form.dart';

class GroceryAddButton extends ConsumerWidget {
  const GroceryAddButton({super.key});


  Future<void> displayAddForm(BuildContext context, Function action) async {
    return await showDialog<void>(
      context: context,
      builder: (context) =>  AlertDialog(
          backgroundColor: const Color(0xFF292929),
          elevation: 0,
          title:  Text("Add Item",
              style: TextStyle(
                  color: Colors.grey[200]
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(
                  color: Colors.white60
              )
          ),
          content: const ManualAddForm(action_type: "grocery",)
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        displayAddForm(context, (String s) {
          ref.read(groceryNotifierProvider.notifier)
              .addItem(s);
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: DottedBorder(
            color: Color(0xFFAAAAAA),
            strokeWidth: 1,
            dashPattern: const [16],
            child: const ClipRRect(
              child: Center(
                heightFactor: 1.75,
                child: Icon(
                  Icons.add,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            )),
      ),
    );
  }

}