import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/edit_transactions/edit_transactions.dart';
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
              onPressed: transactions.length > 0
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTransactions(
                                    transactions: transactions,
                                    onSaveTap: (List<Transaction> list) {
                                      list.map((v) => v.asMap).forEach(print);
                                    },
                                  )));
                    }
                  : null,
              icon: Icon(
                Icons.edit,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: Expanded(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  if (transactions.length == 0)
                    Expanded(
                        child: Center(
                      child: Text(
                        "No transaction today",
                        style: TextStyle(color: Colors.black45),
                      ),
                    )),
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
                          color: transaction.amount > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
