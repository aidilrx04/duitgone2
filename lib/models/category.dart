class Category {
  final String label;
  final String? icon;

  Category({required this.label, this.icon});

  static List<Category> generateMockData() {
    return <Category>[
      Category(label: "Breakfast"),
      Category(label: "Lunch"),
      Category(label: "Dinner"),
      Category(label: "Grocery"),
      Category(label: "Hygiene"),
      Category(label: "Subscription"),
      Category(label: "Others"),
    ];
  }
}
