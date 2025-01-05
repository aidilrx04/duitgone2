import 'dart:convert';
import 'dart:math';

import 'package:duitgone2/models/category.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Transactions data structure in storage
/// "transactions": {
/// "YYYY-mm-dd": [
///   {
///   "amount": 10.00,
///   "category": "Category Label",
///   "date": "YYYY-mm-dd HH:mm:ss"
///   },
///   ...
/// ],
/// ...
/// }
///

typedef Entry = MapEntry<String, List<Map<String, dynamic>>>;

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

  static Map<String, List<Transaction>> _data = {};

  /// Get all transactions data in local storage
  /// Return format should Map<String, List<Transaction>>
  static Future<void> loadData() async {
    // get all data stored locally
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getString("transactions");

    if (list == null) return;

    var data = jsonDecode(list) as Map<String, dynamic>;

    final Map<String, List<Transaction>> mapped = {};

    for (final entry in data.entries) {
      mapped[entry.key] = (entry.value as List).map((map) {
        return Transaction.fromString(jsonEncode(map));
      }).toList();
    }

    _data = mapped;
  }

  static List<Transaction> getDataDay(DateTime date) {
    final String dateString = DateFormat("yyyy-MM-dd").format(date);

    final List<Transaction>? transactions = _data[dateString];

    if (transactions == null) return [];

    return transactions;
  }

  static Future<bool> save(Transaction t) async {
    final prefs = await SharedPreferences.getInstance();

    final date = DateFormat("yyyy-MM-dd").format(t.date);

    _data[date] = [
      t,
      ...?_data[date],
    ];

    final String json = jsonEncode(_data);

    prefs.setString("transactions", json);
    // prefs.setStringList(
    //     "transactions", [json, ...?prefs.getStringList("transactions")]);

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
