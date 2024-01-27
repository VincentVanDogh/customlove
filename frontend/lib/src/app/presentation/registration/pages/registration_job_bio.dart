import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/bio_textfield.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_checkboxes/language_dropdown_checkbox.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/textfield.dart';
import 'package:frontend/src/app/service/language_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../config/theme.dart';
import '../../../../config/widgets/exception_widget.dart';
import '../../../model/language_model.dart';
import '../enums/registration_page_enum.dart';

class RegistrationJobBio extends StatefulWidget {
  RegistrationJobBio({
    Key? key,
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
  }) : super(key: key);

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
  late String? job;
  late String? bio;
  final List<Language> languages;

  @override
  State<RegistrationJobBio> createState() => _RegistrationJobBioState();
}

class _RegistrationJobBioState extends State<RegistrationJobBio> {
  @override
  void initState() {
    super.initState();
    getLanguages();
  }

  void getLanguages() async {
    try {
      await _languageService.getLanguages().then((value) {
        setState(() {
          languageDto = value;
          for (Language language in languageDto) {
            pickedLanguages.options.add(
                ValueItem(label: language.name, value: language)
            );
          }
          for (Language language in widget.languages) {
            pickedLanguages.addSelectedOption(
                ValueItem<Language>(label: language.name, value: language)
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
  final logger = Logger();

  final LanguageService _languageService = LanguageService();
  late List<Language> languageDto = [];
  MultiSelectController<Language> pickedLanguages = MultiSelectController<Language>();
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
                scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: <Widget>[
                        const PageTitle(
                          title: "Profile Bio",
                          description: "Optionally specify your job, bio, and which languages you speak",
                          bottomPadding: 70.0,
                        ),
                        if (httpError)
                          const ExceptionWidget(
                              httpStatus: "503",
                              httpMessage: "Make sure that the backend is running"
                          ),
                        if (languageDto.isEmpty && !httpError)
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                  color: _customLoveTheme.primaryColor,
                                  strokeWidth: 18
                              )
                          ),
                        if (languageDto.isNotEmpty)
                          Column(children: [
                            RegistrationBioTextfield(
                                controller: widget.bio,
                                hintText: "Bio",
                                characterLimit: 256,
                                maxLines: null,
                                callback: (val) => setState(() => widget.bio = val)
                            ),
                            const SizedBox(height: 25.0),
                            RegistrationTextfield(
                                controller: widget.job,
                                hintText: "Job",
                                obscureText: false,
                                callback: (val) => setState(() => widget.job = val)
                            ),
                            const SizedBox(height: 19.0),
                            LanguageDropdownCheckbox(
                                pickedLanguages: pickedLanguages,
                                callback: (val) => setState(() {})
                            ),
                          ]),
                        const SizedBox(height: 25.0),
                        Expanded(child: Container()),
                        Footer(
                            pageSection: RegistrationPageSection.jobBio,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            email: widget.email,
                            password: widget.password,
                            gender: widget.gender,
                            genderPreference: widget.preference,
                            birthdate: widget.birthdate,
                            profilePicture: widget.profilePicture,
                            userInterestIdList: widget.userInterestIdList,
                            location: widget.location,
                            searchRadius: widget.searchRadius,
                            job: widget.job,
                            bio: widget.bio,
                            languages: listValuesToLanguageList(pickedLanguages.selectedOptions),
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

  List<Language> listValuesToLanguageList(List<ValueItem<Language>> valueItems) {
    List<Language> extractedLanguages = [];
    for (ValueItem<Language> item in valueItems) {
      if (item.value != null) {
        extractedLanguages.add(item.value!);
      }
    }
    return extractedLanguages;
  }
}
