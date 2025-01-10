import 'package:duitgone2/helpers/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage implements AbstractLocalStorage {
  @override
  Future<String?> read(String path) async {
    /**
     * read content from shared preference key
     */

    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(path);

    return content;
  }

  @override
  Future<bool> write(String path, String content) async {
    /**
     * Write path as the key to shared preferences
     * Write content as string value
     */

    final prefs = await SharedPreferences.getInstance();

    prefs.setString(path, content);

    return true;
  }

  @override
  Future<List<String>> readFilesInDirectory(String path) async {
    final prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();

    // check if path contains separator at last
    if (path.substring(path.length - 1) != "/") {
      path = "$path/";
    }

    // check if path is root
    if (path == "/") {
      path = "";
    }

    final matchFilenameRe = RegExp("$path(.+)");

    final roughMatches = <String>[];

    // print("Path: $path");
    for (final key in keys) {
      final match = matchFilenameRe.firstMatch(key);

      // print("Key: $key");
      // print("Regex: ${match?.pattern}");
      // print("Has Match: ${match != null ? true : false}");
      // print("Matches: ${match?.group(1)}");
      // print("\n\n");

      if (match == null) continue;

      roughMatches.add(match.group(1)!);
    }

    final results = <String>[];

    for (final rough in roughMatches) {
      if (rough.contains("/")) continue;
      results.add(rough);
    }

    return results;
  }
}
