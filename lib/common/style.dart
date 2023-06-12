import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppStyles {
  static String fontFamily = 'Roboto';

  static TextStyle text400(
      {double fontsize = 22,
      Color color = Colors.black,
      fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: fontsize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      color: color,
    );
  }

  static TextStyle header600(
      {double fontsize = 22, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontsize,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
      color: color,
    );
  }

  static InputDecoration textbox12(
      {String hintText = "Nhập", hintTextColor = const Color.fromARGB(255, 158, 168, 158), Icon? suffixIcon}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle:
            AppStyles.text400(fontsize: 12.sp, color: hintTextColor),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppColors.blue600, width: 2)),
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        suffixIcon: suffixIcon);
  }

  static ButtonStyle button16({Color backgroundColor = AppColors.buttonColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      fixedSize: Size.fromHeight(55.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
