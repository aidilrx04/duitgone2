import 'dart:math';

import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/add_record/add_record.dart';
import 'package:duitgone2/screens/home/date_select_bar.dart';
import 'package:duitgone2/screens/home/home_drawer.dart';
import 'package:duitgone2/screens/home/transaction_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const title = "duitGone2_";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Transaction>? transactions;

  DateTime date = DateTime.now();

  List<String>? dates;

  @override
  void initState() {
    super.initState();
    Transaction.loadData().then((val) {
      setState(() {
        transactions = Transaction.getDataDay(date);
        dates = Transaction.getDates();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body =
        transactions != null ? _createHomeDetail() : Text("Loading...");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: _createAppBar(context),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddRecord(
                    onRecordAdded: _addTransaction,
                  )));
        },
        child: Icon(
          Icons.add,
          size: 32,
        ),
      ),
      body: body,
    );
  }

  ListView _createHomeDetail() {
    return ListView(
      children: [
        DateSelectBar(
          currentDate: date,
          availables: dates!,
          onDateSelected: (String selectedDate) {
            setState(() {
              date = DateTime.parse(selectedDate);
              transactions = Transaction.getDataDay(date);
            });
          },
        ),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PieChart(
            duration: Duration(milliseconds: 250),
            PieChartData(
              sections: transactions!.isNotEmpty
                  ? _createSections(transactions!)
                  : _createEmptyPieSection(),
              centerSpaceRadius: 0,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Center(
          child: Text(
            transactions!
                .map((mon) => mon.amount)
                .fold(0.0, (acc, val) => acc + val)
                .toStringAsFixed(2),
            style: TextStyle(fontSize: 26),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TransactionList(
            transactions: transactions!,
            onDataUpdated: _onTransactionsUpdated,
          ),
        ),
        SizedBox(
          height: 60,
        )
      ],
    );
  }

  void _onTransactionsUpdated(List<Transaction> updatedTransactions) {
    Transaction.saveTransactionsByDay(date, updatedTransactions).then((val) {
      setState(() {
        transactions = updatedTransactions;
      });
    });
  }

  AppBar _createAppBar(BuildContext context) => AppBar(
        title: Text(
          Home.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        }),
      );

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
      Colors.black,
      Colors.white,
    ];

    final groups = _groupTransactionByCategory(transactions);

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

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions!.insert(0, transaction);

      // save transactions
      Transaction.save(transaction);
    });
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
}
