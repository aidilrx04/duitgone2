import 'dart:convert';

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
}
