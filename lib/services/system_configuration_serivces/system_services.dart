import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/common/api_part.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';

class SystemServices {
  Future<int?> getMaxWorkloadPerDay() async {
    String apiUrl = "${APIPath.path}/system-configurations/max-workload-per-day";
    try{
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        var object = jsonDecode(response.body);
        return object['value'];
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }
}