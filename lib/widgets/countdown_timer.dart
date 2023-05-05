import 'dart:async';
import 'package:empire_expert/common/colors.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int? senconds;
  final Function onCountdownComplete;
  const CountdownTimer(
      {super.key, this.senconds, required this.onCountdownComplete});

  @override
  // ignore: library_private_types_in_public_api
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int _seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    if (widget.senconds != null) {
      _seconds = widget.senconds!;
    }
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _timer?.cancel();
        widget.onCountdownComplete();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_seconds',
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.lightTextColor,
        ));
  }
}
