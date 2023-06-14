class WorkloadRm {
  int totalPoints;
  DateTime intendedFinishTime;
  int minutesPerWorkload;
  DateTime? startTime;

  WorkloadRm({
    required this.totalPoints,
    required this.intendedFinishTime,
    required this.minutesPerWorkload,
    this.startTime,
  });

  factory WorkloadRm.fromJson(Map<String, dynamic> json) {
    return WorkloadRm(
        totalPoints: json['totalPoints'],
        intendedFinishTime: DateTime.parse(json['intendedFinishTime']),
        minutesPerWorkload: json['minutesPerWorkload'] as int,
        startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null
        );
  }
}
