class ActivityResponseModel {
  ActivityResponseModel({
    required this.id,
    this.code,
    this.date,
    this.daysLeft,
    this.car,
    this.isArrived,
    this.isActive,
    this.status,
    this.transaction,
    required this.isBooking,
    this.isOnGoing,
  });

  final int id;
  final String? code;
  final DateTime? date;
  final int? daysLeft;
  final CarResponseModel? car;
  final bool? isArrived;
  final bool? isActive;
  final int? status;
  final TransactionSlimResponse? transaction;
  final bool isBooking;
  final bool? isOnGoing;

  factory ActivityResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivityResponseModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      daysLeft: json['daysLeft'] as int?,
      car: json['car'] == null
          ? null
          : CarResponseModel.fromJson(json['car'] as Map<String, dynamic>),
      isArrived: json['isArrived'] as bool?,
      isActive: json['isActive'] as bool?,
      status: json['status'] as int?,
      transaction: json['transaction'] == null
          ? null
          : TransactionSlimResponse.fromJson(
              json['transaction'] as Map<String, dynamic>),
      isBooking: json['isBooking'] as bool,
      isOnGoing: json['isOnGoing'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['date'] = date?.toIso8601String();
    data['daysLeft'] = daysLeft;
    data['car'] = car?.toJson();
    data['isArrived'] = isArrived;
    data['isActive'] = isActive;
    data['status'] = status;
    data['transaction'] = transaction?.toJson();
    data['isBooking'] = isBooking;
    data['isOnGoing'] = isOnGoing;
    return data;
  }
}

enum PaymentMethod {
  creditCard,
  debitCard,
  cash,
  paypal,
}

extension PaymentMethodExtension on PaymentMethod {
  String toJsonString() {
    return toString().split('.').last;
  }

  static PaymentMethod fromJson(int index) {
    return PaymentMethod.values.firstWhere(
      (element) => element.index == index,
      orElse: () => PaymentMethod.creditCard,
    );
  }
}

class TransactionSlimResponse {
  TransactionSlimResponse({
    this.total,
    this.paymentMethod,
  });

  final int? total;
  final PaymentMethod? paymentMethod;

  factory TransactionSlimResponse.fromJson(Map<String, dynamic> json) {
    return TransactionSlimResponse(
      total: json['total'],
      paymentMethod: json['paymentMethod'] == null
          ? null
          : PaymentMethodExtension.fromJson(json['paymentMethod'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['paymentMethod'] = paymentMethod?.index;
    return data;
  }
}

class CarResponseModel {
  CarResponseModel({
    this.id,
    this.carLisenceNo,
    this.carBrand,
    this.carModel,
  });

  final int? id;
  final String? carLisenceNo;
  final String? carBrand;
  final String? carModel;

  factory CarResponseModel.fromJson(Map<String, dynamic> json) {
    return CarResponseModel(
      id: json['id'] as int?,
      carLisenceNo: json['carLisenceNo'] as String?,
      carBrand: json['carBrand'] as String?,
      carModel: json['carModel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['carLisenceNo'] = carLisenceNo;
    data['carBrand'] = carBrand;
    data['carModel'] = carModel;
    return data;
  }
}
