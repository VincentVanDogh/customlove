import 'package:flutter/cupertino.dart';
import 'package:frontend/src/config/theme.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function()? onTap;

  final CustomLoveTheme _theme = const CustomLoveTheme();

  const MenuItem({required this.label, required this.icon, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: _theme.universalPadding,
              horizontal: _theme.universalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_theme.universalPadding),
          ),
          child: Row(children: [
            Icon(icon),
            SizedBox(width: _theme.universalPadding,),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: _theme.textColor,
              ),
            ),
          ]),
        ),
    );
  }
}
