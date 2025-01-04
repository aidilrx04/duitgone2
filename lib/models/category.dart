import 'dart:convert';

class Category {
  late String label;

  Category({required this.label});

  static List<String> generateMockData() {
    return <String>[
      "Breakfast",
      "Lunch",
      "Dinner",
      "Grocery",
      "Hygiene",
      "Subscription",
      "Others",
    ];
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
