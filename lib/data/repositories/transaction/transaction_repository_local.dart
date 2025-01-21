import 'dart:convert';

import 'package:duitgone2/data/repositories/transaction/transaction_repository.dart';
import 'package:duitgone2/data/services/local_file_service.dart';
import 'package:duitgone2/models/transaction/transaction.dart';
import 'package:intl/intl.dart';

class TransactionRepositoryLocal implements TransactionRepository {
  TransactionRepositoryLocal({
    required LocalFileService localFileService,
  }) : _localFileService = localFileService;

  final LocalFileService _localFileService;

  final prefix = "transactions/";

  @override
  Future<List<Transaction>> getTransactions(DateTime date) async {
    final filename = "$prefix${dateToFilename(date)}";

    final content = await _localFileService.readDocument(filename);

    if (content == null) return [];

    final decode = jsonDecode(content);

    final transactionList = (decode as List)
        .map((element) => Transaction.fromJson(element as Map<String, dynamic>))
        .toList();

    return transactionList;
  }

  @override
  Future<List<Transaction>> saveTransactions(
    DateTime date,
    List<Transaction> transactions,
  ) async {
    final filename = "$prefix${dateToFilename(date)}";

    final json = jsonEncode(transactions);

    await _localFileService.writeDocument(filename, json);

    return transactions;
  }

  String dateToFilename(DateTime date) {
    final formatter = DateFormat("yyyy-MM-dd");

    return formatter.format(date);
  }
}
