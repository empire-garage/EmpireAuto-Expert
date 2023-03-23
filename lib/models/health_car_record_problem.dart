List<Map<String, dynamic>> healthCarRecordProblemsToJson(
    List<HealthCarRecordProblem> models) {
  List<Map<String, dynamic>> jsonList = [];
  for (var model in models) {
    jsonList.add(model.toJson());
  }
  return jsonList;
}

class HealthCarRecordProblem {
  int problemId;
  List<HealthCarRecordProblemCatalogue> healthCarRecordProblemCatalogues;

  HealthCarRecordProblem(
      {required this.problemId,
      required this.healthCarRecordProblemCatalogues});

  factory HealthCarRecordProblem.fromJson(Map<String, dynamic> json) {
    var list = json['healthCarRecordProblemCatalogues'] as List;
    List<HealthCarRecordProblemCatalogue> healthCarRecordProblemCataloguesList =
        list.map((i) => HealthCarRecordProblemCatalogue.fromJson(i)).toList();

    return HealthCarRecordProblem(
        problemId: json['problemId'],
        healthCarRecordProblemCatalogues: healthCarRecordProblemCataloguesList);
  }

  Map<String, dynamic> toJson() => {
        'problemId': problemId,
        'healthCarRecordProblemCatalogues':
            healthCarRecordProblemCatalogues.map((i) => i.toJson()).toList(),
      };
}

class HealthCarRecordProblemCatalogue {
  String name;
  List<HealthCarRecordProblemCatalogueItem>
      healthCarRecordProblemCatalogueItems;

  HealthCarRecordProblemCatalogue(
      {required this.name, required this.healthCarRecordProblemCatalogueItems});

  factory HealthCarRecordProblemCatalogue.fromJson(Map<String, dynamic> json) {
    var list = json['healthCarRecordProblemCatalogueItems'] as List;
    List<HealthCarRecordProblemCatalogueItem>
        healthCarRecordProblemCatalogueItemsList = list
            .map((i) => HealthCarRecordProblemCatalogueItem.fromJson(i))
            .toList();

    return HealthCarRecordProblemCatalogue(
        name: json['name'],
        healthCarRecordProblemCatalogueItems:
            healthCarRecordProblemCatalogueItemsList);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'healthCarRecordProblemCatalogueItems':
            healthCarRecordProblemCatalogueItems
                .map((i) => i.toJson())
                .toList(),
      };
}

class HealthCarRecordProblemCatalogueItem {
  int itemId;

  HealthCarRecordProblemCatalogueItem({required this.itemId});

  factory HealthCarRecordProblemCatalogueItem.fromJson(
      Map<String, dynamic> json) {
    return HealthCarRecordProblemCatalogueItem(itemId: json['itemId']);
  }

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
      };
}
