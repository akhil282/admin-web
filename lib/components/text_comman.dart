import 'package:flutter/material.dart';

textResponsive10(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
}) {
  return _responsiveText(
    text,
    0.02,
    color: color,
    fontWeight: fontWeight,
    textAlign: textAlign,
    overflow: overflow,
  );
}

textResponsive14(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
}) {
  return _responsiveText(
    text,
    0.028,
    color: color,
    fontWeight: fontWeight,
    textAlign: textAlign,
    overflow: overflow,
  );
}

textResponsive16(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
}) {
  return _responsiveText(
    text,
    0.032,
    color: color,
    fontWeight: fontWeight,
    textAlign: textAlign,
    overflow: overflow,
  );
}

_responsiveText(
  String text,
  double scaleFactor, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fontSize;

      if (screenWidth < 400) {
        fontSize = screenWidth * scaleFactor; // Minimum size for small screens
      } else if (screenWidth < 800) {
        fontSize =
            screenWidth *
            (scaleFactor + 0.01); // Scale for tablets and medium devices
      } else {
        fontSize =
            screenWidth *
            (scaleFactor +
                0.01); // Fixed size for large screens to avoid excessive scaling
      }

      return Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        overflow: overflow ?? TextOverflow.visible,
        style: TextStyle(
          fontSize: fontSize,
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      );
    },
  );
}

// ----------------- Normal Text -----------------

text10(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
  Color? backgroundColor,
  double? fontSize,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
  int? maxLines,
  TextDirection? textDirection,
  TextHeightBehavior? textHeightBehavior,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextScaler? textScaler,
  TextStyle? style,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    textDirection: textDirection,
    textScaler: textScaler,
    style: TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: fontWeight,
      background: background,
      backgroundColor: backgroundColor,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
  );
}

text12(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
  Color? backgroundColor,
  double? fontSize,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
  int? maxLines,
  TextDirection? textDirection,
  TextHeightBehavior? textHeightBehavior,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextScaler? textScaler,
  TextStyle? style,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    textDirection: textDirection,
    textScaler: textScaler,
    style: TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: fontWeight,
      background: background,
      backgroundColor: backgroundColor,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
  );
}

text14(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
  Color? backgroundColor,
  double? fontSize,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
  int? maxLines,
  TextDirection? textDirection,
  TextHeightBehavior? textHeightBehavior,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextScaler? textScaler,
  TextStyle? style,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    textDirection: textDirection,
    textScaler: textScaler,
    style: TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: fontWeight,
      background: background,
      backgroundColor: backgroundColor,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
  );
}

text16(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
  Color? backgroundColor,
  double? fontSize,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
  int? maxLines,
  TextDirection? textDirection,
  TextHeightBehavior? textHeightBehavior,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextScaler? textScaler,
  TextStyle? style,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    textDirection: textDirection,
    textScaler: textScaler,
    style: TextStyle(
      fontSize: 16,
      color: color,
      fontWeight: fontWeight,
      background: background,
      backgroundColor: backgroundColor,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
  );
}

text20(
  String text, {
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  TextOverflow? overflow,
  Color? backgroundColor,
  double? fontSize,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
  int? maxLines,
  TextDirection? textDirection,
  TextHeightBehavior? textHeightBehavior,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextScaler? textScaler,
  TextStyle? style,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    textDirection: textDirection,
    textScaler: textScaler,
    style: TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: fontWeight,
      background: background,
      backgroundColor: backgroundColor,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
  );
}
