import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/model/language_model.dart';
import 'package:frontend/src/app/model/user_detailed.dart';
import 'package:frontend/src/app/presentation/authentification/components/sign_in_button.dart';
import 'package:frontend/src/app/presentation/profile/controller/profile_controller.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_checkboxes/dropdown_checkbox.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_checkboxes/interest_dropdown_checkbox.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../config/app_state.dart';
import '../../../../config/theme.dart';
import '../../../service/image_service.dart';
import '../../authentification/controller/login_controller.dart';
import '../../registration/pages/widgets/bio_textfield.dart';
import '../../registration/pages/widgets/dropdown_checkboxes/language_dropdown_checkbox.dart';
import '../../registration/pages/widgets/textfield.dart';
import '../../utils/secure_storage_service.dart';

class Profile extends StatefulWidget {
  final UserService userService;

  const Profile({Key? key, required this.userService}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  ImageService? _service;
  ProfileImageStorage? _storage;
  final LoginController _logoutController = LoginController();
  final ProfileController _profileController = ProfileController();

  Future<void> getProfilePicture() async {
    if (user != null) {
      if (_service == null ||
          _storage == null ||
          _storage!.loaded(user!.profilePictureId)) {
        return;
      }

      var tmp = await _service!.getImage("profile-picture/${user!.id}");
      _storage!.load(user!.profilePictureId, tmp);
    }
  }

  void getUsers() async {
    String accessToken = await _secureStorageService.retrieveAccessToken() as String;
    await _secureStorageService.retrieveUserId().then((id) {
      widget.userService.getUserProfile(accessToken, int.parse(id!)).then((value) {
        setState(() {
          user = value['user'];
          genderDto = value['genders'];
          for (Gender gender in genderDto) {
            genderPreferences.options.add(
                ValueItem(label: gender.name, value: gender)
            );
          }
          for (Gender preference in user!.genderPreferences) {
            genderPreferences.addSelectedOption(
                ValueItem<Gender>(label: preference.name, value: preference)
            );
          }

          interestDto = value['interests'];
          for (Interest interest in interestDto) {
            interests.options.add(
                ValueItem(label: interest.name, value: interest)
            );
          }
          for (Interest interest in user!.interests) {
            interests.addSelectedOption(
                ValueItem<Interest>(label: interest.name, value: interest)
            );
          }

          languageDto = value['languages'];
          for (Language language in languageDto) {
            languages.options.add(
                ValueItem(label: language.name, value: language)
            );
          }
          for (Language language in user!.languages) {
            languages.addSelectedOption(
                ValueItem<Language>(label: language.name, value: language)
            );
          }
          bio = user!.bio;
          job = user!.job;
          searchRadius = user!.searchRadius < 5 ? 5 : (user!.searchRadius > 100 ? 100 : user!.searchRadius);
        });
      });
    });
  }

  final SecureStorageService _secureStorageService = SecureStorageService();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  UserDetailed? user;

  // Property values
  List<Gender> genderDto = [];
  List<Interest> interestDto = [];
  List<Language> languageDto = [];

  // Editable attributes
  bool warning = false;
  MultiSelectController<Gender> genderPreferences = MultiSelectController<Gender>();
  int searchRadius = 5;
  MultiSelectController<Interest> interests = MultiSelectController<Interest>();
  String bio = "";
  String job = "";
  MultiSelectController<Language> languages = MultiSelectController<Language>();

  XFile? profileImageNewXFile;
  Uint8List? profileImageNewUint;

  Future<Uint8List?> galleryImagePicker(ImageSource imageSource) async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
      source: imageSource,
      imageQuality: 90,
    );
    profileImageNewXFile = file;

    if (file != null) return await file.readAsBytes(); // convert into Uint8List.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<ImageService>(context);
    _storage = Provider.of<ProfileImageStorage>(context);
    getProfilePicture();

    Consumer<ProfileImageStorage> img = Consumer<ProfileImageStorage>(
      builder:
          (BuildContext context, ProfileImageStorage storage, Widget? child) {
        int id = user!.profilePictureId;

        if (!storage.loaded(id)) {
          return const Icon(Icons.downloading);
        }

        return Stack(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 4, color: _customLoveTheme.whiteColor),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1)
                  )
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(
                    profileImageNewUint == null ? storage.getBytes(id)! : profileImageNewUint!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ).image
                )
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: ()  async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Upload image'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("Choose the upload source"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final Uint8List? image = await galleryImagePicker(ImageSource.gallery);

                                  if (image != null) {
                                    _service?.putImage(profileImageNewXFile!, 'profile-picture');
                                    _storage!.load(user!.profilePictureId, image);
                                    setState(() {
                                      profileImageNewUint = image;
                                    });
                                  }
                                },
                                child: const Text("From Gallery")
                              ),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    final Uint8List? image = await galleryImagePicker(ImageSource.camera);

                                    if (image != null) {
                                      _service?.putImage(profileImageNewXFile!, 'profile-picture');
                                      _storage!.load(user!.profilePictureId, image);
                                      setState(() {
                                        profileImageNewUint = image;
                                      });
                                    }
                                  },
                                  child: const Text("From Camera")
                              ),
                            ]);
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: _customLoveTheme.primaryColor,
                    minimumSize: const Size(40, 40)
                  ),
                  child: Icon(
                    Icons.edit,
                    color: _customLoveTheme.whiteColor,
                  ),
                )
            )
          ],
        );
      },
    );

    return Scaffold(
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
                      Expanded(child: Container()),
                      if (user == null)
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                                color: _customLoveTheme.primaryColor,
                                strokeWidth: 18
                            )
                        ),
                      const SizedBox(height: 120),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (user != null)
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _customLoveTheme.neutralColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(children: [
                                  SizedBox(height: 80,),
                                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        user!.firstName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 36,
                                          color: _customLoveTheme.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        user!.email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: _customLoveTheme.textColor
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        "Born ${europeanDobFormat(user!.dateOfBirth)}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _customLoveTheme.textColor
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        "Identifies as ${user!.genderIdentity.name}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _customLoveTheme.textColor
                                        ),
                                      ),
                                    ],),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${user!.swipesLeft}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: _customLoveTheme.primaryColor
                                          ),
                                        ),
                                        Text(
                                          "Swipes remaining${user!.swipesLeft == 0 ? "\nResets ${user!.swipeLimitResetDate}" : ""}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: _customLoveTheme.textColor
                                          ),
                                        ),
                                      ],)
                                  ],
                                  ),
                                  const SizedBox(height: 25.0),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Search radius: $searchRadius km, ${(searchRadius * 0.621371).roundToDouble()} mi",
                                          textAlign: TextAlign.left
                                      ),
                                      Slider(
                                          min: 5,
                                          max: 100,
                                          divisions: 99,
                                          label: searchRadius.toString(),
                                          value: searchRadius.toDouble(),
                                          activeColor: _customLoveTheme.primaryColor,
                                          onChanged: (value) {
                                            setState(() {
                                              searchRadius = value.toInt();
                                            });
                                          }),
                                    ],
                                  ),
                                  RegistrationBioTextfield(
                                      controller: bio,
                                      hintText: "Bio",
                                      characterLimit: 256,
                                      maxLines: 1,
                                      callback: (val) => setState(() => bio = val)
                                  ),
                                  const SizedBox(height: 25.0),
                                  RegistrationTextfield(
                                      controller: job,
                                      hintText: "Job",
                                      obscureText: false,
                                      callback: (val) => setState(() => job = val)
                                  ),
                                  const SizedBox(height: 19.0),
                                  DropdownCheckbox(
                                      pickedGenderPreferences: genderPreferences,
                                      callback: (val) => setState(() {})
                                  ),
                                  const SizedBox(height: 19.0),
                                  LanguageDropdownCheckbox(
                                      pickedLanguages: languages,
                                      callback: (val) => setState(() {})
                                  ),
                                  const SizedBox(height: 19.0),
                                  InterestDropdownCheckbox(
                                      pickedInterests: interests,
                                      callback: (val) => setState(() {})
                                  ),
                                  const SizedBox(height: 25.0),
                                  if (interests.selectedOptions.length < 3 || interests.selectedOptions.length > 5)
                                    Text(
                                      "You need to have 3 - 5 interests",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: _customLoveTheme.redColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  if (genderPreferences.selectedOptions.isEmpty)
                                    Text(
                                      "You need to provide at least one gender preference",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: _customLoveTheme.redColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  if (genderPreferences.selectedOptions.isNotEmpty && interests.selectedOptions.length >= 3 && interests.selectedOptions.length <=5)
                                    ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(25.0),
                                      backgroundColor: _customLoveTheme.primaryColor,
                                      foregroundColor: _customLoveTheme.whiteColor,
                                      shape: StadiumBorder(
                                          side: BorderSide(
                                              width: 2,
                                              color:  _customLoveTheme.whiteColor
                                          )
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (interests.selectedOptions.length >= 3 && interests.selectedOptions.length <= 5) {
                                        UserDetailed? result = await _profileController.updateUser(
                                            context,
                                            job,
                                            bio,
                                            listValuesToGenderList(genderPreferences.selectedOptions),
                                            listValuesToInterestList(interests.selectedOptions),
                                            listValuesToLanguageList(languages.selectedOptions),
                                            searchRadius
                                        );
                                        setState(() {
                                          user = result;
                                        });
                                      }
                                    },
                                    child: const Text('Confirm changes'),
                                  ),
                                  /*
                                  Row(children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(25.0),
                                        backgroundColor: _customLoveTheme.primaryColor,
                                        foregroundColor: _customLoveTheme.whiteColor,
                                        shape: StadiumBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color:  _customLoveTheme.whiteColor
                                            )
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (interests.selectedOptions.length >= 3 && interests.selectedOptions.length <= 5) {
                                          UserDetailed? result = await _profileController.updateUser(
                                              context,
                                              job,
                                              bio,
                                              listValuesToGenderList(genderPreferences.selectedOptions),
                                              listValuesToInterestList(interests.selectedOptions),
                                              listValuesToLanguageList(languages.selectedOptions),
                                              searchRadius
                                          );
                                          setState(() {
                                            user = result;
                                          });
                                        }
                                      },
                                      child: const Text('Confirm changes'),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(25.0),
                                        backgroundColor: _customLoveTheme.whiteColor,
                                        foregroundColor: _customLoveTheme.primaryColor,
                                        shape: StadiumBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color:  _customLoveTheme.primaryColor
                                            )
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          print("HERE");
                                          print(job);
                                          print(user!.job);
                                          bio = user!.bio;
                                          job = user!.job;
                                          genderPreferences.selectedOptions.clear();
                                          interests.selectedOptions.clear();
                                          languages.selectedOptions.clear();

                                          print(job);
                                          for (Gender preference in user!.genderPreferences) {
                                            genderPreferences.addSelectedOption(
                                                ValueItem<Gender>(label: preference.name, value: preference)
                                            );
                                          }
                                          for (Interest interest in user!.interests) {
                                            interests.addSelectedOption(
                                                ValueItem<Interest>(label: interest.name, value: interest)
                                            );
                                          }
                                          for (Language language in user!.languages) {
                                            languages.addSelectedOption(
                                                ValueItem<Language>(label: language.name, value: language)
                                            );
                                          }
                                        });
                                      },
                                      child: const Text('Discard changes'),
                                    ),

                                  ],)
                                  */
                                ]),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                          if (user != null)
                            Positioned(child: img, left: MediaQuery.of(context).size.width >= 550 ? 150 : (MediaQuery.of(context).size.width/2) - 125, top: -100,),
                        ],
                      ),

                      Expanded(child: Container()),
                      SizedBox(height: 20,),
                      LoginButton(
                          onTap: () {
                            Future<void>.value(_logoutController.handleLogout(context));
                          },
                          color: _customLoveTheme.primaryColor,
                          text: "Logout"
                      ),
                      const SizedBox(height: 30.0)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> listValuesToLanguageList(List<ValueItem<Language>> valueItems) {
    List<int> extractedLanguages = [];
    for (ValueItem<Language> item in valueItems) {
      if (item.value != null) {
        extractedLanguages.add(item.value!.id);
      }
    }
    return extractedLanguages;
  }

  List<int> listValuesToGenderList(List<ValueItem<Gender>> valueItems) {
    List<int> extractedGenders = [];
    for (ValueItem<Gender> item in valueItems) {
      if (item.value != null) {
        extractedGenders.add(item.value!.id);
      }
    }
    return extractedGenders;
  }

  List<int> listValuesToInterestList(List<ValueItem<Interest>> valueItems) {
    List<int> extractedInterests = [];
    for (ValueItem<Interest> item in valueItems) {
      if (item.value != null) {
        extractedInterests.add(item.value!.id);
      }
    }
    return extractedInterests;
  }

  String europeanDobFormat(String input) {
    return "${input.substring(8, 10)}.${input.substring(5, 7)}.${input.substring(0, 4)}";
  }
}
