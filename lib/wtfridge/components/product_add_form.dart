

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/components/common/form_utils.dart';
import 'package:project_l/wtfridge/components/common/item_action_form.dart';
import 'package:project_l/wtfridge/model/grocery_item.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';

class ProductAddForm extends ConsumerStatefulWidget {
  final String? productName;
  const ProductAddForm({super.key, required this.productName});

  @override
  ConsumerState<ProductAddForm> createState() => _ProductAddFormState();

  static void displayForm(BuildContext context, String? productName) async {
    return await showDialog<void>(
      context: context,
      builder: (context) =>  Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: ProductAddForm(productName: productName)
      ),
    );
  }
}

class _ProductAddFormState extends ConsumerState<ProductAddForm> {
  late final TextEditingController nameController;
  final formKey = GlobalKey<FormState>();
  String? _section;

  @override void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.productName);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future<void> _action() async {
    var addForm = <String, String>{
      "name": nameController.text.trim(),
      "section": _section ?? GroceryItem.getSections()[0],
    };

    await ref.read(productNotifierProvider.notifier).addCustomItem(addForm);
    ref.read(productNotifierProvider.notifier).getProductsBySearchTerm(addForm["name"]!);
  }

  void _updateSection(String? newSection) {
    setState(() {
      _section = newSection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
      formKey: formKey,
      title: "Add new product",
      fields: [
        FormUtils.textField(context: context, labelText: "Product Name", controller: nameController, validator: FormUtils.requiredFieldValidator),
        FormUtils.dropdownSelectionField(context: context, labelText: "section", onChanged: _updateSection, validator: FormUtils.requiredFieldValidator, choices: GroceryItem.getSections())
      ],
      actionButtons: [
        FormUtils.cancelActionButton(context),
        FormUtils.actionButton(context, formKey, "Add", _action)
      ],
    );
  }



}