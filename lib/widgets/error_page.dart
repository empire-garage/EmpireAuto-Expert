import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LottieErrorScreen(errorMessage: errorDetails.exception.toString()),
    );
  }
}

class LottieErrorScreen extends StatelessWidget {
  final String errorMessage;

  const LottieErrorScreen({Key? key, required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              child: Lottie.asset('assets/animations/error-animation.json')),
          Text(
            'Oops, something when wrong',
            textAlign: TextAlign.center,
            style: AppStyles.header600(
                fontsize: 30.sp, color: Colors.grey.shade800),
          ),
          Text(
            errorMessage,
            style: AppStyles.text400(fontsize: 12.sp, color: AppColors.grey400),
          ),
          Container(
            height: 50.h,
            width: 180.w,
            decoration: const BoxDecoration(
                color: AppColors.blue100,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Go back',
                textAlign: TextAlign.center,
                style: AppStyles.header600(
                    fontsize: 24.sp, color: AppColors.blue600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
