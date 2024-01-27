import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';

import '../../../../../config/theme.dart';

typedef void GenderCallback(Gender val);

class DropDownList extends StatefulWidget {
  const DropDownList({
    super.key,
    required this.callback,
    required this.labelText,
    required this.value,
    required this.options,
  });

  final GenderCallback callback;
  final String labelText;
  final Gender? value;
  final List<Gender> options;

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  @override
  void initState() {
    super.initState();
    labelText = widget.labelText;
    value = widget.value;
    options = widget.options;
  }

  late String labelText;
  late Gender? value;
  late List<Gender> options;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: (val) {
        setState(() {
          value = val as Gender;
          widget.callback(value!);
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      dropdownColor: _customLoveTheme.grayscale0,
      decoration: InputDecoration(
          labelText: labelText,
          fillColor: _customLoveTheme.grayscale0,
          filled: true,
          labelStyle: TextStyle(color: _customLoveTheme.grayscale1),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
          )
      ),
    );
  }
}

