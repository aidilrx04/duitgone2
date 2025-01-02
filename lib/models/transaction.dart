import 'dart:math';

import 'package:duitgone2/models/category.dart';

class Transaction {
  final double amount;
  final Category category;
  final DateTime date;

  const Transaction({
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

      final transaction = Transaction(amount: amount, category: category, date: date);

      transactions.add(transaction);
    }
    return transactions;
  }
}
