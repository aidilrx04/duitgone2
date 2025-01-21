import 'package:duitgone2/models/transaction/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> saveTransactions(
      DateTime date, List<Transaction> transactions);

  Future<List<Transaction>> getTransactions(DateTime date);
}
