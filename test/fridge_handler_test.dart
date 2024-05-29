
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../lib/wtfridge/handler/fridge_handler.dart';
import '../lib/wtfridge/model/fridge_item.dart';
import 'fridge_handler_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late Uri url;
  late FridgeHandler handler;
  late String body;

  setUp(() {
    url = Uri.http("3.96.14.111", "/fridge/");
    handler = FridgeHandler();
  });

  group('get all items', () {
    body = '[{"item_id": 123, "item_name": "F", "date_added": "${DateTime(2001).toString()}"}]';
    test('returns a FridgeItem if http call completes successfully', () async {
      final client = MockClient();

      when(client
          .get(url))
            .thenAnswer((_) async =>
                Response(body, 200));
      
      expect(await handler.getAllItems(client), isA<List<FridgeItem>>());
    });

    test('returns empty list if the http returns with empty body', () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
          .get(url))
            .thenAnswer((_) async =>
                Response('', 200));

      expect(await handler.getAllItems(client), <FridgeItem>[]);
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
    FridgeItem item = FridgeItem(id: 123, name: "F");

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
    FridgeItem item = FridgeItem(id: 123, name: "F");

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

  group('copy to groceries by id', () {
    FridgeItem item = FridgeItem(id: 123, name: "F");

    test('successful copy to groceries', () async {
      final client = MockClient();

      when(client
          .post(url.resolve("to_grocery/${item.id!}")))
            .thenAnswer((realInvocation) async =>
              Response('', 200));

      expect(handler.copyToGroceryByID(client, item.id!), completes);
    });

    test('failed copy to groceries throws ClientException', () async {
      final client = MockClient();

      when(client
          .post(url.resolve("to_grocery/${item.id!}")))
          .thenAnswer((realInvocation) async =>
          Response('', 500));

      expect(handler.copyToGroceryByID(client, item.id!), throwsA(const TypeMatcher<ClientException>()));
    });

  });
}