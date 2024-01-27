import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/enums/registration_page_enum.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/theme.dart';
import '../../../model/language_model.dart';

class RegistrationNameEmail extends StatefulWidget {
  const RegistrationNameEmail({
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
  State<RegistrationNameEmail> createState() => _RegistrationNameEmailState();
}

class _RegistrationNameEmailState extends State<RegistrationNameEmail> {
  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    emailController = widget.email;
    passwordController = widget.password;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  late String? firstName;
  late String? lastName;
  late String? emailController;
  late String? passwordController;

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
                        title: "Profile Name",
                        description: "Provide your first name and last name",
                        bottomPadding: 70.0,
                      ),
                      // Name
                      RegistrationTextfield(
                        controller: firstName,
                        hintText: "First Name",
                        obscureText: false,
                        callback: (val) => setState(() => firstName = val)
                      ),
                      const SizedBox(height: 19.0),
                      RegistrationTextfield(
                        controller: lastName,
                        hintText: "Last Name",
                        obscureText: false,
                        callback: (val) => setState(() => lastName = val),
                      ),
                      const SizedBox(height: 19.0),
                      // Email
                      RegistrationTextfield(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                        callback: (val) => setState(() => emailController = val),
                      ),
                      const SizedBox(height: 19.0),
                      // Email
                      RegistrationTextfield(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                        callback: (val) => setState(() => passwordController = val),
                      ),
                      const SizedBox(height: 25.0),
                      Expanded(child: Container()),
                      Footer(
                          pageSection: RegistrationPageSection.nameEmail,
                          firstName: firstName,
                          lastName: lastName,
                          email: emailController,
                          password: passwordController,
                          gender: widget.gender,
                          genderPreference: widget.preference,
                          birthdate: widget.birthdate,
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
      ));
  }
}
