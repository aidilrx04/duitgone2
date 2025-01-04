import 'package:duitgone2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
  });

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                size: 20,
              ),
            ),
          ],
        ),
        Card(
          color: Colors.white,
          child: Column(
            children: [
              for (final transaction in transactions)
                ListTile(
                  title: Text(
                    transaction.category,
                  ),
                  subtitle: Text(
                    DateFormat("hh:mm a").format(transaction.date),
                  ),
                  trailing: Text(
                    transaction.amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 20,
                      color: transaction.amount > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
