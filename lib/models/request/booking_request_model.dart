class BookingRequestModel {
  BookingRequestModel({
    required this.date,
    required this.carId,
    required this.userId,
    required this.intendedTime,
    required this.intendedMinutes,
    required this.symptoms,
  });

  String date;
  int carId;
  int userId;
  String intendedTime;
  int intendedMinutes;
  List<SymptomModel> symptoms;

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> symptomJsonList = json['symptoms'];
    List<SymptomModel> symptoms =
        symptomJsonList.map((e) => SymptomModel.fromJson(e)).toList();
    return BookingRequestModel(
      date: json['date'],
      carId: json['carId'],
      userId: json['userId'],
      intendedTime: json['intendedTime'],
      intendedMinutes: json['intendedMinutes'],
      symptoms: symptoms,
    );
  }

  Map<String, dynamic> toJson() {
    List symptomJsonList = symptoms.map((e) => e.toJson()).toList();
    return {
      'date': date,
      'carId': carId,
      'userId': userId,
      'intendedTime': intendedTime,
      'intendedMinutes': intendedMinutes,
      'symptoms': symptomJsonList
    };
  }
}

class SymptomModel {
  SymptomModel({
    required this.id,
  });

  int id;

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    return SymptomModel(
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
