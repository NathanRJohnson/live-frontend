import 'dart:convert';

import 'package:http/http.dart';
import 'package:project_l/wtfridge/storage/storage.dart';

class Handler {

  final Uri url = Uri.http("3.96.14.111", "/user/");
  static const String SESSION_KEY = "session";
  static const String REFRESH_KEY = "refresh";

  Client client;
  Storage storage;

  Handler({required this.client, required this.storage});

  Future<Response> makeRequest(Function f, Uri uri, Map<Symbol, dynamic> fargs) async {
    // make http function call
    Response response = await Function.apply(f, [uri], fargs);
    if (response.statusCode == 401) {
      try {
        await refresh();
      } on ClientException catch (e) {
        throw ClientException("Session token out of date, but failed to refresh: $e");
      }
      // update the session argument
      fargs[#headers]["Authorization"] = "Bearer ${await storage.read(key: SESSION_KEY)}";
      // retry the request
      response = await Function.apply(f, [uri], fargs);
    }

    if (response.statusCode != 200) {
      throw ClientException("Failed to make request: [${response.statusCode}]: ${response.body}");
    }
    return response;
  }

  Future<void> login(String username) async {
    var body = "{\"username\": \"$username\"}";
    print(body);
    var response = await client.post(url, body:body);
    print(response.body);
    if (response.statusCode != 200) {
      throw ClientException("Failed to create user.");
    } else {
      Map<String, dynamic> tokens = json.decode(response.body);
      try {
        // store keys to encrypted storage
        await storage.write(key: "session", value: tokens["session"]);
        await storage.write(key: "refresh", value: tokens["refresh"]);
      } on Exception catch (e) {
        throw Exception("Failed to store tokens: $e");
      }
    }
  }

  Future<void> refresh() async {
    String? sessionToken = await storage.read(key: SESSION_KEY);
    String? refreshToken = await storage.read(key: REFRESH_KEY);
    if (sessionToken == null || refreshToken == null) {
      throw Exception("No tokens available to refresh.");
    }
    var response = await client.get(url.resolve("/refresh"), headers: {
      "Authorization": "Bearer $sessionToken",
      "Refresh": refreshToken
    });

    if (response.statusCode == 401) {
      throw ClientException("Refresh token expired.");
    }

    if (response.statusCode != 200) {
      throw ClientException("Unable to refresh user session.");
    }

    // session is still valid. No need for a new session key.
    if (response.body.isEmpty) {
      return;
    }

    Map<String, dynamic> jsonToken = jsonDecode(response.body);
    if (!jsonToken.containsKey(SESSION_KEY)) {
      throw ClientException("Response missing session key");
    }

    String newToken = jsonToken[SESSION_KEY];

    await storage.write(key: SESSION_KEY, value: newToken);
  }
}