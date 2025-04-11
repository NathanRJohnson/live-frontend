
abstract class Storage {
  // Future<void> read
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
}