import 'dart:async';
import 'dart:convert';
import 'package:empire_expert/models/user_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserInfo(UserInfo user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user-id', user.userId);
  await prefs.setString('firebase-uuid', user.firebaseUUID);
}

Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user-id');
}

Future<String?> getFirebaseUUID() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('firebase-uuid');
}

// Define a function to save the JWT token in Shared Preferences
Future<void> saveJwtToken(String jwtToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', jwtToken);
}

// Define a function to retrieve the JWT token from Shared Preferences
Future<String?> getJwtToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

// Define a function to make an HTTP request with a common header that includes the JWT token
Future<http.Response> makeHttpRequest(
  String url, {
  String method = 'GET',
  Map<String, String>? headers,
  dynamic body,
  Encoding? encoding,
}) async {
  final jwtToken = await getJwtToken();
  final commonHeaders = {'Authorization': 'Bearer $jwtToken'};

  // Combine common headers with any additional headers passed in as an argument
  final requestHeaders =
      headers == null ? commonHeaders : {...commonHeaders, ...headers};

  switch (method) {
    case 'GET':
      return http.get(Uri.parse(url), headers: requestHeaders);
    case 'POST':
      return http.post(Uri.parse(url),
          headers: requestHeaders, body: body, encoding: encoding);
    case 'PUT':
      var response = http.put(Uri.parse(url),
          headers: requestHeaders, body: body, encoding: encoding);
      return response;
    case 'PATCH':
      var response = http.patch(Uri.parse(url),
          headers: requestHeaders, body: body, encoding: encoding);
      return response;
    case 'DELETE':
      return http.delete(Uri.parse(url), headers: requestHeaders);
    default:
      throw ArgumentError('Invalid HTTP method: $method');
  }
}

// Usage example
void main() async {
  // Make a GET request with a common header that includes the JWT token
  final response1 = await makeHttpRequest('https://example.com/api/data');
  if (kDebugMode) {
    print(response1.body);
  }

  // Make a POST request with a common header that includes the JWT token and additional headers
  final response2 = await makeHttpRequest(
    'https://example.com/api/data',
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'param1': 'value1', 'param2': 'value2'}),
  );
  if (kDebugMode) {
    print(response2.body);
  }
}
