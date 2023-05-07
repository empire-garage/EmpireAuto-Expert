import 'package:empire_expert/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';

class BottomPopup extends StatelessWidget {
  final String image;
  final String title;
  final String body;
  final Function()? action;
  final String buttonTitle;
  const BottomPopup(
      {Key? key,
      required this.image,
      required this.title,
      required this.body,
      this.action,
      required this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(24))),
      child: ClipRRect(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 140.h,
                  width: 140.h,
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 300.w,
                child: Center(
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: action,
                      style: AppStyles.button16(),
                      child: Text(
                        buttonTitle,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
