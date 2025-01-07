import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/edit_transactions/edit_transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDataUpdated,
  });

  final List<Transaction> transactions;

  final void Function(List<Transaction>) onDataUpdated;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: transactions.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransactions(
                            transactions: transactions,
                            onSaveTap: (List<Transaction> list) {
                              onDataUpdated(list);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    }
                  : null,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              if (transactions.isEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 200),
                  child: Center(
                    child: Text(
                      "No transaction today",
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                ),
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
