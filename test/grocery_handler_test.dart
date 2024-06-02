

import 'dart:convert';

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../lib/wtfridge/handler/grocery_handler.dart';
import '../lib/wtfridge/model/grocery_item.dart';
import 'fridge_handler_test.mocks.dart';

// dart run build_runner build
@GenerateMocks([Client])
void main() {
  late Uri url;
  late GroceryHandler handler;
  late String body;

  setUp(() {
    url = Uri.http("3.96.14.111", "/grocery/");
    handler = GroceryHandler();
  });

  group('get all items', () {
    body = '[{"item_id": 123, "item_name":"G", "is_active": false}]';
    test(' returns a GroceryItem if http call completes successfully', () async {
      final client = MockClient();

      when(client
          .get(url))
            .thenAnswer((_) async =>
                Response(body, 200));

      expect(await handler.getAllItems(client), isA<List<GroceryItem>>());
    });

    test('returns empty list if the http returns with empty body', () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
          .get(url))
          .thenAnswer((_) async =>
          Response('', 200));

      expect(await handler.getAllItems(client), <GroceryItem>[]);
    });

    test('raises error if the http call completes with an error', () async {
      final client = MockClient();

      when(client
          .get(url))
          .thenAnswer((_) async =>
          Response('Server Error', 500));

      expect(handler.getAllItems(client), throwsA(const TypeMatcher<ClientException>()));
    });
  });

  group('push to db', () {
    GroceryItem item = GroceryItem(id: 123, name: "G", isActive: false);

    test('successful item addition', () async {
      final client = MockClient();

      when(client
          .post(url, body: jsonEncode(item)))
          .thenAnswer((_) async =>
          Response('', 200));

      await expectLater(handler.pushToDB(client, item), completes);
    });

    test('failed item addition throws ClientException', () async {
      final client = MockClient();

      when(client
          .post(url, body: jsonEncode(item)))
          .thenAnswer((_) async =>
          Response('', 500));

      expect(handler.pushToDB(client, item), throwsA(const TypeMatcher<ClientException>()));
    });
  });

  group('delete from db', () {
    GroceryItem item = GroceryItem(id: 123, name: "G", isActive: false);

    test('successful item deletion', () async {
      final client = MockClient();

      when(client
          .delete(url.resolve(item.id!.toString())))
          .thenAnswer((_) async =>
          Response('', 200));

      expect(handler.deleteItemByID(client, item.id!), completes);
    });

    test('failed item deletion throws ClientException', () async {
      final client = MockClient();

      when(client
          .delete(url.resolve(item.id!.toString())))
          .thenAnswer((_) async =>
          Response('', 500));

      expect(handler.deleteItemByID(client, item.id!), throwsA(const TypeMatcher<ClientException>()));
    });
  });

  group('toggle item active state', () {
    GroceryItem item = GroceryItem(id: 123, name: "G", isActive: false);

    test('successful item deletion', () async {
      final client = MockClient();

      when(client
          .patch(url.resolve(item.id!.toString())))
          .thenAnswer((_) async =>
          Response('', 200));

      expect(handler.toggleActiveByID(client, item.id!), completes);
    });

    test('failed item deletion throws ClientException', () async {
      final client = MockClient();

      when(client
          .patch(url.resolve(item.id!.toString())))
          .thenAnswer((_) async =>
          Response('', 500));

      expect(handler.toggleActiveByID(client, item.id!), throwsA(const TypeMatcher<ClientException>()));
    });
  });

  group('toggle item active state', () {
    GroceryItem item = GroceryItem(id: 123, name: "G", isActive: false);

    test('successful item deletion', () async {
      final client = MockClient();

      when(client
          .patch(url.resolve(item.id!.toString())))
          .thenAnswer((_) async =>
          Response('', 200));

      expect(handler.toggleActiveByID(client, item.id!), completes);
    });

    test('failed item deletion throws ClientException', () async {
      final client = MockClient();

      when(client
          .patch(url.resolve(item.id!.toString())))
          .thenAnswer((_) async =>
          Response('', 500));

      expect(handler.toggleActiveByID(client, item.id!), throwsA(const TypeMatcher<ClientException>()));
    });
  });

  group('send active to fridge', () {

    test('successful item transfer', () async {
      final client = MockClient();

      when(client
          .post(url.resolve("to_fridge")))
          .thenAnswer((_) async =>
          Response('', 200));

      expect(handler.sendActiveToFridge(client), completes);
    });

    test('successful item transfer', () async {
      final client = MockClient();

      when(client
          .post(url.resolve("to_fridge")))
          .thenAnswer((_) async =>
          Response('', 500));

      expect(handler.sendActiveToFridge(client), throwsA(const TypeMatcher<ClientException>()));
    });

  });
}