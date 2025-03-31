// make mint color eleveted button ,make function for this button
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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


commonButtonTitleSubTitle(
    {required String title, required String subTitle, double? width}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    decoration: BoxDecoration(
        color: themeColor.white,
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
              color: themeColor.black.withOpacity(0.1),
              offset: const Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 3),
        ]),
    child: Column(
      children: [
       text14(title,fontWeight: FontWeight.bold),
       text16(subTitle,fontWeight: FontWeight.w600),
      ],
    ),
  );
}

commonMaterialButton(  {required String title,
  Color? color,
  Color? disableColor,
  required dynamic onPressed,
   bool? isButtonDisable,
   Color? borderColor,
   Color? prefixIconColor,
   double? verticalPadding,
   double? horizontalPadding,
   TextStyle? style,
   double? borderRadius,
   String? prefixIcon,}
){
  return MaterialButton(
      color: isButtonDisable==true
          ? disableColor ??themeColor.gray.withOpacity(0.4)
          : color ?? themeColor.mint,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 30),
          side: BorderSide(
              color: isButtonDisable==true
                  ? borderColor!.withOpacity(0.4)
                  : borderColor!,
              width: 1)),
      onPressed: !isButtonDisable! ? onPressed : () {},
      child: MouseRegion(
        cursor: !isButtonDisable!
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 0, vertical: verticalPadding ?? 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null)
                SvgPicture.asset(
                  alignment: Alignment.centerRight,
                  prefixIcon!,
                  color: prefixIconColor,
                ),
              if (prefixIcon != null) SizedBox(width: 10),
              Flexible(
                child: text16(
                  title,
                  color: isButtonDisable
                      ? themeColor.gray.withOpacity(0.4)
                      : themeColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
 
}