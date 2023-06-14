import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String dateTime, bool? includeTime) {
  var value = DateTime.parse(dateTime);
  NumberFormat formatter = NumberFormat("00");
  String formattedDate = "";
  if (includeTime == true) {
    formattedDate =
        "${formatter.format(value.hour)}:${formatter.format(value.minute)}, ${formatter.format(value.day)}/${formatter.format(value.month)}";
  } else {
    formattedDate =
        "${formatter.format(value.day)}/${formatter.format(value.month)}/${value.year}";
  }
  return formattedDate;
}

String formatCurrency(dynamic number) {
  return NumberFormat.currency(decimalDigits: 0, locale: 'vi_VN', symbol: 'đ')
      .format(number)
      .toString();
}

  void showErrorSnackbar(BuildContext context, String content) {
    final snackBar = SnackBar(
          content: Text(content),
        );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }