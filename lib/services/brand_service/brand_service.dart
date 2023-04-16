import 'dart:convert';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:empire_expert/common/api_part.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandService {
  Future<String> getBrandsJson() async {
    String apiUrl = '${APIPath.path}/brands';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load brand, status code: ${response.statusCode}");
      return '{}';
    }
  }

  Future<String?> getPhoto(String brand) async {
    final prefs = await SharedPreferences.getInstance();
    var brands = prefs.getString('brands');
    if (brands == null) return null;
    var jsonArray = json.decode(brands);
    List<BrandSlimModel> list = [];
    for (var jsonObject in jsonArray) {
      list.add(BrandSlimModel.fromJson(jsonObject));
    }
    var photo = list.firstWhere((element) => element.name == brand).photo;
    return photo;
  }
}

class BrandSlimModel {
  BrandSlimModel({
    required this.id,
    required this.name,
    this.photo,
  });

  final int id;
  final String name;
  final String? photo;

  factory BrandSlimModel.fromJson(Map<String, dynamic> json) {
    return BrandSlimModel(
        id: json['id'] as int,
        name: json['name'] as String,
        photo: json['photo']);
  }
}
