class ProblemModel {
  int id;
  String name;
  Symptom? symptom;

  ProblemModel({required this.id, required this.name, this.symptom});

  factory ProblemModel.fromJson(Map<String, dynamic> json) {
    return ProblemModel(
      id: json['id'],
      name: json['name'],
      symptom: Symptom.fromJson(json['symptom'])
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Symptom {
  int id;
  String? name;
  Symptom({
    required this.id,
    this.name
  });
  
  factory Symptom.fromJson(Map<String,dynamic> json) {
    return Symptom(id: json['id'], name: json['name']);
  }
}
