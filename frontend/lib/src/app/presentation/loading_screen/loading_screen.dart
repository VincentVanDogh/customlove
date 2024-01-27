import 'package:flutter/material.dart';

import '../../../config/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      _customLoveTheme.textColor
                  )
              ),
          ),
        ),
      ),
    );
  }
}
