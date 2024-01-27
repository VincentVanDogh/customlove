import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/language_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../../../config/theme.dart';

typedef void MultiSelectCallback(MultiSelectController<Language> val);

class LanguageDropdownCheckbox extends StatefulWidget {

  const LanguageDropdownCheckbox({
    super.key,
    required this.callback,
    required this.pickedLanguages
  });

  final MultiSelectCallback callback;
  final MultiSelectController<Language> pickedLanguages;

  @override
  State<LanguageDropdownCheckbox> createState() => _LanguageDropdownCheckboxState();
}

class _LanguageDropdownCheckboxState extends State<LanguageDropdownCheckbox> {
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
            MultiSelectDropDown<Language>(
              padding: EdgeInsets.fromLTRB(widget.pickedLanguages.selectedOptions.isEmpty ? 0 : 12, 0, 12, 0),
              hint: "Spoken languages",
              hintStyle: TextStyle(
                color: _customLoveTheme.grayscale1,
                fontSize: 16,
                fontFamily: GoogleFonts.roboto().fontFamily
              ),
              fieldBackgroundColor: _customLoveTheme.grayscale0,
              borderRadius: 5.0,
              showClearIcon: true,
              controller: widget.pickedLanguages,
              options: widget.pickedLanguages.options,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 125,
              optionTextStyle: const TextStyle(fontSize: 16),
              optionsBackgroundColor: _customLoveTheme.grayscale0,
              selectedOptionIcon: const Icon(Icons.check_circle),
              borderColor: _customLoveTheme.formFieldBorder,
              selectedOptionTextColor: _customLoveTheme.formFieldBorder,
              selectedOptionBackgroundColor: _customLoveTheme.primaryColor,
              onOptionSelected: (List<ValueItem<Language>> selectedOptions) {
                setState(() {
                  widget.callback(widget.pickedLanguages);
                });
              },
            ),
          ],
        ),
    );
  }
}
