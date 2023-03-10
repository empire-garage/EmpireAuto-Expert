class SendDiagnosingModel {
  HealthCarRecord healthCarRecord;
  List<OrderServiceDetails> orderServiceDetails;

  SendDiagnosingModel({
    required this.healthCarRecord,
    required this.orderServiceDetails,
  });
  factory SendDiagnosingModel.fromJson(Map<String, dynamic> json) {
    final orderServiceDetails = (json['orderServiceDetails'] as List<dynamic>)
        .map((e) => OrderServiceDetails.fromJson(e))
        .toList();
    final healthCarRecord = json['healthCarRecord'];

    return SendDiagnosingModel(
      healthCarRecord: healthCarRecord,
      orderServiceDetails: orderServiceDetails,
    );
  }

  Map<String, dynamic> toJson() {
    final orderServiceDetailsJson =
        orderServiceDetails.map((e) => e.toJson()).toList();
    return {
      'healthCarRecord': healthCarRecord,
      'orderServiceDetails': orderServiceDetailsJson,
    };
  }
}

class HealthCarRecord {
  String symptom;

  HealthCarRecord({
    required this.symptom,
  });

  factory HealthCarRecord.fromJson(Map<String, dynamic> json) {
    return HealthCarRecord(
      symptom: json['healthCarRecord']['symptom'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'healthCarRecord': {'symptom': symptom},
    };
  }
}

class OrderServiceDetails {
  final double price;
  final int itemId;

  OrderServiceDetails({
    required this.price,
    required this.itemId,
  });

  factory OrderServiceDetails.fromJson(Map<String, dynamic> json) {
    return OrderServiceDetails(
      price: json['price'] as double,
      itemId: json['itemId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'price': price, 'itemId': itemId};
  }
}
