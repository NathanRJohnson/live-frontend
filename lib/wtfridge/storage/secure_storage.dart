import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_l/wtfridge/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage extends Storage {
  final storage = const FlutterSecureStorage();
  @override

  Future<String?> read({required String key}) async {
      return await storage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

}