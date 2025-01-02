import 'package:duitgone2/models/money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyList extends StatelessWidget {
  const MoneyList({
    super.key,
    required this.moneys,
  });

  final List<Money> moneys;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          for (final money in moneys)
            ListTile(
              title: Text(
                money.category.label,
              ),
              subtitle: Text(
                DateFormat("hh:mm a").format(money.date),
              ),
              trailing: Text(money.amount.toStringAsFixed(2)),
            ),
        ],
      ),
    );
  }
}
