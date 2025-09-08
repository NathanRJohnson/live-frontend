import 'package:project_l/wtfridge/storage/storage.dart';

class MockStorage extends Storage {

  final Map<String, String> store = {};

  @override
  Future<void> write({required String key, required String value}) async {
    store[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return store[key];
  }

}