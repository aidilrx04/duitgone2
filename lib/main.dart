import 'dart:developer';

import 'package:duitgone2/helpers/local_storage/local_storage.dart';
import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  final runTest = false;
  final mockData = false;

  // ignore: dead_code
  if (runTest) {
    runApp(const Placeholder());

    LocalTest().run();

    return;
  }
  runApp(const App());

  // ignore: dead_code
  if (mockData) {
    // insert localStorage mock data
    final localStorage = LocalStorage();
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final formatter = DateFormat("yyyy-MM-dd");
    final data = <DateTime, List<Transaction>>{
      yesterday: Transaction.generateMockData(),
      today: Transaction.generateMockData(),
      tomorrow: Transaction.generateMockData(),
    };

    for (final entry in data.entries) {
      Transaction.saveTransactions(entry.key, entry.value);
    }
  }
}

class LocalTest {
  void run() async {
    log("Running Test");
    await testLocalStorage();
  }

  testLocalStorage() async {
    final localStorage = LocalStorage();
    final filename = "testfile.txt";
    final filenameNoExtension = "testfile";
    final filenameInDirectory = "directory/testfile";
    final filenameInNestedDirectory = "directory1/directory2/testfile";

    final content = "Test content";

    // test .write() + some .read()
    log("Local storage should be able to write a file");
    await localStorage.write(filename, content);
    // verify
    final result = await localStorage.read(filename);

    log("Result: ${result == content}");

    log("Local Storage should be able to write a file without extension");
    await localStorage.write(filenameNoExtension, content);
    // verify
    final result2 = await localStorage.read(filenameNoExtension);
    log("Result: ${result2 == content}");

    log("Local Storage should be able to write a file in a directory");
    await localStorage.write(filenameInDirectory, content);
    // verify
    final result3 = await localStorage.read(filenameInDirectory);
    log("Result: ${result3 == content}");

    log("Local Storage should be able to write a file in a nested directory");
    await localStorage.write(filenameInNestedDirectory, content);
    // verify
    final result4 = await localStorage.read(filenameInNestedDirectory);
    log("Result: ${result4 == content}");

    // test .read()
    final filenameNotExist = "notexist";
    final filenameNotExistInDirectory = "noexistingdirectory/notexist";

    log("Local Storage should not be able to read a non existing file in a nested directory");
    // verify
    final result5 = await localStorage.read(filenameNotExist);
    log("Result: ${result5 == null}");

    log("Local Storage should not be able to read a non existing file in a nested directory");
    final result6 = await localStorage.read(filenameNotExistInDirectory);
    log("Result: ${result6 == null}");

    // test .readFilesInDirectory()
    final directory1 = "/";
    final directory2 = "directory";
    final directory3 = "directory1/directory2";
    final directory4 = "noexistingdirectory";

    log("Local storage should be able to list all files in application documents directory");
    final result7 = await localStorage.readFilesInDirectory(directory1);
    log("Result: ${result7.contains(filename)} ${result7.contains(filenameNoExtension)}");

    log("Local storage should be able to list all files in directory");
    final result8 = await localStorage.readFilesInDirectory(directory2);
    log("Result: ${result8.contains(filenameNoExtension)} ${result8.length == 1}");

    log("Local storage should be able to list all files in nested directory");
    final result9 = await localStorage.readFilesInDirectory(directory3);
    log("Result: ${result9.contains(filenameNoExtension)} ${result8.length == 1}");

    log("Local storage should not be able to list all files in nonexisting directory");
    final result10 = await localStorage.readFilesInDirectory(directory4);
    log("Result: ${result10.isEmpty}");
  }
}
