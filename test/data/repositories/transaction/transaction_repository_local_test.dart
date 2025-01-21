import 'package:duitgone2/data/repositories/transaction/transaction_repository.dart';
import 'package:duitgone2/data/repositories/transaction/transaction_repository_local.dart';
import 'package:duitgone2/data/services/local_file_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/data/services/fake_local_file_service.dart';
import '../../../../testing/data/models/transaction.dart';

void main() {
  group("TransactionRepositoryLocal", () {
    late TransactionRepository transactionRepository;
    late LocalFileService localFileService;

    setUp(() {
      localFileService = FakeLocalFileService();
      transactionRepository = TransactionRepositoryLocal(
        localFileService: localFileService,
      );
    });

    test("should write transaction", () {
      final result = transactionRepository
          .saveTransactions(DateTime.now(), [kTransaction]);

      expectLater(result, completion(equals([kTransaction])));
    });

    test("should read transaction", () {
      final result = transactionRepository.getTransactions(DateTime.now());

      expectLater(result, completion(equals([kTransaction])));
    });
  });
}
