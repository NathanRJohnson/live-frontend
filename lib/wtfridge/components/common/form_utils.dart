import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormUtils {

  // Method to build a TextFormField
  static TextFormField textField({ required String labelText, required TextEditingController controller, required String? Function(String? value) validator, IconButton? suffixIcon, TextInputType? keyboardType}) {
    // controllers.add(controller);
    return TextFormField(
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
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          color: Color(0xFF49454F),
        ),

        // Label text post-focus
        floatingLabelStyle: const TextStyle(
            color: Colors.green
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
    );
  }

  static Widget dateField({ required BuildContext context, required String labelText, required TextEditingController controller, required String? Function(String? value) validator, IconButton? suffixIcon, TextInputType? keyboardType}) {
    return GestureDetector(
        onTap: () async {
          await _selectDate(context, controller);
        },
        child: AbsorbPointer(
            child: textField(
                labelText: labelText,
                controller: controller,
                validator: validator,
                suffixIcon: suffixIcon,
                keyboardType: keyboardType
            )
        )
    );
  }


  static Future<Null> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime dateAdded = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.input,
        initialDate: dateAdded,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: Colors.green
                  )
              ),
              child: child!);
        }
    );
    if (picked != null && picked != dateAdded) {
        dateAdded = picked;
        controller.value = TextEditingValue(text: DateFormat('yyyy-MM-dd').format(dateAdded));
    }
  }


  static Widget formTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize
        ),
      ),
    );
  }


  static String? integerFieldValidator(String? value) {
    if (value == null || value.contains(".")) {
      return 'Quantity must be an integer.';
    }

    if (int.parse(value) <= 0 ) {
      return 'Value must be greater than 0';
    }
    return null;
  }


  static String? requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field requires a value.';
    }
    return null;
  }


  static TextButton actionButton(BuildContext context, GlobalKey<FormState> formKey, String label, Future<void> Function() action) {
    return TextButton(
        onPressed: () {
          final formState = formKey.currentState;
          if (formState != null && formState.validate()) {
            action();
            Navigator.of(context).pop();
          }
        },
        child: Text(
            label,
            style: const TextStyle(
                color: Colors.green
            ))
    );
  }


  static TextButton actionAndRepeatButton(GlobalKey<FormState> formKey, String label, VoidCallback action) {
    return TextButton(
        onPressed: () {
          final formState = formKey.currentState;
          if (formState != null && formState.validate()) {
            action();
            formState.reset();
          }
        },
        child: Text(
            label,
            style: const TextStyle(
                color: Colors.green
            )
        )
    );
  }


  static TextButton cancelActionButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
            "Cancel",
            style: TextStyle(color: Color(0xFF1D1B20))
        )
    );
  }

}