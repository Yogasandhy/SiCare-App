import 'package:flutter/material.dart';

class DayText extends StatelessWidget {
  const DayText({
    super.key,
    required this.day,
  });

  final String day;

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xff0E82FD),
      ),
    );
  }
}
