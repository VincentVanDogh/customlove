import 'package:flutter/material.dart';

import '../theme.dart';

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({
    super.key,
    required this.httpStatus,
    required this.httpMessage
  });

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final String httpStatus;
  final String httpMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.warning_rounded, color: _customLoveTheme.redColor, size: 40),
        const SizedBox(height: 10),
        Text(
          "HTTP status: $httpStatus",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _customLoveTheme.redColor,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        Text(
          httpMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _customLoveTheme.redColor,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}
