import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';

class ZaloBottomSheet extends StatelessWidget {
  const ZaloBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575), //background color
      child: Container(
        height: 330.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 7, // blur radius
              offset: const Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
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
                        "assets/image/icon-logo/zaloicon.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Truy cập Zalo",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: Text(
                        "Chuyển đến ứng dụng Zalo để được trao đổi",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "trực tiếp với Empire Garage",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightTextColor,
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
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              var openAppResult = await LaunchApp.openApp(
                                androidPackageName: 'com.zing.zalo',
                                iosUrlScheme: 'pulsesecure://',
                                appStoreLink:
                                    'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                              );
                              if (kDebugMode) {
                                print(
                                    'openAppResult => $openAppResult ${openAppResult.runtimeType}');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              fixedSize: Size.fromHeight(50.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36),
                              ),
                            ),
                            child: Text(
                              'Chuyển đến Zalo',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
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
        ),
      ),
    );
  }
}
