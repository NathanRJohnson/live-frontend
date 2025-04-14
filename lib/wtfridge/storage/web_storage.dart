import 'package:project_l/wtfridge/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebStorage extends Storage {

  @override
  Future<String?> read({required String key}) async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString(key, value);
  }



}