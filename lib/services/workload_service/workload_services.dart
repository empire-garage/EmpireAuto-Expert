import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/common/api_part.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/response/workload.dart';

class WorkloadService {
  Future<WorkloadRm?> getWorkload(int orderServiceId) async {
    try {
      var expertId = await getUserId();
      var apiUrl =
          "${APIPath.path}/workloads/by-order-service?expertId=$expertId&orderServiceId=$orderServiceId";
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        return WorkloadRm.fromJson(jsonDecode(response.body));
      } else {
        log(response.body);
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<bool> updateWorkloadStartTime(int orderServiceId) async {
    try {
      var expertId = await getUserId();
      var apiUrl =
          "${APIPath.path}/workloads/start-time?expertId=$expertId&orderServiceId=$orderServiceId";
      var response = await makeHttpRequest(
        apiUrl,
        method: 'PUT',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        log(response.body);
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<WorkloadRm?> getWorkloadByExpertId(var expertId) async {
    try {
      var expertId = await getUserId();
      var apiUrl = "${APIPath.path}/workloads";
      var response = await makeHttpRequest(apiUrl,body: jsonEncode(expertId));
      if (response.statusCode == 200) {
        return WorkloadRm.fromJson(jsonDecode(response.body));
      } else {
        log(response.body);
        return null;
      }
    } catch (e) {
      e.toString();
    }
    return null;
  }
}
