import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

typedef void StringCallback(String val);

class BirthdateField extends StatefulWidget {
  BirthdateField({
    super.key,
    required this.callback,
    required this.controller,
  });

  final StringCallback callback;
  late String? controller;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();


  @override
  State<BirthdateField> createState() => _BirthdateFieldState();
}

class _BirthdateFieldState extends State<BirthdateField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: widget.controller),
      readOnly: true,
      onTap: () {
        selectDate().then((value) {
          setState(() {
            if (widget.controller != null) {
              widget.callback(widget.controller!);
            }
          });
        });
      },
      decoration: InputDecoration(
          fillColor: widget._customLoveTheme.grayscale0,
          filled: true,
          suffixIcon: const Icon(Icons.calendar_today),
          labelText: "Birthday",
          labelStyle: TextStyle(color: widget._customLoveTheme.grayscale1),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget._customLoveTheme.formFieldBorder)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget._customLoveTheme.formFieldBorder)
          )
      ),
    );
  }

  Future<void> selectDate() async {
    final today = DateTime.now();
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime(today.year - 18, today.month, today.day),
        firstDate: DateTime(1900),
        lastDate: DateTime(today.year - 18, today.month, today.day)
    );

    if (_picked != null) {
      widget.controller = _picked.toString().split(" ")[0];
    }
  }
}
