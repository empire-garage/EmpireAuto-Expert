class UpdateUserRequestModel {
  int id;
  String? fullname;
  String? email;
  String? address;
  bool gender;
  String? img;

  UpdateUserRequestModel({
    required this.id,
    this.fullname,
    this.email,
    this.address,
    required this.gender,
    this.img,
  });

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequestModel(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      gender: json['gender'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullname': fullname,
    'email': email,
    'address': address,
    'gender': gender,
    'img': img,
  };
}
