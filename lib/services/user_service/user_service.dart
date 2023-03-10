import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/request/update_user_request_model.dart';
import 'package:empire_expert/models/response/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages

import '../../common/api_part.dart';

class UserService {
  Future<UserResponseModel?> getUserById(userId) async {
    String apiUrl = '${APIPath.path}/users/$userId';
    final response = await makeHttpRequest('$apiUrl?id=$userId');
    if (response.statusCode == 200) {
      var user = UserResponseModel.fromJson(jsonDecode(response.body));
      return user;
    } else {
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return null;
    }
  }

  Future<http.Response?> updateUser(UpdateUserRequestModel model) async {
    http.Response? response;
    try {
      response = await makeHttpRequest(
        '${APIPath.path}/users',
        method: 'PATCH',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(model.toJson()),
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }
}
