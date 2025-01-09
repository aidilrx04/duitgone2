export 'empty_local_storage.dart'
    if (dart.library.io) 'io_local_storage.dart'
    if (dart.library.html) 'web_local_storage.dart';

abstract class AbstractLocalStorage {
  Future<String?> read(String path);

  /// Read files in a directory(concept)
  ///
  /// On mobile, this method will return lists of filenames in the [path]
  ///
  /// On web, this method will return lists of matching keys like
  /// ```dart
  /// var final = LocalStorage().readFilesInDirectory("transactions");
  /// ```
  ///
  /// the method will look for keys starting with "transactions/"
  /// and return the string after the "/"
  Future<List<String>> readFilesInDirectory(String path);
  Future<bool> write(String path, String content);
}
