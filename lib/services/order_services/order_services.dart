import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/models/request/send_diagnosing_request_model.dart';

import '../../common/api_part.dart';
import '../../common/jwt_interceptor.dart';
import '../../models/response/orderservices.dart';
import 'package:http/http.dart' as http;

class OrderServices {
  Future<OrderServicesResponseModel?> getOrderServicesById(
      int servicesId) async {
    String apiUrl = "${APIPath.path}/order-services/$servicesId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        dynamic jsonObject = json.decode(response.body);
        OrderServicesResponseModel order =
            OrderServicesResponseModel.fromJson(jsonObject);
        return order;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<OrderServiceOfExpertModel>?> getOrderServiceOfExpert(
      int expertId) async {
    String apiUrl = "${APIPath.path}/order-services/expert/$expertId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        List<OrderServiceOfExpertModel> list = [];
        for (var jsonObject in jsonArray) {
          list.add(OrderServiceOfExpertModel.fromJson(jsonObject));
        }
        return list;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<OrderServiceOfExpertModel>?> getDoingOrderServiceOfExpert(
      int expertId) async {
    String apiUrl = "${APIPath.path}/order-services/expert/$expertId/status/3";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        List<OrderServiceOfExpertModel> list = [];
        for (var jsonObject in jsonArray) {
          list.add(OrderServiceOfExpertModel.fromJson(jsonObject));
        }
        return list;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<http.Response?> doneOrder(
      int orderServiceId, int orderServiceStatusId) async {
    http.Response? response;
    try {
      response = await makeHttpRequest(
        '${APIPath.path}/order-service-status-logs',
        method: 'POST',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'orderServiceId': orderServiceId,
          'orderServiceStatusId': orderServiceStatusId
        }),
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<int> diagnose(int id, SendDiagnosingModel model) async {
    String apiUrl = "${APIPath.path}/order-services/$id/diagnosed-result";
    var data = jsonEncode(model.toJson());
    try {
      var response = await makeHttpRequest(
        apiUrl,
        method: 'PUT',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data,
      );
      return response.statusCode;
    } catch (e) {
      log(e.toString());
    }
    return 500;
  }
}
