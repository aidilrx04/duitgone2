import 'package:duitgone2/models/category/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction(
      {required double amount,
      required Category category,
      required DateTime date}) = _Transaction;

  factory Transaction.fromJson(Map<String, Object?> json) =>
      _$TransactionFromJson(json);
}
