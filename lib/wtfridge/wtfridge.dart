import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined), label: "Groceries"),
    const BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Fridge"),
    const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Meals"),
  ];

  // https://www.youtube.com/watch?v=mgpW7Ba2Pns&ab_channel=SyntacOps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: (){
            context.go('/');
          },
          child: const Text('WhatTheFridge',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),
        ),
        backgroundColor: const Color(0xFF292929),
        automaticallyImplyLeading: false
      ),
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
         _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        backgroundColor: const Color(0xFF292929),
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.green,
      ),
    );
  }
}