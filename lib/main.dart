import 'package:duitgone2/models/money.dart';
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
              child: Placeholder(),
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
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
