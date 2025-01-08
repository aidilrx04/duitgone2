import 'dart:convert';

import 'package:flutter/material.dart';

class Category {
  late String label;

  static const categories = <String>[
    "Breakfast",
    "Lunch",
    "Dinner",
    "Grocery",
    "Hygiene",
    "Subscription",
    "Others",
  ];

  static const defaultColor = Colors.white70;
  static const colors = <String, Color>{
    "Breakfast": Colors.teal,
    "Lunch": Colors.pink,
    "Dinner": Colors.deepPurple,
    "Grocery": Colors.orange,
    "Hygiene": Colors.yellow,
    "Subscription": Colors.blue,
    "Others": Colors.brown,
  };

  Category({required this.label});

  static List<String> generateMockData() {
    return categories;
  }

  Map<String, dynamic> get asMap {
    return {
      "label": label,
    };
  }

  Category.fromString(String string) {
    final json = jsonDecode(string);
    label = json['label'];
  }

  static Color getColor(String category) {
    return colors[category] ?? defaultColor;
  }
}
