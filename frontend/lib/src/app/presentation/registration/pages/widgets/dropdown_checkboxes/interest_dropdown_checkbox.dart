import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../../../config/theme.dart';

typedef void MultiSelectCallback(MultiSelectController<Interest> val);

class InterestDropdownCheckbox extends StatefulWidget {

  const InterestDropdownCheckbox({
    super.key,
    required this.callback,
    required this.pickedInterests
  });

  final MultiSelectCallback callback;
  final MultiSelectController<Interest> pickedInterests;

  @override
  State<InterestDropdownCheckbox> createState() => _InterestDropdownCheckboxState();
}

class _InterestDropdownCheckboxState extends State<InterestDropdownCheckbox> {
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
            MultiSelectDropDown<Interest>(
              padding: EdgeInsets.fromLTRB(widget.pickedInterests.selectedOptions.isEmpty ? 0 : 12, 0, 12, 0),
              hint: "Interests",
              hintStyle: TextStyle(
                color: _customLoveTheme.grayscale1,
                fontSize: 16,
                fontFamily: GoogleFonts.roboto().fontFamily
              ),
              fieldBackgroundColor: _customLoveTheme.grayscale0,
              borderRadius: 5.0,
              showClearIcon: true,
              controller: widget.pickedInterests,
              options: widget.pickedInterests.options,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 125,
              optionTextStyle: const TextStyle(fontSize: 16),
              optionsBackgroundColor: _customLoveTheme.grayscale0,
              selectedOptionIcon: const Icon(Icons.check_circle),
              borderColor: _customLoveTheme.formFieldBorder,
              selectedOptionTextColor: _customLoveTheme.formFieldBorder,
              selectedOptionBackgroundColor: _customLoveTheme.primaryColor,
              onOptionSelected: (List<ValueItem<Interest>> selectedOptions) {
                setState(() {
                  widget.callback(widget.pickedInterests);
                });
              },
            ),
          ],
        ),
    );
  }
}
