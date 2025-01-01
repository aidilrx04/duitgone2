import 'dart:math';

import 'package:duitgone2/models/money.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final moneys = Money.generateMockData();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            size: 32,
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: PieChart(
                duration: Duration(milliseconds: 250),
                PieChartData(
                  sections: _createSections(moneys),
                  centerSpaceRadius: 0,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                moneys
                    .map((mon) => mon.amount)
                    .reduce((acc, val) => acc + val)
                    .toStringAsFixed(2),
                style: TextStyle(fontSize: 26),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MoneyList(moneys: moneys),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createSections(List<Money> moneys) {
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
      Colors.black,
      Colors.white,
    ];
    return moneys.map((money) {
      return PieChartSectionData(
        value: money.amount.abs(),
        title: money.category,
        titlePositionPercentageOffset: 1,
        color: colors[Random().nextInt(colors.length)],
        radius: 100,
      );
    }).toList();
  }
}

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
                money.category,
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
