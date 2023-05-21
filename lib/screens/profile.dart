import 'package:empire_expert/models/response/user.dart';
import 'package:empire_expert/screens/welcome_screen.dart';
import 'package:empire_expert/services/authen_firebase_services/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/jwt_interceptor.dart';
import '../services/user_service/user_service.dart';
import 'main_page.dart';

class Profile extends StatefulWidget {
  final userId;
  const Profile({super.key, this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _loading = true;
  UserResponseModel? _user;

  @override
  void initState() {
    _getUserById();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUserById() async {
    var userId = await getUserId();
    _user = await UserService().getUserById(userId);
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (kDebugMode) {
      print(_user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: SizedBox(
            height: 40.h,
            width: 108.w,
            child: InkWell(
              onTap: () {
                Get.off(() => const MainPage());
              },
              child: Image.asset(
                "assets/image/app-logo/homepage-icon.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 160.w,
                  height: 160.h,
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: 160.w,
                        height: 160.h,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/image/user-pic/user.png"),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: Container(
                          width: 33.w,
                          height: 33.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.buttonColor,
                            shape: BoxShape.rectangle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: AppColors.whiteButtonColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _loading
                        ? Container()
                        : Text(
                            _user!.fullname,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: AppColors.blackTextColor),
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 76.h,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      //TODO
                    },
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 24),
                          child: Icon(
                            FontAwesomeIcons.user,
                            size: 24,
                          ),
                        ),
                        Text(
                          "Thông tin cá nhân",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                              color: AppColors.blackTextColor),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.navigate_next,
                          size: 20,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await AppAuthentication().logout();
                      Get.offAll(
                        () => const WelcomeScreen(),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 24),
                          child: Icon(
                            Icons.logout,
                            size: 24,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "Đăng xuất",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                              color: Colors.red),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.navigate_next,
                          size: 20,
                          color: Colors.red,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
