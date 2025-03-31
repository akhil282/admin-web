import 'package:flutter/material.dart';
import 'package:get/get.dart';

showAppSnackBar({
  BuildContext? context, // Optional for GetX
  required String title,
  required String message,
  Color bgColor = Colors.black, // Default background color
  bool useGetX = true, // Default to GetX snackbar
}) {
  print("useGetX: $useGetX");
  if (useGetX) {
    // Show Snackbar using GetX
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      borderRadius: 10,
      margin: EdgeInsets.all(10),
    );
  } else {
    print("useGetX-------: $useGetX");
    // Show Snackbar using ScaffoldMessenger
    if (context != null) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          action: SnackBarAction(label: title, onPressed: () {}),
          duration: Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } else {
      debugPrint("Context is required for ScaffoldMessenger snackbar");
    }
  }
}
