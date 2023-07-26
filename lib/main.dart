import 'package:flutter/material.dart';
import 'package:tsb_wine_list/models/alcohol_model.dart';
import 'package:tsb_wine_list/screens/home_screen.dart';
import 'package:tsb_wine_list/screens/alcohol_detail.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final Map<String, WidgetBuilder> _routes = {
    '/': (BuildContext context) => const HomeScreen(),
    '/wine': (BuildContext context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final alcohol = args?['alcohol'] as AlcoholModel?;

      // Pass the wineName to the WineDetail widget
      return AlcoholDetail(
          alcohol: alcohol ??
              AlcoholModel.fromJson({})); // Provide a default value if needed
    },
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: _routes,
    );
  }
}
