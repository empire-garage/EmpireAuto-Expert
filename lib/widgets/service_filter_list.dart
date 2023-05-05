import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';

class ServiceFilterList extends StatelessWidget {
  const ServiceFilterList({Key? key}) : super(key: key);

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Column(children: [
            SizedBox(
              width: 120.w,
              height: 30.h,
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: getColor(
                          AppColors.buttonColor, AppColors.whiteButtonColor),
                      backgroundColor: getColor(
                          AppColors.whiteButtonColor, AppColors.buttonColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            width: 1.w, color: AppColors.buttonColor),
                      )),
                    ),
                    child: Text(
                      'Bảo dưỡng',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto'),
                    ),
                  )),
            ),
          ]),
          Column(children: [
            SizedBox(
              width: 120.w,
              height: 30.h,
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: getColor(
                          AppColors.buttonColor, AppColors.whiteButtonColor),
                      backgroundColor: getColor(
                          AppColors.whiteButtonColor, AppColors.buttonColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            width: 1.w, color: AppColors.buttonColor),
                      )),
                    ),
                    child: Text(
                      'Sửa chữa',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto'),
                    ),
                  )),
            ),
          ]),
          Column(children: [
            SizedBox(
              width: 120.w,
              height: 30.h,
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: getColor(
                          AppColors.buttonColor, AppColors.whiteButtonColor),
                      backgroundColor: getColor(
                          AppColors.whiteButtonColor, AppColors.buttonColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            width: 1.w, color: AppColors.buttonColor),
                      )),
                    ),
                    child: Text(
                      'Tân trang',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto'),
                    ),
                  )),
            ),
          ]),
          Column(children: [
            SizedBox(
              width: 120.w,
              height: 30.h,
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: getColor(
                          AppColors.buttonColor, AppColors.whiteButtonColor),
                      backgroundColor: getColor(
                          AppColors.whiteButtonColor, AppColors.buttonColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            width: 1.w, color: AppColors.buttonColor),
                      )),
                    ),
                    child: Text(
                      'Cứu hộ',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto'),
                    ),
                  )),
            ),
          ]),
        ],
      ),
    );
  }
}
