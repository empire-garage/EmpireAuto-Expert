class NotificationModel {
  NotificationModel({
    this.deviceId,
    required this.isAndroiodDevice,
    required this.title,
    required this.body,
  });

  String? deviceId;
  bool isAndroiodDevice;
  String title;
  String body;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      deviceId: json['deviceId'],
      isAndroiodDevice: json['isAndroiodDevice'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'isAndroiodDevice': isAndroiodDevice,
        'title': title,
        'body': body,
      };
}
