import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    Widget? tablet,
    Widget? desktop,
  }) : tablet = tablet ?? mobile,
       desktop = desktop ?? tablet ?? mobile,
       super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 675;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 675 &&
      MediaQuery.of(context).size.width < 1090;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1090;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print("width:--------->${MediaQuery.of(context).size.width}");
        if (isDesktop(context)) {
          return desktop;
        } else if (isTablet(context)) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}

double getWidth(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * (percentage / 100);
}

double getHeight(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height * (percentage / 100);
}
