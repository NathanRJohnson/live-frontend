
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'form_utils.dart';

class ItemActionForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget>? fields;
  final List<TextButton>? actionButtons;
  final String? title;

  const ItemActionForm({super.key, required this.formKey, this.fields, this.actionButtons, this.title});

  @override
  ConsumerState<ItemActionForm> createState() => _ItemActionFormState();
}

class _ItemActionFormState extends ConsumerState<ItemActionForm> {
  final List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormUtils.formTitle(context, widget.title!),
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
