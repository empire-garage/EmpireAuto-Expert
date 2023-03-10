class BookingResponseModel {
  BookingResponseModel({
    required this.id,
    this.code,
    required this.date,
    this.arrivedDateTime,
    required this.isArrived,
    required this.isActived,
    this.daysLeft,
    required this.user,
    required this.car,
  });

  int id;
  String? code;
  String date;
  String? arrivedDateTime;
  bool isArrived;
  bool isActived;
  int? daysLeft;
  UserSlimResponse user;
  CarResponseModel car;

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      id: json['id'],
      code: json['code'],
      date: json['date'],
      arrivedDateTime: json['arrivedDateTime'],
      isArrived: json['isArrived'],
      isActived: json['isActived'],
      daysLeft: json['daysLeft'],
      user: UserSlimResponse.fromJson(json['user']),
      car: CarResponseModel.fromJson(json['car']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'date': date,
        'isArrived': isArrived,
        'isActived': isActived,
        'daysLeft': daysLeft,
        'user': user,
        'car': car,
      };
}

class UserSlimResponse {
  UserSlimResponse({
    required this.fullname,
    required this.phone,
    this.email,
    this.gender,
  });

  String fullname;
  String phone;
  String? email;
  bool? gender;

  factory UserSlimResponse.fromJson(Map<String, dynamic> json) {
    return UserSlimResponse(
      fullname: json['fullname'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}

class CarResponseModel {
  CarResponseModel({
    required this.id,
    required this.carLisenceNo,
    required this.carBrand,
    required this.carModel,
  });

  int id;
  String carLisenceNo;
  String carBrand;
  String carModel;

  factory CarResponseModel.fromJson(Map<String, dynamic> json) {
    return CarResponseModel(
      id: json['id'],
      carLisenceNo: json['carLisenceNo'],
      carBrand: json['carBrand'],
      carModel: json['carModel'],
    );
  }
}
