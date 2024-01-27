import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/controller/registration_controller.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/summary_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme.dart';
import '../../../model/language_model.dart';
import '../enums/registration_page_enum.dart';

class RegistrationSummary extends StatefulWidget {
  const RegistrationSummary({Key? key,
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
  final String? job;
  final String? bio;
  final List<Language> languages;

  @override
  State<RegistrationSummary> createState() => _RegistrationSummaryState();
}

class _RegistrationSummaryState extends State<RegistrationSummary> {
  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    email = widget.email;
    password = widget.password;
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
    userLocation = widget.location;
    searchRadius = widget.searchRadius ?? 1;
  }

  final logger = Logger();
  final RegistrationController _controller = RegistrationController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late Gender? gender;
  late List<Gender> preference;
  late String? birthdate;
  XFile? profilePicture;
  late List<Interest> userInterestIdList;
  Position? userLocation;
  late double? searchRadius;

  String genderListToString(List<Gender> genders) {
    if (genders.isEmpty) {
      return "";
    }
    String genderStr = "";
    for (Gender gender in genders) {
      genderStr +=  "${gender.name}, ";
    }
    return genderStr.substring(0, genderStr.length - 2);
  }

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
                      children: <Widget>[
                        const PageTitle(
                          title: "Profile Summary",
                          description: "Please check if your profile details are correct",
                          bottomPadding: 70.0,
                        ),
                        const SizedBox(height: 15.0),
                        // registration_name_email
                        SummaryTextfield(label: "First name", input: firstName!),
                        SummaryTextfield(label: "Last name", input: lastName!),
                        SummaryTextfield(label: "Email", input: email!),

                        // registration_gender_preference
                        SummaryTextfield(label: "Gender Identity", input: gender!.name),
                        SummaryTextfield(label: "Gender Preferences", input: genderListToString(preference)),
                        SummaryTextfield(label: "Birthdate", input: birthdate!),

                        // registration_radius
                        SummaryTextfield(label: "Search Radius", input: "$searchRadius km / ${(searchRadius! * 0.621371).roundToDouble()} mi"),

                        SummaryTextfield(label: "Interests", input: _controller.interestsListToString(userInterestIdList)),

                        // registration_job_bio + languages
                        SummaryTextfield(label: "Job", input: widget.job == null ? "" : widget.job!),
                        SummaryTextfield(label: "Bio", input: widget.bio == null ? "" : widget.bio!),
                        SummaryTextfield(label: "Languages", input: _controller.languageListToString(widget.languages)),
                        const SizedBox(height: 25.0),
                        Expanded(child: Container()),
                        Footer(
                            pageSection: RegistrationPageSection.summary,
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password,
                            gender: gender,
                            genderPreference: preference,
                            birthdate: birthdate,
                            profilePicture: profilePicture,
                            userInterestIdList: userInterestIdList,
                            location: userLocation,
                            searchRadius: searchRadius,
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
        ));
  }
}
