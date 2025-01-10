import 'dart:convert';

import 'package:duitgone2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTile extends StatefulWidget {
  const EditTile({
    super.key,
    required this.transaction,
    required this.categories,
    required this.onAcceptTapped,
    required this.onCancelTapped,
  });

  final Transaction transaction;
  final List<String> categories;
  final void Function(Transaction updated) onAcceptTapped;
  final void Function() onCancelTapped;

  @override
  State<EditTile> createState() => _EditTileState();
}

class _EditTileState extends State<EditTile> {
  late TextEditingController amountController;
  late Transaction editTransaction;
  late String selectedCategory;

  // validation
  bool showInvalidAmount = false;

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );

    editTransaction = Transaction.fromString(
      jsonEncode(widget.transaction.asMap),
    );

    selectedCategory = widget.transaction.category;
  }

  @override
  Widget build(BuildContext context) {
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
                  "Edit ${widget.transaction.category} | ${widget.transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _onCheckTapped,
                      icon: Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: widget.onCancelTapped,
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}'))
              ],
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Amount",
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              alignment: WrapAlignment.start,
              children: [
                for (final category in widget.categories)
                  ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
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

  _onCheckTapped() {
    final double? isAmountValid = _validateAmount(amountController.text);
    if (isAmountValid == null) {
      setState(() {
        showInvalidAmount = true;
      });
      return;
    }

    editTransaction.amount = isAmountValid;
    editTransaction.category = selectedCategory;

    widget.onAcceptTapped(editTransaction);
  }

  double? _validateAmount(String text) {
    try {
      return double.parse(text);
    } catch (e) {}
    return null;
  }
}
