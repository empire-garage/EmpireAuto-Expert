import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/common/api_part.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  NotificationService();

  Future<String?> getToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print(token);
    }
    return token;
  }

  Future<void> saveToken(String? uuid) async {
    var token = await getToken();
    var url =
        '${APIPath.path}/notifications/fcmtoken/add?userId=$uuid&fcmToken=$token';
    var response = await makeHttpRequest(url, method: 'POST');
    if (response.statusCode == 200) {
      log('Save fcmToken success ${response.statusCode}');
    } else {
      log('Save fcmToken fail ${response.statusCode}',
          error: response.reasonPhrase);
    }
  }

  Future<http.Response?> sendNotification(
      NotificationModel notificationModel) async {
    var deviceId = await getToken();
    log(deviceId.toString());
    if (deviceId == null) {
      return http.Response('Bad request', 400);
    }
    notificationModel.deviceId = deviceId;
    http.Response? response;
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      response = await makeHttpRequest(
        headers: headers,
        '${APIPath.path}/notifications/send',
        method: 'POST',
        body: jsonEncode(notificationModel.toJson()),
      );
      log(
        jsonEncode(notificationModel.toJson()),
      );
      if (response.statusCode == 200) {
        log('Notification sent successfully!');
      } else {
        log('Error sending notification: ${response.reasonPhrase}');
      }
    } catch (e) {
      log(e.toString());
    }
    return response;
  }
}
