import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

class SummaryTextfield extends StatelessWidget {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final String label;
  final String input;

  const SummaryTextfield({
    super.key,
    required this.label,
    required this.input
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      label,
                      style: TextStyle(
                        color: _customLoveTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      )
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                          input.trim().isEmpty ? "Left blank" : input,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: input.trim().isEmpty ? _customLoveTheme.grayscale1 : _customLoveTheme.textColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                              fontStyle: input.trim().isEmpty ? FontStyle.italic : FontStyle.normal
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}
