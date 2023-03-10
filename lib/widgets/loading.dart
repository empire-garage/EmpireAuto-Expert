import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color? backgroundColor;
  const Loading({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
