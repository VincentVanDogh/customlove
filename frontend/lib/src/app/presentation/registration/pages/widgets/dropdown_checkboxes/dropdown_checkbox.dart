import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../../../config/theme.dart';

typedef void MultiSelectCallback(MultiSelectController<Gender> val);

class DropdownCheckbox extends StatefulWidget {

  const DropdownCheckbox({
    super.key,
    required this.callback,
    required this.pickedGenderPreferences
  });

  final MultiSelectCallback callback;
  final MultiSelectController<Gender> pickedGenderPreferences;

  @override
  State<DropdownCheckbox> createState() => _DropdownCheckboxState();
}

class _DropdownCheckboxState extends State<DropdownCheckbox> {
  @override
  void initState() {
    super.initState();
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            MultiSelectDropDown<Gender>(
              padding: EdgeInsets.fromLTRB(widget.pickedGenderPreferences.selectedOptions.isEmpty ? 0 : 12, 0, 12, 0),
              hint: "Preference",
              hintStyle: TextStyle(
                color: _customLoveTheme.grayscale1,
                fontSize: 16,
                fontFamily: GoogleFonts.roboto().fontFamily
              ),
              fieldBackgroundColor: _customLoveTheme.grayscale0,
              borderRadius: 5.0,
              showClearIcon: true,
              controller: widget.pickedGenderPreferences,
              options: widget.pickedGenderPreferences.options,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 125,
              optionTextStyle: const TextStyle(fontSize: 16),
              optionsBackgroundColor: _customLoveTheme.grayscale0,
              selectedOptionIcon: const Icon(Icons.check_circle),
              borderColor: _customLoveTheme.formFieldBorder,
              selectedOptionTextColor: _customLoveTheme.formFieldBorder,
              selectedOptionBackgroundColor: _customLoveTheme.primaryColor,
              onOptionSelected: (List<ValueItem<Gender>> selectedOptions) {
                setState(() {
                  widget.callback(widget.pickedGenderPreferences);
                });
              },
            ),
          ],
        ),
    );
  }
}
