import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/response/booking.dart';
import 'package:http/http.dart' as http;

import '../../common/api_part.dart';

class CarService {
  Future<http.Response?> addNewCar(
      String carLisenceNo, String carBrand, String carModel) async {
    var userId = await getUserId();
    String apiUrl = '${APIPath.path}/cars';
    final response = await makeHttpRequest(apiUrl,
        method: 'POST',
        body: jsonEncode({
          'userId': userId,
          'carLisenceNo': carLisenceNo,
          'carBrand': carBrand,
          'carModel': carModel
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      log('Car data sent successfully');
    } else {
      log('Error sending car data: ${response.statusCode}');
    }
    return response;
  }

  Future<List<CarResponseModel>?> fetchUserCars(int userId) async {
    String apiUrl = '${APIPath.path}/users/$userId/cars';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      var jsonArray = json.decode(response.body);
      List<CarResponseModel> list = [];
      for (var jsonObject in jsonArray['cars']) {
        list.add(CarResponseModel.fromJson(jsonObject));
      }
      return list;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load item, status code: ${response.statusCode}");
      return null;
    }
  }
}
