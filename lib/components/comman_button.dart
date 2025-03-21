// make mint color eleveted button ,make function for this button
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';

colorButton({required String text, required Function() onPressed}) {
  return ElevatedButton(onPressed: onPressed, child: Text(text));
}

// make icon button for delete and edit
iconButton({
  required IconData icon,
  required Function() onPressed,
  required Color color,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(icon, color: themeColor.white.withOpacity(0.8), size: 20),
      ),
    ),
  );
}

Widget buildCommonColorButton({
  required VoidCallback onPressed,
  required String text,
  Color backgroundColor = Colors.blue,
  Color textColor = Colors.white,
  double borderRadius = 30.0,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  ),
  TextStyle? textStyle,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    child: Padding(
      padding: padding,
      child: Text(
        text,
        style:
            textStyle ??
            TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
      ),
    ),
  );
}
