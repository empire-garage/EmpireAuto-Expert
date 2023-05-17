// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/response/loginresponse.dart';
import 'package:empire_expert/models/user_info.dart' as user_info;
import 'package:empire_expert/services/notification/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/api_part.dart';

import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request/sign_in_request_model.dart';

class AppAuthentication {
  String _verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppAuthentication();

  Future<String> sendOTP(
      BuildContext context, String countryCode, var phoneNumber) async {
    try {
      verificationFailed(FirebaseAuthException authException) {
        log(authException.code);
        log(authException.message.toString());
      }

      codeSent(String verificationId, [int? forceResendingToken]) async {
        // Navigate to the OTP verification screen
        log("codeSent");
        log(verificationId);
        _verificationId = verificationId;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('verification_id', _verificationId);
      }

      codeAutoRetrievalTimeout(String verificationId) {
        log("codeAutoRetrievalTimeout");
        _verificationId = verificationId;
      }

      verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
        log("verificationCompleted");
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: countryCode + phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log("Can not get OTP");
      return "Can not get OTP";
    }
    return "";
  }

  Future<String> confirmOTP(
      String otpCode, FirebaseAuth auth, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _verificationId = prefs.getString('verification_id').toString();

      log('VerificationID: $_verificationId');
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otpCode);
      // Sign the user in (or link) with the credential
      var userRecord = await auth.signInWithCredential(credential);
      if (userRecord.user == null) {
        log("Not found user");
        return "Not found user";
      }
      log(userRecord.user.toString());
      var response =
          await signInRequestBE(userRecord.user!.phoneNumber.toString());

      log(userRecord.user!.phoneNumber.toString());
      // var response = await signInRequestBE('%2B84372015192');
      if (response == null) {
        log("Unauthorized");
        return "Unauthorized";
      }
      await saveUserInfo(user_info.UserInfo(
          userId: response.id, firebaseUUID: userRecord.user!.uid));
      await NotificationService().saveToken(userRecord.user!.uid);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return e.toString();
      }
    }
    return "";
  }

  Future<void> siginWithGoogle(FirebaseAuth auth, BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Fail to Login with Google");
      }
    }
  }

  Future<String> signInWithEmailPassword(SignInRequestModel model) async {
    User? user;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
      return "Unauthorized";
    }
    if (user == null) return "Unauthorized";
    //SigninBackend
    var response = await signInEmailRequestBE(model);
    if (response == null) {
      log("Unauthorized");
    }
    await saveUserInfo(
        user_info.UserInfo(userId: response!.id, firebaseUUID: user.uid));
    await NotificationService().saveToken(user.uid);
    return "Sign in with user ${response.name}";
  }

  Future<LoginResponseModel?> signInRequestBE(String phone) async {
    log('Signing...');
    phone = phone.replaceAll("+", "%2B");
    var url = Uri.parse(
        "${APIPath.path}/authentications/phone-method/login?phone=$phone");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      try {
        var user = LoginResponseModel.fromJson(jsonDecode(response.body));
        await saveJwtToken(user.accessToken);
        log('Sign in success with user ${user.name}');
        return user;
      } on Exception catch (_) {
        var jsonBody = jsonDecode(response.body);
        log(jsonBody['value']);
        return null;
      }
    } else {
      if (kDebugMode) {
        print('Signin failed');
      }
    }
    return null;
  }

  Future<LoginResponseModel?> signInEmailRequestBE(
      SignInRequestModel model) async {
    log('Signing with ${model.email}');
    var url = Uri.parse("${APIPath.path}/authentications/email-method/login");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      try {
        var user = LoginResponseModel.fromJson(jsonDecode(response.body));
        await saveJwtToken(user.accessToken);
        log('Sign in success with user ${user.name}');
        return user;
      } on Exception catch (_) {
        var jsonBody = jsonDecode(response.body);
        log(jsonBody['value']);
        return null;
      }
    } else {
      if (kDebugMode) {
        print('Signin failed');
      }
    }
    return null;
  }

  Future<void> addFcmToken(String uuid, String fcmToken) async {
    var url =
        "${APIPath.path}/notifications/fcmtoken/add?userId=$uuid&fcmToken=$fcmToken";
    var response = await makeHttpRequest(url, method: 'POST');
    log(response as String);
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
