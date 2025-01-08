import 'dart:io';

import 'package:duitgone2/helpers/local_storage/local_storage.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage implements AbstractLocalStorage {
  /// Read saved files from application documents directory
  @override
  read(String path) async {
    /**
     * Get document directory
     * combine path with document directory
     * check if the file exists
     * if exists, read the file content and return as string
     * if not exist, return null
     */

    final Directory documentsDir = await getApplicationDocumentsDirectory();

    final File file = File("${documentsDir.path}/$path");

    if (!(await file.exists())) return null;

    final content = await file.readAsString();

    return content;
  }

  @override
  write(String path, String content) async {
    /**
     * Get documents directory
     * combine path directory
     * write to path
     * overwrite if the file exists
     */

    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File("${documentsDir.path}/$path");
    file.writeAsStringSync(content);
    return true;
  }
}
