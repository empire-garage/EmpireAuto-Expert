import 'package:empire_expert/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common/colors.dart';
import 'car_wishlist.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const CarWishList(),
    const Profile(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();
  int currentTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 80.h,
          child: SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //left tab bar icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: MaterialButton(
                        minWidth: 60.w,
                        height: 60.h,
                        onPressed: () {
                          setState(() {
                            currentScreen = const HomePage();
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.listCheck,
                              size: 24,
                              color: currentTab == 1
                                  ? AppColors.buttonColor
                                  : AppColors.grey400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      height: 60.h,
                      width: 60.w,
                    ),
                    SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: MaterialButton(
                        minWidth: 15.w,
                        onPressed: () {
                          setState(() {
                            currentScreen = const CarWishList();
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.screwdriverWrench,
                              size: 24,
                              color: currentTab == 2
                                  ? AppColors.buttonColor
                                  : AppColors.grey400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      height: 60.h,
                      width: 60.w,
                    ),
                    SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: MaterialButton(
                        minWidth: 60.w,
                        onPressed: () {
                          setState(() {
                            currentScreen = const Profile();
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.userGear,
                              size: 24,
                              color: currentTab == 3
                                  ? AppColors.buttonColor
                                  : AppColors.grey400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
