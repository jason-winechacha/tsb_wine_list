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
    '/alcohol': (BuildContext context) {
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

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          // backgroundColor: Color(0xFF17182B), // sets the background color
          backgroundColor: Colors.transparent, // sets the background color
          foregroundColor: Colors.white, // sets the text color
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 50,
        ),
        primaryColor: const Color(0xFF2C4344),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.red.shade400,
          surface: const Color(0xFF0ABAB5),
        ),
        sliderTheme: SliderThemeData(
          inactiveTrackColor: Colors.white,
          activeTrackColor: Colors.red.shade400,
          valueIndicatorColor: Colors.white,
          thumbColor: Colors.red.shade400,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      // onGenerateRoute: (settings) {
      //   // 동적인 라우팅 처리
      //   if (settings.name!.startsWith('/alcohol/')) {
      //     final id = int.parse(settings.name!.split('/').last);
      //     return MaterialPageRoute(
      //       builder: (context) => AlcoholDetail(id: id),
      //     );
      //   }
      //   return null;
      // },
    );
  }
}
