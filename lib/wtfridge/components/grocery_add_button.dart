
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/grocery_provider.dart';
import '../components/grocery_add_form.dart';

class GroceryAddButton extends ConsumerWidget {
  const GroceryAddButton({super.key});

  Future<void> openGroceryAddForm(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (context) =>  const Dialog(
        backgroundColor: Color(0xFFFFFFFF),
        child: GroceryAddForm()
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        openGroceryAddForm(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: DottedBorder(
              color: const Color(0xFFAAAAAA),
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
      ),
    );
  }

}