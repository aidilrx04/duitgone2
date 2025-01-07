import 'package:duitgone2/models/category.dart';
import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/edit_transactions/edit_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTransactions extends StatefulWidget {
  const EditTransactions(
      {super.key, required this.transactions, required this.onSaveTap});

  final List<Transaction> transactions;
  final void Function(List<Transaction>) onSaveTap;

  @override
  State<EditTransactions> createState() => _EditTransactionsState();
}

class _EditTransactionsState extends State<EditTransactions> {
  List<Transaction> inEdit = [];
  Map<Transaction, Transaction> editted = {};
  late List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = Category.generateMockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Transactions"),
        actions: [
          TextButton(
              onPressed: () {
                final latest = widget.transactions.map((t) {
                  if (editted.containsKey(t)) return editted[t]!;
                  return t;
                }).toList();

                widget.onSaveTap(latest);
              },
              child: Text("SAVE"))
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final transaction in widget.transactions)
                    if (inEdit.contains(transaction))
                      _showEditTile(transaction, editted[transaction])
                    else
                      _showNormalTile(transaction, editted[transaction])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _showEditTile(Transaction transaction, Transaction? edit) {
    return EditTile(
      transaction: edit ?? transaction,
      categories: categories,
      onAcceptTapped: (Transaction updated) {
        _addUpdatedTransaction(transaction, updated);
      },
      onCancelTapped: () {
        _removeInEdit(transaction);
      },
    );
  }

  ListTile _showNormalTile(Transaction ori, Transaction? edit) {
    final transaction = edit ?? ori;

    return ListTile(
      title: Text(
          "${transaction.category} | ${transaction.amount.toStringAsFixed(2)}"),
      subtitle: Text(
        DateFormat("hh:mm a").format(transaction.date),
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (editted[ori] != null)
              IconButton(
                  onPressed: () {
                    setState(() {
                      editted.remove(ori);
                    });
                  },
                  icon: Icon(Icons.replay)),
            IconButton(
                onPressed: () {
                  setState(() {
                    inEdit.add(ori);
                    editted[ori] = edit ??
                        Transaction(
                            amount: ori.amount,
                            category: ori.category,
                            date: ori.date);
                  });
                },
                icon: Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }

  void _addUpdatedTransaction(Transaction original, Transaction updated) {
    setState(() {
      editted[original] = updated;
      inEdit.remove(original);
    });
  }

  void _removeInEdit(Transaction transaction) {
    setState(() {
      inEdit.remove(transaction);
    });
  }
}
