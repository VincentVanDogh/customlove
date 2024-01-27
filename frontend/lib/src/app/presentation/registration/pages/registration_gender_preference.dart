import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/birthdate_field.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_checkboxes/dropdown_checkbox.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_list.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/service/gender_service.dart';
import 'package:frontend/src/config/widgets/exception_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../config/theme.dart';
import '../../../model/gender_model.dart';
import '../../../model/interest_model.dart';
import '../../../model/language_model.dart';
import '../enums/registration_page_enum.dart';

class RegistrationGenderPreference extends StatefulWidget {
  const RegistrationGenderPreference({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList,
    required this.location,
    required this.searchRadius,
    required this.job,
    required this.bio,
    required this.languages
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final Gender? gender;
  final List<Gender> preference;
  final String? birthdate;
  final XFile? profilePicture;
  final List<Interest> userInterestIdList;
  final Position? location;
  final double? searchRadius;
  final String? job;
  final String? bio;
  final List<Language> languages;

  @override
  State<RegistrationGenderPreference> createState() => _RegistrationGenderPreferenceState();
}

class _RegistrationGenderPreferenceState extends State<RegistrationGenderPreference> {
  @override
  void initState() {
    super.initState();
    gender = widget.gender;
    birthdate = widget.birthdate;
    getGenders();
  }

  void getGenders() async {
    try {
      await _genderService.getGenders().then((value) {
        setState(() {
          genderDto = value;
          for (Gender gender in genderDto) {
            genderPreferences.options.add(
                ValueItem(label: gender.name, value: gender)
            );
          }
          for (Gender preference in widget.preference) {
            genderPreferences.addSelectedOption(
                ValueItem<Gender>(label: preference.name, value: preference)
            );
          }
        });
      });
    } catch (e) {
      setState(() {
        httpError = true;
      });
    }
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final GenderService _genderService = GenderService();
  Gender? gender;
  String? birthdate;

  late List<Gender> genderDto = [];
  MultiSelectController<Gender> genderPreferences = MultiSelectController<Gender>();
  late bool httpError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 0, 25, 0),
            child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: CustomScrollView(
                  scrollBehavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  slivers: [
                  SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const PageTitle(
                          title: "Profile Details",
                          description: "Provide some basic data about yourself",
                          bottomPadding: 70.0,
                      ),
                      if (httpError)
                        const ExceptionWidget(
                            httpStatus: "503",
                            httpMessage: "Make sure that the backend is running"
                        ),
                      if (genderDto.isEmpty && !httpError)
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                                color: _customLoveTheme.primaryColor,
                                strokeWidth: 18
                            )
                        ),
                      if (genderDto.isNotEmpty)
                        Column(children: [
                        DropDownList(
                          labelText: "Gender",
                          value: gender,
                          options: genderDto,
                          callback: (val) => setState(() => gender = val),
                        ),
                        const SizedBox(height: 19.0),
                          DropdownCheckbox(
                            pickedGenderPreferences: genderPreferences,
                            callback: (val) => setState(() {}),
                          ),
                        const SizedBox(height: 19.0),
                        BirthdateField(
                          controller: birthdate,
                          callback: (val) => setState(() => birthdate = val),
                        ),
                      ]),
                      const SizedBox(height: 25.0),
                      Expanded(child: Container()),
                      Footer(
                          pageSection: RegistrationPageSection.genderPreference,
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          email: widget.email,
                          password: widget.password,
                          gender: gender,
                          genderPreference: listValuesToGenderList(genderPreferences.selectedOptions),
                          birthdate: birthdate,
                          profilePicture: widget.profilePicture,
                          userInterestIdList: widget.userInterestIdList,
                          location: widget.location,
                          searchRadius: widget.searchRadius,
                          job: widget.job,
                          bio: widget.bio,
                          languages: widget.languages,
                      )
                    ],
                  ),
                  ),
                  ],
                ),
            ),
          ),
        )
    );
  }
  List<Gender> listValuesToGenderList(List<ValueItem<Gender>> valueItems) {
    List<Gender> extractedGenders = [];
    for (ValueItem<Gender> item in valueItems) {
      if (item.value != null) {
        extractedGenders.add(item.value!);
      }
    }
    return extractedGenders;
  }
}
