import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:project_l/wtfridge/components/common/form_utils.dart';
import 'package:project_l/wtfridge/components/common/item_action_form.dart';
import 'package:project_l/wtfridge/handler/handler.dart';
import 'package:project_l/wtfridge/provider/fridge_card_provider.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController userController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  Future<void> _loadForm() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString("user") ?? "";
    userController.text = text;
  }

  @override
  void dispose() {
    userController.dispose();


    super.dispose();
  }

  Future<void> _action() async {
    print("PING");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", userController.text);
    // TODO: proper input validation here.
    // ref.read(budgetNotifierProvider.notifier).fetchBudget(Client());
    // ref.read(transactionListNotifierProvider.notifier).fetchTransactions(Client());
    // TODO: add handler to login here
    Handler h = Handler(client: Client());
    await h.login(prefs.getString("user")!);

    await ref.read(groceryCardNotifierProvider.notifier).syncToDB(Client());
    await ref.read(fridgeCardNotifierProvider.notifier).syncToDB(Client());
  }

  @override
  Widget build(BuildContext context) {
    return ItemActionForm(
      formKey: formKey,
      title: "",
      fields: [
        FormUtils.textField(context: context, labelText: "username", controller: userController, validator: FormUtils.requiredFieldValidator)
      ],
      actionButtons: [
        // FormUtils.cancelActionButton(context),
        FormUtils.actionButton(context, formKey, "Login", _action)
      ],
    );
  }
}