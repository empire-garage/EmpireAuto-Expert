
class CarRequestModel{
  String? carLisenceNo;
  String? carBrand;
  String? carModel;

  CarRequestModel({this.carLisenceNo, this.carBrand, this.carModel});

  CarRequestModel.fromJson(Map<String, dynamic> json) {
    carLisenceNo = json['carLisenceNo'];
    carBrand = json['carBrand'];
    carModel = json['carModel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carLisenceNo'] = carLisenceNo;
    data['carBrand'] = carBrand;
    data['carModel'] = carModel;
    return data;
  }
}