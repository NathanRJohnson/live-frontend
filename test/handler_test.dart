import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project_l/wtfridge/storage/mock_storage.dart';

import '../lib/wtfridge/handler/handler.dart';
import 'fridge_handler_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late Uri url;
  late String responseBody;
  late MockStorage store;

  setUp(() {
    url = Uri.http("3.96.14.111", "/user/");
    store = MockStorage();
  });

  group('user login', () {
    responseBody = '{"refresh": "12345", "session": "ABCDE"}';

    test('sets tokens in secure storage on successful login', () async {
      final client = MockClient();
      final handler = Handler(client: client, storage: store);

      // TODO: add headers
      when(client
          .post(url, body: "{\"username\": \"test_user\"}"))
          .thenAnswer((_) async =>
          Response(responseBody, 200));

      await handler.login("test_user");

      expect(await store.read(key: "session"), "ABCDE");
      expect(await store.read(key: "refresh"), "12345");
    });
  });

  group('user /refresh', () {
    test('nomial - updates session token to new value', () async {
      final client = MockClient();
      final handler = Handler(client: client, storage: store);
      responseBody = '{"session": "ABCDE"}';

      when(client
          .get(url.resolve("/refresh"),
            headers: {
              "Authorization": "Bearer 12345",
              "Refresh": "AAAAA"
            }))
          .thenAnswer((_) async =>
          Response(responseBody, 200));

      await store.write(key: "session", value: "12345");
      await store.write(key: "refresh", value: "AAAAA");

      await handler.refresh();
      expect(await store.read(key: "session"), "ABCDE");
    });

    test("Empty body - session token still valid", () async {
      final client = MockClient();
      final handler = Handler(client: client, storage: store);
      responseBody = '';

      when(client
          .get(url.resolve("/refresh"),
          headers: {
            "Authorization": "Bearer 12345",
            "Refresh": "AAAAA"
          }))
          .thenAnswer((_) async =>
          Response(responseBody, 200));

      await store.write(key: "session", value: "12345");
      await store.write(key: "refresh", value: "AAAAA");

      await handler.refresh();
      expect(await store.read(key: "session"), "12345");
    });

    test("Expired refresh key", () async {
      final client = MockClient();
      final handler = Handler(client: client, storage: store);
      responseBody = 'Access Denied Message';

      when(client
          .get(url.resolve("/refresh"),
          headers: {
            "Authorization": "Bearer 12345",
            "Refresh": "AAAAA"
          }))
          .thenAnswer((_) async =>
          Response(responseBody, 401));

      await store.write(key: "session", value: "12345");
      await store.write(key: "refresh", value: "AAAAA");

      expect(handler.refresh(), throwsA(const TypeMatcher<ClientException>()));
    });
  });

  group("make request wrapper", () {
    test("nominal - session token is valid", () async {
      final expectedResponse = Response('Some message', 200);
      final client = MockClient();
      final handler = Handler(client: client, storage: store);

      final requestMethod = client.get;
      Map<Symbol, dynamic> args = {
        #headers: {"Authorization": "Bearer 12345", "Refresh": "AAAAA"}
      };

      when(client
          .get(url,
          headers: args[#headers]))
          .thenAnswer((_) async => expectedResponse);

      var actualResponse = await handler.makeRequest(requestMethod, url, args);
      expect(actualResponse, expectedResponse);

    });

    test("invalid session / valid refresh - refresh required", () async {
      final unauthorizedResponse = Response('Unauthorized', 401);
      final refreshResponse = Response('{"session": "valid"}', 200);
      final successResponse = Response('Success!', 200);

      final client = MockClient();
      final handler = Handler(client: client, storage: store);

      final requestMethod = client.get;
      Map<Symbol, dynamic> expiredArgs = {
        #headers: {"Authorization": "Bearer expired"}
      };
      Map<Symbol, dynamic> refreshArgs = {
        #headers: {"Authorization": "Bearer expired", "Refresh": "AAAAA"}
      };
      Map<Symbol, dynamic> validArgs = {
        #headers: {"Authorization": "Bearer valid"}
      };

      await store.write(key: "session", value: "expired");
      await store.write(key: "refresh", value: "AAAAA");

      when(client
          .get(url,
          headers: expiredArgs[#headers]))
          .thenAnswer((_) async => unauthorizedResponse);

      when(client
          .get(url.resolve("/refresh"),
          headers: refreshArgs[#headers]))
          .thenAnswer((_) async => refreshResponse);

      when(client
          .get(url,
          headers: validArgs[#headers]))
          .thenAnswer((_) async => successResponse);

      var actualResponse = await handler.makeRequest(requestMethod, url, expiredArgs);
      expect(actualResponse, successResponse);

    });

    test("invalid session / invalid refresh - login required", () async {
      final unauthorizedResponse = Response('Unauthorized', 401);

      final client = MockClient();
      final handler = Handler(client: client, storage: store);

      final requestMethod = client.get;
      Map<Symbol, dynamic> expiredArgs = {
        #headers: {"Authorization": "Bearer expired"}
      };
      Map<Symbol, dynamic> refreshArgs = {
        #headers: {"Authorization": "Bearer expired", "Refresh": "alsoexpired"}
      };

      await store.write(key: "session", value: "expired");
      await store.write(key: "refresh", value: "alsoexpired");

      when(client
          .get(url,
          headers: expiredArgs[#headers]))
          .thenAnswer((_) async => unauthorizedResponse);

      when(client
          .get(url.resolve("/refresh"),
          headers: refreshArgs[#headers]))
          .thenAnswer((_) async => unauthorizedResponse);

      expect(handler.makeRequest(requestMethod, url, expiredArgs), throwsA(const TypeMatcher<ClientException>()));

    });

  });

}