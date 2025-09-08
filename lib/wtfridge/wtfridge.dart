import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_l/wtfridge/components/login_promt.dart';
import 'package:project_l/wtfridge/components/page_loading_indicator.dart';
import 'package:project_l/wtfridge/components/settings_drawer.dart';
import 'package:project_l/wtfridge/provider/fridge_card_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/grocery_view.dart';
import 'view/fridge_view.dart';
import 'view/meals_view.dart';

class WTFridgeMainPage extends StatefulWidget {
  const WTFridgeMainPage({super.key});

  @override
  State<WTFridgeMainPage> createState() => _WTFridgePageState();
}

class _WTFridgePageState extends State<WTFridgeMainPage> {
  int _currentIndex = 1;

  final PageController _pageController = PageController(initialPage: 1);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final SharedPreferences prefs;
  late final _prefsFuture = SharedPreferences.getInstance().then((v) => prefs = v);

  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined), label: "Groceries"),
    const BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Fridge"),
    const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Meals"),
  ];

  // https://www.youtube.com/watch?v=mgpW7Ba2Pns&ab_channel=SyntacOps
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(fridgeCardNotifierProvider);
        return FutureBuilder(
          future: _prefsFuture, builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return PageLoadingIndicator();
          }
          if (prefs.getString("user") == null) {
            return LoginPrompt();
          } else {
            return Scaffold(
              key: _key,
              appBar: AppBar(
                  leading: IconButton(
                      onPressed: () => _key.currentState!.openDrawer(),
                      icon: const Icon(Icons.menu)),
                  title: Text('WhatTheFridge',
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurface,
                      fontSize: 24,
                    ),
                  ),
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .surfaceContainerHigh,
                  automaticallyImplyLeading: false
              ),
              drawerEnableOpenDragGesture: false,
              drawer: const SettingsDrawer(),
              body: PageView(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (newIndex) {
                  setState(() {
                    _currentIndex = newIndex;
                  });
                },
                children: const [
                  GroceryView(),
                  FridgeView(),
                  MealsView()
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                items: _bottomNavigationBarItems,
                onTap: (index) {
                  _pageController.animateToPage(
                      index, duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .surfaceContainerHigh,
                unselectedItemColor: Theme
                    .of(context)
                    .colorScheme
                    .outline,
                selectedItemColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
              ),
            );
          }
        });
      });
  }
}