
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ItemActionForm extends ConsumerStatefulWidget {
  List<Widget>? fields;
  List<TextButton>? actionButtons = [];
  String? title;
  GlobalKey<FormState> formKey;
  ItemActionForm({super.key, required this.formKey, this.fields, this.actionButtons, this.title}) {
    fields ??= [];
    actionButtons ??= [];
    title ??= "";
  }

  @override
  ItemActionFormState createState() => ItemActionFormState();
}

class ItemActionFormState extends ConsumerState<ItemActionForm> {
  final List<TextEditingController> controllers = [];
  Color unfocusedLabelColor = const Color(0xFF49454F);
  Color focusLabelColor = const Color(0xFF2562FF);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextFormField textField({ required String labelText, required TextEditingController controller, required String? Function(String? value) validator, IconButton? suffixIcon, TextInputType? keyboardType}) {
    controllers.add(controller);
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
      return 'This field requires a value.';
    }
    return null;
  }

  Future<Null> _selectDate(BuildContext context, TextEditingController controller) async {
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
              primary: Colors.blue
            )
          ),
          child: child!);
      }
    );
    if (picked != null && picked != dateAdded) {
      setState(() {
        dateAdded = picked;
        controller.value = TextEditingValue(text: DateFormat('yyyy-MM-dd').format(dateAdded));
      });
    }
  }

  Widget dateField({ required String labelText, required TextEditingController controller, required String? Function(String? value) validator, IconButton? suffixIcon, TextInputType? keyboardType}) {
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

  Widget formTitle(String text) {
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

  TextButton cancelActionButton() {
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

  TextButton actionButton(String label, Future<void> Function() action) {
    return TextButton(
        onPressed: () async {
          if (widget.formKey.currentState!.validate()) {
            await action();
            _clearForm();
            Navigator.of(context).pop();
          }
        },
        child: Text(
            label,
            style: TextStyle(
                color: focusLabelColor
            ))
    );
  }

  TextButton actionAndRepeatButton(String label, VoidCallback action) {
    return TextButton(
      onPressed: () {
        if (widget.formKey.currentState!.validate()) {
          action();
          _clearForm();
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: focusLabelColor
        )
      )
    );
  }

  void _clearForm() {
    for (TextEditingController controller in controllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          formTitle(widget.title!),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                  children: List.generate(widget.fields!.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: widget.fields!.elementAt(i),
                    );
                  }),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.actionButtons!,
            ),
          )
        ],
      )
    );
  }
}
