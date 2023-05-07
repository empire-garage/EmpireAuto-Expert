import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScreenLoading extends StatelessWidget {
  const ScreenLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
          child: SpinKitThreeBounce(
        color: Colors.white,
        size: 30,
      )),
    );
  }
}
