import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme.dart';
import '../../../model/language_model.dart';
import '../enums/registration_page_enum.dart';

class RegistrationPictures extends StatefulWidget {
  const RegistrationPictures({
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
  State<RegistrationPictures> createState() => _RegistrationPicturesState();
}

class _RegistrationPicturesState extends State<RegistrationPictures> {
  @override
  void initState() {
    super.initState();
    registrationImageXFile = widget.profilePicture;
    setProfileImage(registrationImageXFile);
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  XFile? registrationImageXFile;
  Uint8List? registrationImage;

  Future<Uint8List?> galleryImagePicker(ImageSource imageSource) async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
      source: imageSource,
      imageQuality: 90,
    );
    registrationImageXFile = file;

    if (file != null) return await file.readAsBytes(); // convert into Uint8List.
    return null;
  }

  void setProfileImage(XFile? file) async {
    if (file != null) {
      Uint8List img = await file.readAsBytes();
      setState(() {
        registrationImage = img;
      });
    }
  }

  void _updateColor(PointerEvent details) {
    setState(() {
      tmpColor = _customLoveTheme.grayscale1;
    });
  }

  void _exitColor(PointerEvent details) {
    setState(() {
      tmpColor = _customLoveTheme.grayscale0;
    });
  }

  var tmpColor = const CustomLoveTheme().grayscale0;

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
                            title: "Profile Pictures",
                            description: "Provide a profile picture of yourself",
                            bottomPadding: 45.0,
                          ),
                          if (registrationImage == null)
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onHover: _updateColor,
                                  onExit: _exitColor,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.transparent
                                        ),
                                    ),
                                    onPressed: () async {
                                      final Uint8List? image = await galleryImagePicker(ImageSource.gallery);

                                      if (image != null) {
                                        setState(() {
                                          registrationImage = image;
                                        });
                                      }
                                    },
                                    child: AnimatedContainer(
                                      width: 300,
                                      height: 300,
                                        decoration: BoxDecoration(
                                          color: tmpColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(Icons.add_a_photo, size: 40, color: _customLoveTheme.textColor,),
                                    ),
                                  ),
                                ),

                          if (registrationImage != null)
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AnimatedContainer(
                                  height: 300,
                                  width: 300,
                                  duration: const Duration(milliseconds: 200),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.memory (
                                      registrationImage!,
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: -10,
                                    left: 265,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                        onPressed: (){
                                          setState(() {
                                            registrationImageXFile = null;
                                            registrationImage = null;
                                          });
                                        },
                                        icon: Icon(Icons.delete, size: 20, color: _customLoveTheme.whiteColor),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          const SizedBox(height: 25.0),
                          Expanded(child: Container()),
                          Footer(
                            pageSection: RegistrationPageSection.pictures,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            email: widget.email,
                            password: widget.password,
                            gender: widget.gender,
                            genderPreference: widget.preference,
                            birthdate: widget.birthdate,
                            profilePicture: registrationImageXFile,
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
