import 'dart:convert';
import 'dart:developer';

import 'package:empire_expert/models/request/update_user_request_model.dart';
import 'package:empire_expert/models/response/user.dart';
import 'package:empire_expert/screens/main_page.dart';
import 'package:empire_expert/screens/screen_loading.dart';
import 'package:empire_expert/services/user_service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';

class UpdateProfile extends StatefulWidget {
  final userId;
  const UpdateProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

enum SingingCharacter { male, female }

class _UpdateProfileState extends State<UpdateProfile> {
  UserResponseModel? _user;
  UpdateUserRequestModel? model;

  bool _loading = false;

  final SingingCharacter _character = SingingCharacter.male;
  TextEditingController dateinput = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    _getUserById();
    super.initState();
  }

  _getUserById() async {
    _user = await UserService().getUserById(widget.userId);
    if (!mounted) return;
    if (_user != null) {
      setState(() {
        _nameController.text = _user!.fullname;
        _emailController.text = _user!.email ?? '';
        _phoneNumber.text = _user!.phone ?? '';
        if (_user!.gender == null) _user!.gender = true;
        _loading = true;
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (birthDate.month > currentDate.month) {
      age--;
    } else if (currentDate.month == birthDate.month) {
      if (birthDate.day > currentDate.day) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: !_loading
          ? const ScreenLoadingNoOpacity()
          : Scaffold(
        backgroundColor: AppColors.loginScreenBackGround,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Cập nhật thông tin",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 160.w,
                      height: 160.h,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 160.w,
                            height: 160.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                  "assets/image/user-pic/user.png"),
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
                                onPressed: () async {},
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
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Họ và tên",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _user!.fullname = value;
                            });
                          },
                          controller: _nameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.grey200),
                                borderRadius: BorderRadius.circular(16)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    color: AppColors.buttonColor),
                                borderRadius: BorderRadius.circular(16)),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            hintText: "Nhập tên của bạn",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Số điện thoại",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16)),
                          child: TextField(
                            enabled: false,
                            controller: _phoneNumber,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.grey200),
                                  borderRadius:
                                  BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.grey200),
                                  borderRadius:
                                  BorderRadius.circular(16)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      color: AppColors.buttonColor),
                                  borderRadius:
                                  BorderRadius.circular(16)),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              hintText: _user!.phone,
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.lightTextColor,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Giới tính",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: DropdownButtonFormField(
                              value: _user!.gender,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.lightTextColor,
                              ),
                              decoration: InputDecoration(
                                labelText: "Chọn giới tính",
                                labelStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightTextColor,
                                ),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.grey200),
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: AppColors.buttonColor),
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              items: [
                                DropdownMenuItem(
                                    value: true,
                                    child: Text(
                                      "Nam",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackTextColor,
                                      ),
                                    )),
                                DropdownMenuItem(
                                    value: false,
                                    child: Text(
                                      "Nữ",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackTextColor,
                                      ),
                                    )),
                              ],
                              onChanged: (value) {
                                _user!.gender = value;
                              },
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _user!.email = value;
                            });
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  constraints: const BoxConstraints(
                                    maxHeight: 20.0,
                                    maxWidth: 20.0,
                                  ),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/image/icon-logo/mail.png',
                                    ),
                                  ),
                                )),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.grey200),
                                borderRadius: BorderRadius.circular(16)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    color: AppColors.buttonColor),
                                borderRadius: BorderRadius.circular(16)),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            hintText: _user!.email,
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: AppColors.grey100,
                      style: BorderStyle.solid,
                      width: 2))),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      UpdateUserRequestModel model =
                      UpdateUserRequestModel(
                          id: _user!.id,
                          fullname: _user!.fullname,
                          address: "",
                          email: _user!.email,
                          gender: _user!.gender as bool,);
                      log(jsonEncode(model));
                      var response =
                      await UserService().updateUser(model);
                      if (response == null ||
                          response.statusCode != 204) {
                        log("error when update user");
                      } else {
                        Get.offAll(() => const MainPage());
                      }
                      Get.offAll(() => const MainPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      fixedSize: Size.fromHeight(50.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Cập nhật thông tin',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
