import 'dart:convert';
import 'dart:math';

import 'package:duitgone2/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  late double amount;
  late String category;
  late DateTime date;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
  });

  static List<Transaction> generateMockData({double total = 10}) {
    final random = Random();

    final categories = Category.generateMockData();

    const min = -25.0;
    const max = 25.0;

    final transactions = <Transaction>[];

    for (var i = 0; i < total; i++) {
      final category = categories[random.nextInt(categories.length)];
      final amount = random.nextDouble() * (min.abs() + max.abs()) + min;
      final now = DateTime.now();
      final date = DateTime(
        now.year,
        now.month,
        now.day,
        random.nextInt(23),
        random.nextInt(59),
      );

      final transaction =
          Transaction(amount: amount, category: category, date: date);

      transactions.add(transaction);
    }
    return transactions;
  }

  static Future<List<Transaction>> getData() async {
    // get all data stored locally
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList("transactions");

    if (list == null) return [];

    return list.map(Transaction.fromString).toList();
  }

  static Future<bool> save(Transaction t) async {
    final String json = jsonEncode(t);

    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
        "transactions", [json, ...?prefs.getStringList("transactions")]);

    return true;
  }

  Map<String, dynamic> get asMap {
    return {
      "amount": amount,
      "category": category,
      "date": date.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return asMap;
  }

  Transaction.fromString(String string) {
    final json = jsonDecode(string);

    amount = (json['amount'] as num).toDouble();
    category = json['category'];
    date = DateTime.parse(json['date']);
  }
}
