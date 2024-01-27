import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class CustomLoveTheme extends ThemeExtension<CustomLoveTheme> {
  const CustomLoveTheme({
    this.primaryColor = const Color(0xFFE91E63), // Pink 500
    this.tertiaryColor = const Color(0xFFF06292), // Pink 200
    this.neutralColor = const Color(0xFFFFC0CB), // Pink 100
    this.grayscale0 = const Color(0xffeeeeee),
    this.grayscale1 = const Color(0xffbdbdbd),
    this.grayscale2 = const Color(0xff757575),
    this.whiteColor = Colors.white,
    this.textColor = const Color(0xFF000000), // Black
    this.androidGreen = const Color(0xFF32DE84),
    this.redColor = const Color(0xFFFF0000),
    this.linkColor = const Color(0xFF2196F3),
    this.neutralBackgroundColor = const Color(0xFFFFFFFF),
    this.formFieldBorder = const Color(0xFFFFFFFF),
    this.inputWidth = 327,
    this.inputHeight = 56,
    this.textFieldDecoration,
    this.buttonStyle,
    this.defaultButtonTextStyle = const TextStyle(fontSize: 18),
  });

  final Color primaryColor, tertiaryColor, neutralColor, textColor, neutralBackgroundColor;
  final Color grayscale0, grayscale1, grayscale2, whiteColor;
  final Color formFieldBorder, androidGreen, redColor, linkColor;
  final double inputWidth, inputHeight;
  final InputDecoration? textFieldDecoration;
  final ButtonStyle? buttonStyle;
  final TextStyle defaultButtonTextStyle;
  final double universalPadding = 8;

  ThemeData toThemeData() {
    return ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.roboto().fontFamily
    );
  }

  @override
  CustomLoveTheme copyWith({
    Color? primaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
    Color? grayscale0,
    Color? grayscale1,
    Color? grayscale2,
    Color? whiteColor,
    Color? textColor,
    Color? neutralBackgroundColor,
    Color? formFieldBorder,
    Color? androidGreen,
    Color? redColor,
    Color? linkColor,
    double? inputWidth,
    double? inputHeight,
    InputDecoration? textFieldDecoration,
    ButtonStyle? buttonStyle,
    TextStyle? defaultButtonTextStyle,
  }) =>
      CustomLoveTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
        neutralColor: neutralColor ?? this.neutralColor,
        grayscale0: grayscale0 ?? this.grayscale0,
        grayscale1: grayscale1 ?? this.grayscale1,
        grayscale2: grayscale2 ?? this.grayscale2,
        whiteColor: whiteColor ?? this.whiteColor,
        textColor: textColor ?? this.textColor,
        neutralBackgroundColor: neutralBackgroundColor ?? this.neutralBackgroundColor,
        formFieldBorder: formFieldBorder ?? this.formFieldBorder,
        androidGreen: androidGreen ?? this.androidGreen,
        redColor: redColor ?? this.redColor,
        linkColor: linkColor ?? this.linkColor,
        inputWidth: inputWidth ?? this.inputWidth,
        inputHeight: inputHeight ?? this.inputHeight,
        textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
        buttonStyle: buttonStyle ?? this.buttonStyle,
        defaultButtonTextStyle:
            defaultButtonTextStyle ?? this.defaultButtonTextStyle,
      );

  @override
  CustomLoveTheme lerp(
      covariant ThemeExtension<CustomLoveTheme>? other, double t) {
    if (other is! CustomLoveTheme) return this;
    return CustomLoveTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
      grayscale0: Color.lerp(grayscale0, other.grayscale0, t)!,
      grayscale1: Color.lerp(grayscale1, other.grayscale1, t)!,
      grayscale2: Color.lerp(grayscale2, other.grayscale2, t)!,
      whiteColor: Color.lerp(whiteColor, other.whiteColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      neutralBackgroundColor: Color.lerp(neutralBackgroundColor, other.neutralBackgroundColor, t)!,
      formFieldBorder: Color.lerp(formFieldBorder, other.formFieldBorder, t)!,
      androidGreen: Color.lerp(androidGreen, other.androidGreen, t)!,
      redColor: Color.lerp(redColor, other.redColor, t)!,
      linkColor: Color.lerp(linkColor, other.linkColor, t)!,
      inputWidth: lerpDouble(inputWidth, other.inputWidth, t)!,
      inputHeight: lerpDouble(inputHeight, other.inputHeight, t)!,
      textFieldDecoration: other.textFieldDecoration ?? textFieldDecoration,
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
      defaultButtonTextStyle: TextStyle.lerp(
              defaultButtonTextStyle, other.defaultButtonTextStyle, t) ??
          defaultButtonTextStyle,
    );
  }
}
