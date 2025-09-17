import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

class PlatformInterface {
  static QueryExecutor createDatabaseConnection(String databaseName) {
    print("Hello I am in the web connectionCreation function!");
    return DatabaseConnection.delayed(Future(() async {
      final database = await WasmDatabase.open(
        databaseName: databaseName,
        sqlite3Uri: Uri.parse('/sqlite3.wasm'),
        driftWorkerUri: Uri.parse(
          kDebugMode ? '/worker.dart.min.js' : '/worker.dart.js',
        ),
      );
      print(database.toString());
      return database.resolvedExecutor;
    }));
  }
}