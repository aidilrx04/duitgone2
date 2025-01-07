import 'dart:convert';

import 'package:duitgone2/helpers/data_export/data_export.dart' as stub;
import 'package:duitgone2/models/transaction.dart';

import 'dart:html' as html;

class DataExporter implements stub.DataExporter {
  static Future<String> exportData() async {
    await Transaction.loadData();

    return await _exportWeb();
  }

  static Future<String> _exportWeb() async {
    final filename = _getFilename();

    if (filename == null) {
      throw Exception("No data to export");
    }

    final data = Transaction.getData();

    final json = jsonEncode({"transactions": data});

    final blob = html.Blob([json], 'application/json');

    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = filename;

    anchor.click();

    html.Url.revokeObjectUrl(url);

    return "File downloaded as $filename";
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
