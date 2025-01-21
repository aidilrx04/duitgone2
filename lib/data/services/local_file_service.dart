import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalFileService {
  Future<bool> writeDocument(String path, String content) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File("${documentsDir.path}/$path");
    final dirToFile = Directory(dirname(file.path));

    final dirToFileExists = await dirToFile.exists();

    if (dirToFileExists == false) {
      await dirToFile.create(recursive: true);
    }

    try {
      file.writeAsStringSync(content);
    } on Exception catch (error) {
      throw Exception("Failed to write to $path");
    }

    return true;
  }

  Future<String?> readDocument(String path) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File("${documentsDir.path}/$path");
    final fileExist = await file.exists();

    if (fileExist == false) return null;

    final content = await file.readAsString();

    return content;
  }
}
