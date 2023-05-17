import 'dart:math';

import 'package:flutter/material.dart';

/// Popup widget that you can use by default to show some information
class TopSnackBar extends StatefulWidget {
  const TopSnackBar.success({
    Key? key,
    required this.message,
    required this.subMessage,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.sentiment_very_satisfied,
      color: Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Colors.black,
    ),
    this.subTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: Colors.black,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xff00E676),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  const TopSnackBar.info({
    Key? key,
    required this.message,
    required this.subMessage,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.sentiment_neutral,
      color: Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Colors.black,
    ),
    this.subTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: Colors.black,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 0,
    this.iconPositionTop = 0,
    this.iconPositionLeft = 0,
    this.backgroundColor = Colors.white,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  const TopSnackBar.error({
    Key? key,
    required this.message,
    required this.subMessage,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.error_outline,
      color: Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Colors.black,
    ),
    this.subTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: Colors.black,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xffff5252),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  final String message;
  final String subMessage;
  final Widget icon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final TextStyle subTextStyle;
  final int maxLines;
  final int iconRotationAngle;
  final List<BoxShadow> boxShadow;
  final BorderRadius borderRadius;
  final double iconPositionTop;
  final double iconPositionLeft;
  final EdgeInsetsGeometry messagePadding;
  final double textScaleFactor;
  final TextAlign textAlign;

  @override
  TopSnackBarState createState() => TopSnackBarState();
}

class TopSnackBarState extends State<TopSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 60,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: widget.boxShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            height: 95,
            child: Transform.rotate(
              angle: widget.iconRotationAngle * pi / 180,
              child: widget.icon,
            ),
          ),
          Padding(
            padding: widget.messagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: theme.textTheme.bodyMedium?.merge(widget.textStyle),
                  textAlign: widget.textAlign,
                  overflow: TextOverflow.ellipsis,
                  maxLines: widget.maxLines,
                  textScaleFactor: widget.textScaleFactor,
                ),
                Text(
                  widget.subMessage,
                  style: theme.textTheme.titleSmall?.merge(widget.subTextStyle),
                  textAlign: widget.textAlign,
                  overflow: TextOverflow.ellipsis,
                  maxLines: widget.maxLines,
                  textScaleFactor: widget.textScaleFactor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 8),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));
