import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_gender_preference.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_interests.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_job_bio.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_location.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_radius.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_summary.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../config/theme.dart';
import '../../../../../model/language_model.dart';
import '../../../../../service/login_service.dart';
import '../../../../../service/user_service.dart';
import '../../../controller/registration_controller.dart';
import '../../../enums/registration_page_enum.dart';
import '../../registration_name_email.dart';

typedef void BoolCallBack(bool val, String message);

class NavigationButton extends StatefulWidget {
  const NavigationButton({
    super.key,
    required this.nextPage,
    required this.btnText,

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
    required this.languages,
    required this.callback
  });

  final RegistrationPageSection nextPage;
  final String btnText;

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
  final BoolCallBack callback;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final RegistrationController _controller = RegistrationController();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(116, 50),
          backgroundColor: widget.nextPage != RegistrationPageSection.summary ? _customLoveTheme.primaryColor : (areSkippablePropertiesEmpty() ? _customLoveTheme.linkColor : _customLoveTheme.primaryColor),
          side: BorderSide.none
      ),
      onPressed: () {
        if (widget.nextPage == RegistrationPageSection.submit) {
          Future<void>.value(
              _controller.handleRegistration(
              context,
              widget.firstName,
              widget.lastName,
              widget.email,
              widget.password,
              widget.bio,
              widget.birthdate,
              widget.job,
              widget.location,
              widget.searchRadius,
              widget.gender,
              widget.genderPreference,
              widget.profilePicture,
              widget.userInterestIdList,
              widget.languages
            )
          );
        } else {
          if (widget.nextPage == RegistrationPageSection.genderPreference) {
            // Send HTTP-request to the backend
              if (widget.email != null) {
                if (!isEmailValid(widget.email!)) {
                  widget.callback(false, "Invalid email format, make sure that you entered the right email");
                  return;
                }
                _controller.emailExists(context, widget.email!.trim()).then((value) {
                  if (value) {
                    setState(() {
                      widget.callback(false, "Email already exists, please choose another one");
                    });
                  } else {
                    setState(() {
                      widget.callback(true, "");
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RegistrationGenderPreference(
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          email: widget.email,
                          password: widget.password,
                          gender: widget.gender,
                          preference: widget.genderPreference,
                          birthdate: widget.birthdate,
                          profilePicture: widget.profilePicture,
                          userInterestIdList: widget.userInterestIdList,
                          location: widget.location,
                          searchRadius: widget.searchRadius,
                          job: widget.job,
                          bio: widget.bio,
                          languages: widget.languages,
                        );
                      }));
                    });
                  }
                });
              }
            } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              switch(widget.nextPage) {
                case RegistrationPageSection.login:
                  return LoginPage(
                      loginService: Provider.of<LoginService>(context),
                      userService: Provider.of<UserService>(context)
                  );
                case RegistrationPageSection.location:
                  return RegistrationLocation(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.radius:
                  return RegistrationRadius(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.nameEmail:
                  return RegistrationNameEmail(
                    firstName: widget.firstName != null ? widget.firstName!.trim() : widget.firstName,
                    lastName: widget.lastName != null ? widget.lastName!.trim() : widget.lastName,
                    email: widget.email != null ? widget.email!.trim() : widget.email,
                    password: widget.password != null ? widget.password!.trim() : widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.genderPreference:
                  return RegistrationGenderPreference(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.pictures:
                  return RegistrationPictures(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.interests:
                  return RegistrationInterests(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.jobBio:
                  return RegistrationJobBio(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                case RegistrationPageSection.summary:
                  return RegistrationSummary(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
                default:
                  return RegistrationLocation(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius,
                    job: widget.job,
                    bio: widget.bio,
                    languages: widget.languages,
                  );
              }
            }));
          }
        }
      },
      child: Text(
        widget.nextPage != RegistrationPageSection.summary ? widget.btnText : (areSkippablePropertiesEmpty() ? "Skip" : widget.btnText),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

  bool isEmailValid(String email) {
    return
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool areSkippablePropertiesEmpty() {
    return (widget.bio == null || (widget.bio != null && widget.bio!.isEmpty)) &&
        (widget.job == null || (widget.job != null && widget.job!.isEmpty)) &&
        widget.languages.isEmpty;
  }
}
