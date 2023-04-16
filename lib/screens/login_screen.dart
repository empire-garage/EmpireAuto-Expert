import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/screens/main_page.dart';
import 'package:empire_expert/services/authen_firebase_services/authentication.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../common/colors.dart';
import '../models/request/sign_in_request_model.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late bool _loading = false;

  String email = "";

  String password = "";

  @override
  void initState() {
    _checkUserExist();
    super.initState();
  }

  _checkUserExist() async {
    var result = await getUserId();
    if (result != null) {
      Get.off(() => const MainPage());
    }
  }

  _getBrands() async {
    var json = await BrandService().getBrandsJson();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('brands', json);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.loginScreenBackGround,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 52.h,
                    ),
                    Text(
                      "Đăng nhập",
                      style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                          fontFamily: 'SFProDisplay'),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "Vui lòng nhập thông tin đăng nhập của bạn để tiếp tục",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightTextColor,
                        fontFamily: 'SFProDisplay',
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email không được để trống !';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Nhập email của bạn",
                          ),
                        )),
                      ],
                    ),
                    if (email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password không được để trống !';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Password",
                              ),
                            )),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: !_loading
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      var message = await AppAuthentication()
                                          .signInWithEmailPassword(
                                              SignInRequestModel(
                                                  email: email,
                                                  password: password));
                                      if (message != "Unauthorized") {
                                        await _getBrands();
                                        Get.off(() => const MainPage());
                                      }
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    fixedSize: Size.fromHeight(50.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    fixedSize: Size.fromHeight(50.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
