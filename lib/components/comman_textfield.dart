import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';

Widget buildCommonTextField({
  required String label,
  required String hint,
  required TextEditingController controller,
  IconData? icon,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  String? Function(String?)? validator,
  TextStyle? textStyle,
  TextStyle? labelStyle,
  TextStyle? hintStyle,
  Color? fillColor,
  bool filled = false,
  int? maxLength,
  int? maxLines = 1,
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  InputBorder? enabledBorder,
  InputBorder? disabledBorder,
  InputBorder? focusedBorder,
  required String hintText,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
    style: textStyle,
    maxLength: maxLength,
    maxLines: maxLines,
    focusNode: focusNode,
    onChanged: onChanged,
    cursorColor: themeColor.rubyGreen,
    decoration: buildInputDecoration(
      label: label,
      hint: hint,
      icon: icon,
      labelStyle: labelStyle,
      hintStyle: hintStyle,
      fillColor: fillColor,

      filled: filled,
      enabledBorder: enabledBorder,
      disabledBorder: disabledBorder,
      focusedBorder: focusedBorder,
    ),
  );
}

InputDecoration buildInputDecoration({
  required String label,
  required String hint,
  IconData? icon,
  TextStyle? labelStyle,
  TextStyle? hintStyle,
  Color? fillColor,
  bool filled = false,
  InputBorder? enabledBorder,
  InputBorder? disabledBorder,
  InputBorder? focusedBorder,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: labelStyle,
    hintText: hint,
    hintStyle: hintStyle,
    prefixIcon: icon != null ? Icon(icon) : null,
    filled: filled,
    fillColor: fillColor,

    enabledBorder:
        enabledBorder ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
    disabledBorder:
        disabledBorder ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
    focusedBorder:
        focusedBorder ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
  );
}
