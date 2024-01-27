import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../config/theme.dart';

typedef void StringCallback(String val);

class RegistrationBioTextfield extends StatefulWidget {
  final StringCallback callback;
  final String? controller;
  final String? hintText;
  final int characterLimit;
  final int? maxLines;

  const RegistrationBioTextfield({
    super.key,
    required this.callback,
    required this.controller,
    required this.hintText,
    required this.characterLimit,
    required this.maxLines
  });

  @override
  State<RegistrationBioTextfield> createState() => _RegistrationBioTextfieldState();
}

class _RegistrationBioTextfieldState extends State<RegistrationBioTextfield> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  int characterCounter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      characterCounter = widget.controller!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (text) {
        setState(() {
          characterCounter = text.length;
        });
        widget.callback(text);
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.characterLimit)
      ],
      keyboardType: TextInputType.multiline,
      maxLines: widget.maxLines,
      initialValue: widget.controller,
      decoration: InputDecoration(
        labelText: widget.hintText,
        labelStyle: TextStyle(color: _customLoveTheme.grayscale1),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _customLoveTheme.whiteColor)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _customLoveTheme.grayscale1)
        ),
        fillColor: _customLoveTheme.grayscale0,
        filled: true,
        hintStyle: TextStyle(color: _customLoveTheme.grayscale1),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("$characterCounter / ${widget.characterLimit}", style: TextStyle(color: _customLoveTheme.grayscale1),),
        ),
        suffixIconConstraints: const BoxConstraints(maxHeight:double.infinity),
      ),
    );
  }
}
