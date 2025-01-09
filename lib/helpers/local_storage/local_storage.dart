export 'empty_local_storage.dart'
    if (dart.library.io) 'io_local_storage.dart'
    if (dart.library.html) 'web_local_storage.dart';

abstract class AbstractLocalStorage {
  Future<String?> read(String path);
  Future<bool> write(String path, String content);
}
