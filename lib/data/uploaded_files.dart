class UploadedFiles {
  final Map<int, String> _files = {};

  /// Adds a file URL if it's not already uploaded.
  /// Returns the existing ID if found, otherwise adds a new entry.
  int addFile(int id, String url) {
    if (_files.containsValue(url)) {
      return _files.entries.firstWhere((entry) => entry.value == url).key;
    }
    _files[id] = url;
    return id;
  }

  /// Retrieves the ID of a file if it has already been uploaded.
  int? getIdByUrl(String url) {
    return _files.entries
        .firstWhere((entry) => entry.value == url, orElse: () => const MapEntry(-1, ''))
        .key;
  }

  /// Retrieves the URL of an uploaded file by its ID.
  String? getUrlById(int id) => _files[id];

  /// Checks if a file has already been uploaded.
  bool containsUrl(String url) => _files.containsValue(url);

  /// Returns all stored files.
  Map<int, String> get allFiles => Map.unmodifiable(_files);
}
