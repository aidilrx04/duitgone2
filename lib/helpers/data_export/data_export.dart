class DataExporter {
  /// Export data to application download folder on mobile,
  /// or download the file on web
  ///
  /// Return [String] success message containing the path if successful.
  /// Throws [Exception] if failed
  static Future<String> exportData() async {
    throw UnsupportedError("Error, platform is not supported");
  }
}
