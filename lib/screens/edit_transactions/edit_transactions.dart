import 'package:duitgone2/models/category.dart';
import 'package:duitgone2/models/transaction.dart';
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
  Map<Transaction, String> currentSelectedCat = {};

  @override
  void initState() {
    super.initState();
    categories = Category.generateMockData();
  }

  @override
  Widget build(BuildContext context) {
    print(editted);
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

  SizedBox _showEditTile(Transaction ori, Transaction? edit) {
    final transaction = (edit ?? ori);
    final amountController =
        TextEditingController(text: transaction.amount.toStringAsFixed(2));
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit ${transaction.category} | ${transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          print(amountController.text);
                          editted[ori] = Transaction(
                              amount: double.parse(amountController.text),
                              category: transaction.category,
                              date: transaction.date);
                          currentSelectedCat.remove(ori);
                          inEdit.remove(ori);
                        });
                      },
                      icon: Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          inEdit.remove(ori);
                        });
                      },
                      icon: Icon(Icons.close),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Amount",
              ),
              onChanged: (value) {
                edit!.amount = double.parse(value);
              },
              onTapOutside: (ev) {
                setState(() {
                  edit!.amount = edit.amount;
                });
              },
            ),
            SizedBox(
              height: 5,
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              alignment: WrapAlignment.start,
              children: [
                for (final category in categories)
                  ChoiceChip(
                    label: Text(category),
                    selected: transaction.category == category,
                    onSelected: (selected) {
                      setState(() {
                        editted[ori]!.category = category;
                      });
                    },
                  )
              ],
            )
          ],
        ),
      ),
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
}
