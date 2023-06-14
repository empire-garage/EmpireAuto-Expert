import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/common/api_part.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/response/workload.dart';

class WorkloadService {
  Future<WorkloadRm?> getWorkload(int orderServiceId) async {
    try {
      var expertId = await getUserId();
      var apiUrl = "${APIPath.path}/workloads/by-order-service?expertId=$expertId&orderServiceId=$orderServiceId";
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        return WorkloadRm.fromJson(jsonDecode(response.body));
      } else {
        log(response.body);
        return null;
      }
    } catch(e) {
      log(e.toString());
    }
    return null;
  }
}