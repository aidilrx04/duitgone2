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

  /// Write the content into a file inside application documents directory
  ///
  /// On mobile, if [path] is a file name(no "/" in path), will write the content in the file.
  ///
  /// If [path] is a file inside nonexisting directory, the directory will be created first then the content is written inside [path]
  /// ```dart
  /// final localStorage = LocalStorage();
  /// localStorage.write("filename". "content"); // -> will write content to <documents path>/filename
  /// localStorage.write("path/to/filename", "content"); // -> will write content to "<documents path>/path/to/filename"
  /// ```
  ///
  /// ---
  ///
  /// On web, either [path] is file or directory, will write to [SharedPreferences] as is.
  /// ```dart
  /// final localStorage = LocalStorage();
  /// localStorage.write("filename". "content"); // -> {"filename": "content"}
  /// localStorage.write("path/to/filename", "content"); // -> {"path/to/filename": "content"}
  /// ```
  ///
  /// Returns true
  Future<bool> write(String path, String content);
}
