import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:toastification/toastification.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyALc6qbDR1LsKuIeFQb2DQ-hcewbytlVIso",
      appId: "1:888315519906:android:97f8123488c9368c56c8fb",
      messagingSenderId: "888315519906",
      projectId: "cater-management",
      
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData(
          primaryColor: themeColor.mint,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: themeColor.rubyGreen, // Cursor color
            selectionColor: themeColor.mint.withOpacity(
              0.5,
            ), // Selected text background color
            selectionHandleColor: themeColor.rubyGreen, // Handle color
          ),
        ),
      ),
    );
  }
}
