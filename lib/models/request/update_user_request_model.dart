class UpdateUserRequestModel {
  int id;
  String fullname;
  String phone;
  String? email;
  String? address;
  String roleId;
  bool gender;
  String? img;

  UpdateUserRequestModel({
    required this.id,
    required this.fullname,
    required this.phone,
    this.email,
    this.address,
    required this.roleId,
    required this.gender,
    this.img,
  });

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequestModel(
      id: json['id'],
      fullname: json['fullname'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      roleId: json['roleId'],
      gender: json['gender'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'phone': phone,
        'email': email,
        'address': address,
        'roleId': roleId,
        'gender': gender,
        'img': img,
      };
}
