
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:project_l/wtfridge/handler/product_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {

  setUp(() {

  });

  group("test tryUpdateDatabaseHash", () {

    final mockClient = MockClient(
        (request) async {
          return http.Response("0x00001", 200);
        });

    test("test_tryUpdateDatabaseHash_no_existing_hash", () async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final productHandler = ProductHandler(httpClient: mockClient);
      expect(await productHandler.tryUpdateDatabaseHash(), isTrue);
      expect(prefs.get("productHash"), isNotEmpty);
    });

    
    test("test_tryUpdateDatabaseHash_outdated_hash", () async {
      SharedPreferences.setMockInitialValues({"productHash": "0x00000"});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final productHandler = ProductHandler(httpClient: mockClient);
      expect(await productHandler.tryUpdateDatabaseHash(), isTrue);
      expect(prefs.get("productHash"), equals("0x00001"));
    });


    test("test_tryUpdateDatabaseHash_same_hash", () async {
      SharedPreferences.setMockInitialValues({"productHash": "0x00000"});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final productHandler = ProductHandler(httpClient: mockClient);
      expect(await productHandler.tryUpdateDatabaseHash(), isTrue);
      expect(prefs.get("productHash"), equals("0x00001"));
    });
    test("tryUpdateDatabaseHash_fail_to_fetch", () async {});
  });

  group("test syncDB", () {
    test("test_syncDB_first_time_sync", () async {});
    test("test_syncDB_sync", () async {});
    test("", () async {});
    test("", () async {});

  });

}
