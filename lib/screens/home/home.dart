import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/add_record/add_record.dart';
import 'package:duitgone2/screens/home/date_select_bar.dart';
import 'package:duitgone2/screens/home/home_drawer.dart';
import 'package:duitgone2/screens/home/transaction_chart.dart';
import 'package:duitgone2/screens/home/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ChartType { ALL, EXPENSE, INCOME }

class Home extends StatefulWidget {
  const Home({super.key});
  static const title = "duitGone2";

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

    Future.wait([
      Transaction.getTransactions(date),
      Transaction.getAvailableTransactions()
    ]).then((completed) {
      setState(() {
        transactions = completed[0] as List<Transaction>;
        dates = completed[1] as List<String>;
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
          onDateSelected: _setNewTransactions,
        ),
        TransactionChart(
          transactions: transactions!,
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

  void _setNewTransactions(String selectedDate) {
    date = DateTime.parse(selectedDate);
    Transaction.getTransactions(date).then(
      (transactions_) {
        setState(() {
          date = date;
          transactions = transactions_;
        });
      },
    );
  }

  void _onTransactionsUpdated(List<Transaction> updatedTransactions) {
    Transaction.saveTransactions(date, updatedTransactions).then((val) {
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

  void _addTransaction(Transaction transaction) {
    final formatter = DateFormat("yyyy-MM-dd");
    // get diff in days between current selected date and today
    final diff = DateTime.parse(formatter.format(transaction.date)).difference(
      DateTime.parse(
        formatter.format(date),
      ),
    );

    // subtract difference between selected date and today
    transaction.date = transaction.date.subtract(
      diff,
    );

    Transaction.saveTransaction(transaction).then((val) {
      setState(() {
        transactions!.insert(0, transaction);
      });
    });
  }
}
