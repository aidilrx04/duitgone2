import 'package:duitgone2/models/category/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

abstract class CategoryRepository {
  static var defaultCategories = [
    Category(label: "Breakfast", color: Colors.teal.toHexString()),
    Category(label: "Lunch", color: Colors.pink.toHexString()),
    Category(label: "Dinner", color: Colors.deepPurple.toHexString()),
    Category(label: "Grocery", color: Colors.orange.toHexString()),
    Category(label: "Hygiene", color: Colors.yellow.toHexString()),
    Category(label: "Subscription", color: Colors.blue.toHexString()),
    Category(label: "Others", color: Colors.brown.toHexString()),
  ];

  Future<Category> createCategory(Category category);

  Future<List<Category>> getCategories();
}
