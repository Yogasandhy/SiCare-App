import 'package:flutter/material.dart';

class DoctorBadge extends StatelessWidget {
  DoctorBadge({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.iconColor,
    required this.height,
    required this.iconSize,
    required this.fontSize,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Color iconColor;
  final double iconSize;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          SizedBox(width: 4.0),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
