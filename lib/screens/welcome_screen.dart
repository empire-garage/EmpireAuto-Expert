import 'dart:async';
import 'package:empire_expert/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // ignore: prefer_typing_uninitialized_variables
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen(),
            )));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.welcomeScreenBackGround,
        body: Center(
            child: SizedBox(
          width: 290,
          height: 106,
          child: Image.asset('assets/image/app-logo/empirelogo.png'),
        )),
      ),
    );
  }
}
