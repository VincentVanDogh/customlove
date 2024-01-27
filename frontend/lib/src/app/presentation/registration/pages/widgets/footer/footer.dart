import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/enums/registration_page_enum.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../config/theme.dart';
import '../../../../../model/language_model.dart';
import 'navigation_button.dart';

class Footer extends StatefulWidget {
  Footer({
    super.key,
    required this.pageSection,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.genderPreference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList,
    required this.location,
    required this.searchRadius,
    required this.job,
    required this.bio,
    required this.languages
  });

  final RegistrationPageSection pageSection;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final Gender? gender;
  final List<Gender> genderPreference;
  final String? birthdate;
  final XFile? profilePicture;
  final List<Interest> userInterestIdList;
  final Position? location;
  final double? searchRadius;
  final String? job;
  final String? bio;
  final List<Language> languages;
  late bool nextButtonAllowed = true;
  late String warningMsg;

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.nextButtonAllowed)
          Text(
            widget.warningMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _customLoveTheme.redColor,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 30.0),

        Center(
          child: Row(
            children: [
              NavigationButton(
                  nextPage: widget.pageSection.predecessor,
                  btnText: widget.pageSection.predecessor != RegistrationPageSection.login ? 'Previous' : 'Login',
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  email: widget.email,
                  password: widget.password,
                  gender: widget.gender,
                  genderPreference: widget.genderPreference,
                  birthdate: widget.birthdate,
                  profilePicture: widget.profilePicture,
                  userInterestIdList: widget.userInterestIdList,
                  location: widget.location,
                  searchRadius: widget.searchRadius,
                  job: widget.job,
                  bio: widget.bio,
                  languages: widget.languages,
                  callback: (val, msg) => setState(() {
                    widget.nextButtonAllowed = val;
                    widget.warningMsg = msg;
                  })
              ),
              const Spacer(),
              if (evaluateBtnAccessibility())
                NavigationButton(
                    nextPage: widget.pageSection.successor,
                    btnText: widget.pageSection.successor != RegistrationPageSection.submit ? 'Next' : 'Submit',
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    genderPreference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                    callback: (val, msg) => setState(() {
                      widget.nextButtonAllowed = val;
                      widget.warningMsg = msg;
                    })
                ),
              if (!evaluateBtnAccessibility())
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _customLoveTheme.grayscale1,
                    foregroundColor: _customLoveTheme.textColor,
                    minimumSize: const Size(156, 56),
                  ),
                  onPressed: () {  },
                  child: const Text("Next"),
                )
            ],
          ),
        ),
        const SizedBox(height: 30.0),
        Center(
            child: Column(
              children: [
                InkWell(
                  child: Text(
                    'Return to Login',
                    style: TextStyle(
                      color: _customLoveTheme.linkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    if (await _onLoginButtonPressed(context)) {
                      Navigator.pushNamed(context, "/");
                    }
                  },
                ),
                const SizedBox(height: 30)
              ],
            )
        )
      ],
    );
  }
  
  bool evaluateBtnAccessibility() {
    switch(widget.pageSection) {
      case RegistrationPageSection.location:
        return widget.location != null;
      case RegistrationPageSection.radius:
        return widget.searchRadius != null;
      case RegistrationPageSection.nameEmail:
        return widget.firstName != null &&
            widget.firstName!.trim().isNotEmpty &&
            widget.lastName != null && 
            widget.lastName!.trim().isNotEmpty &&
            widget.lastName != null &&
            widget.email != null &&
            widget.email!.trim().isNotEmpty &&
            widget.password != null &&
            widget.password!.trim().isNotEmpty &&
            widget.nextButtonAllowed;
      case RegistrationPageSection.genderPreference:
        return widget.gender != null && 
            widget.genderPreference.isNotEmpty &&
            widget.birthdate != null;
      case RegistrationPageSection.pictures:
        return widget.profilePicture != null;
      case RegistrationPageSection.interests:
        return widget.userInterestIdList.length >= 3 &&
            widget.userInterestIdList.length <= 5;
      case RegistrationPageSection.jobBio:
        // Not mandatory, therefore left true
        return true;
      case RegistrationPageSection.summary:
        return true;
      default:
        return false;
    }
  }
  
  Future<bool> _onLoginButtonPressed(BuildContext context) async {
    bool returnToLogin = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Return to login"),
            content: const Text("Are you sure you want to return to login? All your progress will be lost"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false), 
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: _customLoveTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    )
                  )
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                      "Yes",
                      style: TextStyle(
                          color: _customLoveTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      )
                  )
              )
            ],
          );
        }
    );
    return returnToLogin;
  }
}
