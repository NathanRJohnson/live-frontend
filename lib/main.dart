import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:project_l/wtfridge/provider/fridge_card_provider.dart';
import 'package:project_l/wtfridge/provider/grocery_card_provider.dart';

import 'wtfridge/wtfridge.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/fridge',
      builder: (context, state) => const WTFridgeMainPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const FirstRoute(),
    ),
  ],
);


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: _fridgeTheme(),
      routerConfig: _router,
    );
  }

  ThemeData _fridgeTheme() {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF63A002), //0xFF63A002 //0xFFA06902
        brightness: Brightness.dark,
      ),
    );
  }
}

class FirstRoute extends ConsumerWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fridgeCardNotifierProvider.notifier).syncToDB(Client());
      ref.read(groceryCardNotifierProvider.notifier).syncToDB(Client());
      context.push('/fridge');
    });

    return Scaffold(
      backgroundColor: const Color(0xFF292929),
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () async {
            // Navigate to second route when tapped.
            // ref.read(fridgeNotifierProvider.notifier).syncToDB();
            // ref.read(groceryNotifierProvider.notifier).syncToDB();
            // if (context.mounted) {
            //   context.push('/fridge');
            // }
          },
        ),
      ),
    );
  }
}