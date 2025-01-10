import 'dart:convert';
import 'dart:math' show Random;

import 'package:duitgone2/helpers/local_storage/local_storage.dart';
import 'package:duitgone2/models/category.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Transactions data structure in file storage
/// Filename should indicate the date of the transactions, eg: 2025-01-01.json
/// On mobiles, Data inside file should formatted like this:
/// [
///   {
///     "amount": 10.00,
///     "category": "Category Label"
///     "date": "yyyy-MM-dd hh:mm:ss"
///   }
/// ]
///
/// On Web, data will be stored as SharedPreferences data like this
/// {
///   ...,
///   "transactions/2025-01-01": [
///     ...
///   ]
///   ...
/// }
///

typedef Entry = MapEntry<String, List<Map<String, dynamic>>>;

class Transaction {
  late double amount;
  late String category;
  late DateTime date;

  static final LocalStorage _localStorage = LocalStorage();

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
  });

  static List<Transaction> generateMockData({double total = 10}) {
    final random = Random();

    final categories = Category.generateMockData();

    const min = -25.0;
    const max = 25.0;

    final transactions = <Transaction>[];

    for (var i = 0; i < total; i++) {
      final category = categories[random.nextInt(categories.length)];
      final amount = random.nextDouble() * (min.abs() + max.abs()) + min;
      final now = DateTime.now();
      final date = DateTime(
        now.year,
        now.month,
        now.day,
        random.nextInt(23),
        random.nextInt(59),
      );

      final transaction =
          Transaction(amount: amount, category: category, date: date);

      transactions.add(transaction);
    }
    return transactions;
  }

  static Map<String, List<Transaction>> _data = {};

  /// Get all transactions data in local storage
  /// Return format should Map<String, List<Transaction>>
  static Future<void> loadData() async {
    // get all data stored locally
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getString("transactions");

    if (list == null) return;

    var data = jsonDecode(list) as Map<String, dynamic>;

    final Map<String, List<Transaction>> mapped = {};

    for (final entry in data.entries) {
      mapped[entry.key] = (entry.value as List).map((map) {
        return Transaction.fromString(jsonEncode(map));
      }).toList();
    }

    _data = mapped;
  }

  static Map<String, List<Transaction>> getData() {
    return _data;
  }

  static List<Transaction> getDataDay(DateTime date) {
    final String dateString = DateFormat("yyyy-MM-dd").format(date);

    final List<Transaction>? transactions = _data[dateString];

    if (transactions == null) return [];

    return transactions;
  }

  static List<String> getDates() {
    return _data.entries.map((entry) => entry.key).toList();
  }

  static Future<bool> save(Transaction t) async {
    final prefs = await SharedPreferences.getInstance();

    final date = DateFormat("yyyy-MM-dd").format(t.date);

    _data[date] = [
      t,
      ...?_data[date],
    ];

    final String json = jsonEncode(_data);

    prefs.setString("transactions", json);
    // prefs.setStringList(
    //     "transactions", [json, ...?prefs.getStringList("transactions")]);

    return true;
  }

  static Future<bool> saveTransactionsByDay(
      DateTime date, List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();

    final dateString = DateFormat("yyyy-MM-dd").format(date);

    _data[dateString] = transactions;

    final json = jsonEncode(_data);

    prefs.setString("transactions", json);

    return true;
  }

  Map<String, dynamic> get asMap {
    return {
      "amount": amount,
      "category": category,
      "date": date.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return asMap;
  }

  Transaction.fromString(String string) {
    final json = jsonDecode(string);

    amount = (json['amount'] as num).toDouble();
    category = json['category'];
    date = DateTime.parse(json['date']);
  }

  /// Save lists of transactions grouped by their date to local storage
  ///
  /// Will write to system then internal [_data]
  /// with matching date will be overwite.
  ///
  /// Returns true everytime.
  /// Currently there is no way for this method to return false
  static Future<bool> saveTransactions(
    DateTime date,
    List<Transaction> transactions,
  ) async {
    final key = _formatDateKey(date);
    final path = "transactions/$key";
    final transactionsString = jsonEncode(transactions);

    await _localStorage.write(path, transactionsString);

    _data[key] = transactions;

    return true;
  }

  /// Save transaction to local storage
  ///
  /// Will add the transactions to internal matching key [_data]
  /// as the first element if the key exists,
  /// else just create transaction in list as sole element
  ///
  /// Return true evertime.
  /// Currently there is no way for this method to return false.
  static Future<bool> saveTransaction(Transaction transaction) async {
    final key = _formatDateKey(transaction.date);
    _data[key] =
        _data[key] == null ? [transaction] : [transaction, ...?_data[key]];

    final path = "transactions/$key";
    final content = jsonEncode(_data[key]);

    await _localStorage.write(path, content);

    return true;
  }

  /// Get list of transactions from local storage
  ///
  /// Will load the transactions from file,
  /// then overwrite internal [_data] with matching date
  ///
  /// Return list of transactions if records exist, else an empty list
  static Future<List<Transaction>> getTransactions(DateTime date) async {
    final key = _formatDateKey(date);
    final path = "transactions/$key";

    final String? content = await _localStorage.read(path);

    if (content == null) return [];

    final parsedContent = jsonDecode(content);

    final List<Transaction> transactions = (parsedContent as Iterable)
        .map((data) => Transaction.fromString(jsonEncode(data)))
        .toList();

    // save transactions in memory
    _data[key] = transactions;

    // print(_data);
    return transactions;
  }

  static Future<List<String>> getAvailableTransactions() async {
    final availableTransactions =
        await _localStorage.readFilesInDirectory("transactions");

    return availableTransactions;
  }

  /// Format given date to string key used to store transactions
  ///
  /// Return [String] formatted as "yyyy-MM-dd"
  static String _formatDateKey(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}
