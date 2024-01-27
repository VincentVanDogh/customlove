import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/enums/registration_page_enum.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme.dart';
import '../../../model/language_model.dart';

class RegistrationRadius extends StatefulWidget {
  const RegistrationRadius({Key? key,
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
  State<RegistrationRadius> createState() => _RegistrationRadiusState();
}

class _RegistrationRadiusState extends State<RegistrationRadius> {
  @override
  void initState() {
    super.initState();
    searchRadius = widget.searchRadius ?? 5;
    searchRadiusMiles = searchRadius != null ? (searchRadius! * 0.621371).roundToDouble() : 1;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final logger = Logger();

  // Default searchRadius is in km
  late double? searchRadius;
  late double? searchRadiusMiles;
  late void Function() setFooterParams;

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
                          title: "Matching Radius",
                          description: "Set your radius for potential Matches",
                          bottomPadding: 70.0,
                        ),
                        const SizedBox(height: 15.0),
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: TextStyle(
                                  color: _customLoveTheme.primaryColor,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: searchRadius!.toString()),
                                  TextSpan(
                                      text: '  kilometers',
                                      style: TextStyle(
                                          color: _customLoveTheme.textColor)
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: TextStyle(
                                    color: _customLoveTheme.primaryColor,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: searchRadiusMiles.toString()),
                                  TextSpan(
                                      text: searchRadiusMiles != 1 ? '  miles' : '  mile',
                                      style: TextStyle(
                                          color: _customLoveTheme.textColor)
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 50.0),
                            Slider(
                                min: 5,
                                max: 100,
                                divisions: 99,
                                label: searchRadius!.toString(),
                                value: searchRadius!,
                                activeColor: _customLoveTheme.primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    searchRadius = value.roundToDouble();
                                    searchRadiusMiles = (value * 0.621371).roundToDouble();
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        Expanded(child: Container()),
                        Footer(
                            pageSection: RegistrationPageSection.radius,
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
