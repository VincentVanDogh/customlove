import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/interest_model.dart';

import '../../../../../config/theme.dart';
import '../../../utils/interests.dart';

class InterestButton extends StatefulWidget {
  const InterestButton({
    super.key,
    required this.interest,
    required this.containsInterestFunction,
    required this.addRemoveInterestFunction
  });

  final Interest interest;
  final Function containsInterestFunction;
  final Function addRemoveInterestFunction;

  @override
  State<InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: Icon(Interests.getIconData(widget.interest.name),
            color: widget.containsInterestFunction(widget.interest) ? Colors.white : _customLoveTheme.tertiaryColor
        ),
        label: Text(widget.interest.name),
        onPressed: () {
          setState(() {
            widget.addRemoveInterestFunction(widget.interest);
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          backgroundColor: widget.containsInterestFunction(widget.interest) ? _customLoveTheme.tertiaryColor : Colors.white,
          foregroundColor: widget.containsInterestFunction(widget.interest) ? Colors.white : _customLoveTheme.tertiaryColor,
          elevation: 15,
          shadowColor: Colors.black,
          alignment: Alignment.center,
          shape: StadiumBorder(
              side: BorderSide(
                  width: 2,
                  color: widget.containsInterestFunction(widget.interest) ? Colors.white : _customLoveTheme.tertiaryColor
              )
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
    );
  }
}
