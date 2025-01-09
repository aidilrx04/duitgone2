import 'dart:developer';
import 'dart:io';

import 'package:duitgone2/helpers/local_storage/local_storage.dart';
import 'package:path/path.dart' as p;
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
    final Directory pathToFile = Directory(p.dirname(file.path));

    // check if path to file exist
    if ((await pathToFile.exists()) == false) {
      // log("${pathToFile.path} directory no exists! Will create the folders");
      // create directory
      // create all nonexisting folders provided by [path]
      await pathToFile.create(recursive: true);
    }

    // log("Writing to ${file.path}");
    file.writeAsStringSync(content);
    return true;
  }

  @override
  Future<List<String>> readFilesInDirectory(String path) async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();

    final targetDir = Directory("${documentsDir.path}/$path");

    if ((await targetDir.exists()) == false) return [];

    final List<String> files = [];

    targetDir.listSync().forEach((entity) {
      if (entity is File) {
        final filename = p.basename(entity.path);
        files.add(filename);
      }
    });

    return files;
  }
}
