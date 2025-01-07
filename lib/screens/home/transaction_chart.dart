import 'dart:math';
import 'package:duitgone2/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionChart extends StatefulWidget {
  const TransactionChart({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  State<TransactionChart> createState() => _TransactionChartState();
}

class _TransactionChartState extends State<TransactionChart> {
  String currentChart = "Expenses";

  @override
  Widget build(BuildContext context) {
    final chart = currentChart == "Expenses"
        ? _createExpenseChart()
        : _createIncomeChart();
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 250, maxWidth: double.infinity),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 250,
                child: chart,
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: "Expenses",
                    child: Text("Expenses"),
                  ),
                  DropdownMenuItem(
                    value: "Income",
                    child: Text("Income"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    currentChart = value as String;
                  });
                },
                value: currentChart,
                focusColor: Colors.transparent,
              ),
            ),
          )
        ],
      ),
    );
  }

  PieChart _createExpenseChart() {
    return PieChart(
      duration: Duration(milliseconds: 250),
      PieChartData(
        startDegreeOffset: 270,
        sections: widget.transactions.isNotEmpty
            ? _createSections(widget.transactions
                .where(
                (element) => element.amount < 0,
              )
                .map((element) {
                return Transaction(
                  amount: element.amount.abs(),
                  category: element.category,
                  date: element.date,
                );
              }).toList())
            : _createEmptyPieSection(),
        centerSpaceRadius: 0,
      ),
    );
  }

  Map<String, double> _groupTransactionByCategory(
    List<Transaction> transactions,
  ) {
    Map<String, double> group = {};

    for (final trans in transactions) {
      if (group[trans.category] != null) {
        group[trans.category] = group[trans.category]! + trans.amount;
        continue;
      }

      group[trans.category] = trans.amount;
    }

    return group;
  }

  List<PieChartSectionData> _createSections(List<Transaction> transactions) {
    const colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    // sort by largest

    var groups = _groupTransactionByCategory(transactions);
    final sorted = groups.entries.toList();
    sorted.sort((a, b) {
      return (b.value - a.value).toInt();
    });

    groups.clear();
    for (final entry in sorted) {
      groups[entry.key] = entry.value;
    }

    return groups.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        titlePositionPercentageOffset: 1,
        color: colors[Random().nextInt(colors.length)],
        radius: 100,
      );
    }).toList();
  }

  List<PieChartSectionData> _createEmptyPieSection() {
    return [
      PieChartSectionData(
        value: 100,
        color: Colors.black12,
        title: "No Data",
        radius: 130,
        titlePositionPercentageOffset: 0,
      ),
    ];
  }

  PieChart _createIncomeChart() {
    return PieChart(
        duration: Duration(milliseconds: 250),
        PieChartData(
            startDegreeOffset: 270,
            centerSpaceRadius: 0,
            sections: widget.transactions.isNotEmpty
                ? _createSections(widget.transactions
                    .where((element) => element.amount > 0)
                    .toList())
                : _createEmptyPieSection()));
  }
}
