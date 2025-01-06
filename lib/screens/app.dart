import 'package:duitgone2/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({super.key});

  final _testDateSelector = false;

  @override
  Widget build(BuildContext context) {
    if (_testDateSelector) {
      SharedPreferences.getInstance().then((pref) {
        final yesterday = DateTime.now().subtract(Duration(days: 1));
        final today = DateTime.now();
        final tomorrow = DateTime.now().add(Duration(days: 1));
        final _data = """{
"${DateFormat("yyyy-MM-dd").format(yesterday)}": [
{"amount": 1, "category": "Category 1", "date": "${yesterday.toString()}"}
],
"${DateFormat("yyyy-MM-dd").format(today)}": [
{"amount": 1, "category": "Category 1", "date": "${today.toString()}"},
{"amount": 1, "category": "Category 2", "date": "${today.toString()}"}
],
"${DateFormat("yyyy-MM-dd").format(tomorrow)}": [
{"amount": 1, "category": "Category 1", "date": "${tomorrow.toString()}"},
{"amount": 1, "category": "Category 2", "date": "${tomorrow.toString()}"},
{"amount": 1, "category": "Category 3", "date": "${tomorrow.toString()}"}
]
}""";
        print(_data);
        pref.setString("transactions", _data);
      });
    }

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
