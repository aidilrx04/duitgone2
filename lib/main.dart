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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
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
              ),
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
