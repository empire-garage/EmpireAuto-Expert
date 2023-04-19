import 'package:flutter/material.dart';

class OrderServicesResponseModel {
  int id;
  int status;
  String? code;
  String? receivingStatus;
  Car car;
  HealthCarRecord? healthCarRecord;
  Order order;
  List<OrderServiceDetails>? orderServiceDetails;
  List<ConsiderProblem> considerProblems = [];

  OrderServicesResponseModel({
    required this.id,
    required this.status,
    required this.car,
    this.healthCarRecord,
    this.code,
    this.receivingStatus,
    required this.order,
    this.orderServiceDetails,
    required this.considerProblems,
  });

  factory OrderServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderServicesResponseModel(
        id: json['id'],
        status: json['status'],
        code: json['code'],
        receivingStatus: json['receivingStatus'],
        car: Car.fromJson(json['car']),
        healthCarRecord: json['healthCarRecord'] != null
            ? HealthCarRecord.fromJson(json['healthCarRecord'])
            : null,
        order: Order.fromJson(json['order']),
        orderServiceDetails: json['orderServiceDetails'] != null
            ? List<OrderServiceDetails>.from(json['orderServiceDetails']
                .map((x) => OrderServiceDetails.fromJson(x)))
            : null,
        considerProblems: json['considerProblems'] != null
            ? List<ConsiderProblem>.from(json['considerProblems']
                .map((x) => ConsiderProblem.fromJson(x)))
            : []);
  }
}

class ConsiderProblem {
  int id;
  String name;

  ConsiderProblem({required this.id, required this.name});

  factory ConsiderProblem.fromJson(Map<String, dynamic> json) {
    return ConsiderProblem(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class OrderServiceOfExpertModel {
  int id;
  int? status;
  String? code;
  Car car;
  Order order;

  OrderServiceOfExpertModel({
    required this.id,
    this.status,
    this.code,
    required this.car,
    required this.order,
  });

  factory OrderServiceOfExpertModel.fromJson(Map<String, dynamic> json) {
    return OrderServiceOfExpertModel(
      id: json['id'],
      status: json['status'],
      code: json['code'],
      car: Car.fromJson(json['car']),
      order: Order.fromJson(json['order']),
    );
  }
}

class Car {
  int id;
  String carLisenceNo;
  String carBrand;
  String carModel;

  Car({
    required this.id,
    required this.carLisenceNo,
    required this.carBrand,
    required this.carModel,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      carLisenceNo: json['carLisenceNo'],
      carBrand: json['carBrand'],
      carModel: json['carModel'],
    );
  }
}

class HealthCarRecord {
  int id;
  String? symptom;

  HealthCarRecord({
    required this.id,
    this.symptom,
  });

  factory HealthCarRecord.fromJson(Map<String, dynamic> json) {
    return HealthCarRecord(
      id: json['id'],
      symptom: json['symptom'],
    );
  }
}

class Order {
  int id;
  String createdAt;
  String updatedAt;
  User user;
  Transaction? transaction;

  Order({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.transaction,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
    );
  }
}

class User {
  String fullname;
  String phone;
  String? email;
  bool? gender;

  User({
    required this.fullname,
    required this.phone,
    this.email,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}

class Transaction {
  int total;
  // int paymentMethod;

  Transaction({
    required this.total,
    // required this.paymentMethod,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      total: json['total'],
      // paymentMethod: json['paymentMethod'],
    );
  }
}

class OrderServiceDetails {
  int? id;
  int? price;
  bool? isConfirmed;
  bool? done;
  String? note;
  bool showNote = true;
  TextEditingController controller = TextEditingController();
  Item? item;

  OrderServiceDetails(
      {this.id, this.price, this.isConfirmed, this.item, this.done, this.note});

  OrderServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    isConfirmed = json['isConfirmed'];
    done = json['done'];
    note = json['note'];
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
    showNote = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['isConfirmed'] = isConfirmed;
    data['done'] = done;
    data['note'] = note;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? photo;
  Category? category;
  Problem? problem;

  Item(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.photo,
      this.category});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    description = json['description'];
    photo = json['photo'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    problem =
        json['problem'] != null ? Problem.fromJson(json['problem']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['description'] = description;
    data['photo'] = photo;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Problem {
  int? id;
  String? name;

  Problem({
    this.id,
    this.name,
  });

  Problem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
