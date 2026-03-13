

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/provider/product_provider.dart';
import 'package:project_l/wtfridge/view/product_selection_view.dart';
import '../components/under_construction_message.dart';

class MealsView extends ConsumerStatefulWidget {
  const MealsView({super.key});

  @override
  ConsumerState<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends ConsumerState<MealsView> {


  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productNotifierProvider);
    return Scaffold(
      body: Container(
        color: const Color(0xFF141414),
        child: const Center(
          child: UnderConstructionMessage(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ProductSelectionView.displayAsFullScreen(context);
        },
      ),
    );
  }
}