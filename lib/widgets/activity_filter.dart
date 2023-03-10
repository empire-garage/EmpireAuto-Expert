import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';

class ActivityFilterList extends StatelessWidget {
  const ActivityFilterList({Key? key}) : super(key: key);

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
        children: const <Widget>[
          FilterChip(data: 'Đặt lịch'),
          FilterChip(data: 'Dịch vụ'),
          FilterChip(data: 'Đặt hàng'),
          FilterChip(data: "Cứu hộ"),
        ],
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip({
    super.key,
    required this.data,
  });

  final String data;

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
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        shadowColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
        foregroundColor:
            getColor(AppColors.buttonColor, AppColors.whiteButtonColor),
        backgroundColor:
            getColor(AppColors.whiteButtonColor, AppColors.buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        )),
      ),
      child: Text(
        data,
        style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProDisplay'),
      ),
    );
  }
}
