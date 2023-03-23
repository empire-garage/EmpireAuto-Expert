import 'dart:convert';

import 'package:empire_expert/common/api_part.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/response/problem.dart';
import 'package:empire_expert/models/response/orderservices.dart';

class DiagnoseService {
  Future<List<ProblemModel>> getListProblem(Car car) async {
    final url =
        '${APIPath.path}/problems?model=${car.carModel}&brand=${car.carBrand}';
    final response = await makeHttpRequest(url);
    if (response.statusCode == 200) {
      final jsonArray = json.decode(response.body);
      List<ProblemModel> list = [];
      for (var jsonObject in jsonArray) {
        list.add(ProblemModel.fromJson(jsonObject));
      }
      return list;
    } else {
      throw Exception('Failed to fetch problem list');
    }
  }
}
