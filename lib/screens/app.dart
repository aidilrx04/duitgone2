import 'package:duitgone2/screens/Home/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: Home(),
    );
  }
}
