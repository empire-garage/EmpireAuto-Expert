class LoginResponseModel {
  LoginResponseModel(
      {required this.id,
      required this.accessToken,
      required this.role,
      required this.phone,
      this.email,
      required this.name,
      this.gender,
      this.image,
      this.address,
      this.birthday});

  String accessToken;
  int id;
  String role;
  String? phone;
  String? email;
  String name;
  bool? gender;
  String? image;
  String? birthday;
  String? address;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      id: json['id'],
      role: json['role'],
      phone: json['phone'],
      email: json['email'],
      name: json['name'],
      gender: json['gender'],
      image: json['image'],
      birthday: json['birthday'],
      address: json['address'],
    );
  }
}
