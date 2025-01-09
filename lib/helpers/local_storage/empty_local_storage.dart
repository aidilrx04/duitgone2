import 'package:duitgone2/helpers/local_storage/local_storage.dart';

class LocalStorage implements AbstractLocalStorage {
  @override
  Future<String?> read(String path) {
    throw UnsupportedError("Platform not supported!");
  }

  @override
  Future<bool> write(String path, String content) {
    throw UnsupportedError("Platform not supported");
  }
}
