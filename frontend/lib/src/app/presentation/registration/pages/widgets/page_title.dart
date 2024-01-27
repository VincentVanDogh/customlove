import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key? key,
    required this.title,
    required this.description,
    required this.bottomPadding
  })
      : super(key: key);

  final String title;
  final String description;
  final double bottomPadding;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 51.0),
      SizedBox(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'roboto',
                  fontSize: 34.0,
                  color: _customLoveTheme.textColor,
                  decoration: TextDecoration.none))),
      SizedBox(
          child: Text(description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'roboto',
                color: _customLoveTheme.grayscale2, // Colors.white70
                decoration: TextDecoration.none,
                fontStyle: FontStyle.italic,
              ))),
      SizedBox(height: bottomPadding)
    ]);
  }
}
