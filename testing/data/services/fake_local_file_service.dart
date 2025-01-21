import 'dart:convert';

import 'package:duitgone2/data/services/local_file_service.dart';

import '../models/transaction.dart';

class FakeLocalFileService implements LocalFileService {
  @override
  Future<String?> readDocument(String path) async {
    return jsonEncode([kTransaction]);
  }

  @override
  Future<bool> writeDocument(String path, String content) async {
    return true;
  }
}
