import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:duitgone2/helpers/data_export/data_export.dart' as stub;
import 'package:duitgone2/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DataExporter implements stub.DataExporter {
  static Future<String> exportData() async {
    await Transaction.loadData();

    return await _exportAndroid();
  }

  static Future<String> getExternalDownloadPath() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      log("Storage permission is not granted. Requesting permission...");
      await Permission.storage.request();
    }

    final newStatus = await Permission.storage.status;

    if (!newStatus.isGranted) {
      throw Exception("Write permission needed to export data!");
    }

    var downloadDir = await getExternalStorageDirectory();

    if (Platform.isAndroid) {
      downloadDir = Directory("storage/emulated/0/Download/duitGone2");
    }

    if (downloadDir == null && !Platform.isAndroid) {
      throw Exception("Download path does not exist!");
    }

    if (Platform.isAndroid & (await downloadDir!.exists()) == false) {
      // create new download
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

  static Future<String> _exportAndroid() async {
    String downloadPath = await getExternalDownloadPath();

    final String? filename = _getFilename();

    if (filename == null) {
      throw Exception("No data to export");
    }

    final filePath = "$downloadPath/$filename";
    final downloadFile = File(filePath);
    final data = jsonEncode({"transactions": Transaction.getData()});

    downloadFile.writeAsString(data);

    return "Data saved at $filePath";
  }

  static String? _getFilename() {
    final dates = Transaction.getDates();

    // since date are in "YYYY-MM-DD" fromat, can use default sort
    dates.sort();

    if (dates.isEmpty) return null;

    // oldest
    final oldest = dates.first;
    final latest = dates.last;

    final filename = "duitgone2-$oldest-$latest.json";
    return filename;
  }
}
