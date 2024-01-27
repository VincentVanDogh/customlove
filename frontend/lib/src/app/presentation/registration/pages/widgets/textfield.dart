import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../config/theme.dart';

typedef void StringCallback(String val);

class RegistrationTextfield extends StatelessWidget {
  // Accesses what the users fill into the text field
  final StringCallback callback;
  final String? controller;
  final String hintText;
  final bool obscureText;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  const RegistrationTextfield({
    super.key,
    required this.callback,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(256)],
      onChanged: (text) {
        callback(text);
      },
      initialValue: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _customLoveTheme.whiteColor)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _customLoveTheme.grayscale1)
          ),
          fillColor: _customLoveTheme.grayscale0,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: _customLoveTheme.grayscale1)
      ),
    );
  }
}
