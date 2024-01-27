import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/interest_button.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/service/interest_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme.dart';
import '../../../../config/widgets/exception_widget.dart';
import '../../../model/language_model.dart';
import '../enums/registration_page_enum.dart';

class RegistrationInterests extends StatefulWidget {
  const RegistrationInterests({
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
  final String? job;
  final String? bio;
  final List<Language> languages;

  @override
  State<RegistrationInterests> createState() => _RegistrationInterestsState();
}

class _RegistrationInterestsState extends State<RegistrationInterests> {
  @override
  void initState() {
    super.initState();
    userInterestIdList = widget.userInterestIdList;
    interestCounter = userInterestIdList.length;
    getInterests();
  }

  void getInterests() async {
    try {
      await _interestService.getInterests().then((value) {
        setState(() {
          interestDto = value;
        });
      });
    } catch (e) {
      setState(() {
        httpError = true;
      });
    }
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final InterestService _interestService = InterestService();
  late List<Interest> userInterestIdList = [];
  late List<Interest> interestDto = [];
  late bool httpError = false;
  int minInterests = 3;
  int maxInterests = 5;
  int interestCounter = 0;

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
                      title: "Your interests",
                      description: "Select 3 to 5 interests you're passionate about",
                      bottomPadding: 49.0
                  ),
                  if (httpError)
                    const ExceptionWidget(
                        httpStatus: "503",
                        httpMessage: "Make sure that the backend is running"
                    ),
                  if (interestDto.isEmpty && !httpError)
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          color: _customLoveTheme.primaryColor,
                          strokeWidth: 18
                        )
                    ),
                  if (interestDto.isNotEmpty)
                  for (int i = 0; i < interestDto.length; i += 2)
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InterestButton(
                                      interest: interestDto[i],
                                      containsInterestFunction: containsInterest,
                                      addRemoveInterestFunction: addRemoveInterest
                                  ),
                                ),
                                const SizedBox(width: 20),
                                if (i + 1 < interestDto.length)
                                  Expanded(
                                  child: InterestButton(
                                    interest: interestDto[i + 1],
                                    containsInterestFunction: containsInterest,
                                      addRemoveInterestFunction: addRemoveInterest
                                  ),
                                ) else Expanded(child: Container()),
                              ],
                            ),
                      ),
                    ),
                  const SizedBox(height: 25.0),
                  RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: TextStyle(
                          color: interestCounter < 3 || interestCounter > 5 ? _customLoveTheme.redColor : _customLoveTheme.primaryColor,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '$interestCounter',
                            style: TextStyle(
                                color: interestCounter < minInterests || interestCounter > maxInterests ?
                                _customLoveTheme.redColor :
                                _customLoveTheme.tertiaryColor
                            )
                        ),
                        TextSpan(text: ' / ', style: TextStyle(color: _customLoveTheme.textColor)),
                        TextSpan(text: '$maxInterests', style: TextStyle(color: _customLoveTheme.tertiaryColor)),
                        TextSpan(
                            text: ' interests selected',
                            style: TextStyle(
                                color: _customLoveTheme.textColor
                            )
                        )
                      ],
                    ),
                  ),
                  if (interestCounter < minInterests || interestCounter > maxInterests)
                    RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                            color: _customLoveTheme.redColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Please select ${interestCounter < minInterests ? 'at least 3 interests' : (interestCounter > maxInterests ? 'at most 5 interests' : '3-5 interests')}')
                        ],
                      ),
                    ),
                  const SizedBox(height: 25.0),
                  Expanded(child: Container()),
                  Footer(
                      pageSection: RegistrationPageSection.interests,
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      email: widget.email,
                      password: widget.password,
                      gender: widget.gender,
                      genderPreference: widget.preference,
                      birthdate: widget.birthdate,
                      profilePicture: widget.profilePicture,
                      userInterestIdList: userInterestIdList,
                      location: widget.location,
                      searchRadius: widget.searchRadius,
                      job: widget.job,
                      bio: widget.bio,
                      languages: widget.languages
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

  bool containsInterest(Interest interest) {
    return userInterestIdList.contains(interest);
  }

  void addRemoveInterest(Interest interest) {
    if (containsInterest(interest)) {
      userInterestIdList.removeWhere((thisInterest) => interest.id == thisInterest.id);
      setState(() {
        interestCounter--;
      });
    } else {
      userInterestIdList.add(interest);
      setState(() {
        interestCounter++;
      });
    }
  }
}
