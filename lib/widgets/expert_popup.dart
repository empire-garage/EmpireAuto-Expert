import 'package:empire_expert/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';

class ExpertPopup extends StatelessWidget {
  final String? header;
  final String diagnose;
  final String diagnoseList;
  final String symptom;
  final String symptomList;
  final Function()? action;
  final String buttonTitle;
  const ExpertPopup(
      {Key? key,
        this.header,
        required this.diagnose,
        required this.diagnoseList,
        required this.symptom,
        required this.symptomList,
        this.action,
        required this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: ClipRRect(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
                visible: header != null,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.sp),
                      child: Text(
                        header ?? "",
                        style: AppStyles.header600(fontsize: 16.sp),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: SizedBox(
                width: 300.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        diagnose,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ]
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: SizedBox(
                width: 300.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diagnoseList,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: SizedBox(
                width: 300.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symptom,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: SizedBox(
                width: 300.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symptomList,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, top: 2.0),
              child: Row(
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
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
