import 'package:flutter/material.dart';
import 'package:frontend/src/config/theme.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  const LoginButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                    color: _customLoveTheme.formFieldBorder,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(text: text),
                   WidgetSpan(
                     alignment: PlaceholderAlignment.middle,
                     child: Padding(
                       padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                       child: Icon(
                         Icons.login,
                         size: 24,
                         color: _customLoveTheme.formFieldBorder,
                       )
                   ))
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
