import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/request/sign_in_request_model.dart';
import 'package:empire_expert/screens/main_page.dart';
import 'package:empire_expert/services/authen_firebase_services/authentication.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/widgets/screen_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../common/colors.dart';

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
  bool _obscureText = true;
  String email = "";
  final FocusNode _passwordFocusNode = FocusNode();
  Color _suffixIconColor = Colors.grey.shade500;

  String password = "";

  @override
  void initState() {
    _checkUserExist();
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _suffixIconColor = _passwordFocusNode.hasFocus
            ? AppColors.blue600
            : Colors.grey.shade500;
      });
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
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
                      height: 100.h,
                    ),
                    Text(
                      "Đăng nhập",
                      style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                          fontFamily: 'Roboto'),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Email",
                      style: AppStyles.header600(fontsize: 12.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          enabled: !_loading,
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
                          cursorColor: AppColors.blue600,
                          decoration: InputDecoration(
                            hintText: "Nhập email",
                            hintStyle: AppStyles.text400(
                                fontsize: 12.sp, color: Colors.grey.shade500),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                borderSide: BorderSide(
                                    color: AppColors.blue600, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200)),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Mật khẩu",
                      style: AppStyles.header600(fontsize: 12.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          enabled: !_loading,
                          obscureText: _obscureText,
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Mật khẩu không được để trống !';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          cursorColor: AppColors.blue600,
                          decoration: InputDecoration(
                            hintText: "Nhập mật khẩu",
                            hintStyle: AppStyles.text400(
                                fontsize: 12.sp, color: Colors.grey.shade500),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                borderSide: BorderSide(
                                    color: AppColors.blue600, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              color: _suffixIconColor,
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
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
                                      showDialog(context: context, builder: (context) => const ScreenLoading());
                                      var message = await AppAuthentication()
                                          .signInWithEmailPassword(
                                              SignInRequestModel(
                                                  email: email,
                                                  password: password));
                                      if (message != "Unauthorized") {
                                        await _getBrands();
                                        Get.back();
                                        Get.off(() => const MainPage());
                                      } else {
                                        Get.back();
                                      }
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    fixedSize: Size.fromHeight(55.sp),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    fixedSize: Size.fromHeight(55.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
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
