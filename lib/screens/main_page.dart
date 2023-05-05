import 'package:empire_expert/common/style.dart';
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
          height: 65.sp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
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
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      "Chẩn đoán",
                      style: AppStyles.header600(
                        fontsize: 10,
                        color: currentTab == 1
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
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
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      "Sửa chữa",
                      style: AppStyles.header600(
                        fontsize: 10,
                        color: currentTab == 2
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
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
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      "Tài khoản",
                      style: AppStyles.header600(
                        fontsize: 10,
                        color: currentTab == 3
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
