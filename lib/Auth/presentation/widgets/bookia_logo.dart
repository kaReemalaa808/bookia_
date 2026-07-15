import 'package:flutter/material.dart';

class BookiaLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final double spacing;

  const BookiaLogo({
    super.key,
    this.iconSize = 55.0,
    this.fontSize = 50.0,
    this.spacing = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
        SizedBox(width: spacing),
        Text(
          'Bookia',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'Georgia',
            color: const Color(0xFF1E232C),
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}
