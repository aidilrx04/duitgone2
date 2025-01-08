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
}
