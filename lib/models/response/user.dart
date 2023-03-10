class UserResponseModel {
  UserResponseModel(
      {required this.id,
      required this.fullname,
      this.phone,
      this.email,
      required this.address,
      this.roleId,
      this.gender,
      this.img,
      this.cars});

  int id;
  String fullname;
  String? phone;
  String? email;
  String? address;
  String? roleId;
  bool? gender;
  String? img;
  List<CarResponseModel>? cars;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
        id: json['id'],
        fullname: json['fullname'],
        phone: json['phone'],
        email: json['email'],
        address: json['address'],
        roleId: json['roleId'],
        gender: json['gender'],
        img: json['img']);
  }
}

class CarResponseModel {
  CarResponseModel(
      {required this.id,
      required this.carLisenceNo,
      required this.carBrand,
      required this.carModel});

  int id;
  String carLisenceNo;
  String carBrand;
  String carModel;
}
