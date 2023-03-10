class QrCodeResponseModel {
  QrCodeResponseModel(
      {required this.bookingId, this.qrCode, this.isGenerating});

  int bookingId;
  String? qrCode;
  bool? isGenerating;

  factory QrCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return QrCodeResponseModel(
        bookingId: json['bookingId'],
        qrCode: json['qrCode'],
        isGenerating: json['isGenerating']);
  }
}
