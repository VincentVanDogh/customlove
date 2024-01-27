import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme.dart';
import '../../../model/language_model.dart';
import '../../../api/helpers/jwt_api.dart';
import '../../../service/location_service.dart';
import '../../loading_screen/loading_screen.dart';
import '../enums/registration_page_enum.dart';

class RegistrationLocation extends StatefulWidget {
  const RegistrationLocation({
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
  State<RegistrationLocation> createState() => _RegistrationLocationState();
}

class _RegistrationLocationState extends State<RegistrationLocation> {
  @override
  void initState() {
    super.initState();
    getAccessToken().then((token){
      if (token != null) {
        Navigator.pushNamed(context, '/home/swipe');
      }
    });

    checkLocationPermission();
    userLocation = widget.location;
  }

  Future<String?> getAccessToken() async {
    try {
      return await JWTApi.retrieveAccessToken();
    } catch (e) {
      setState(() {
        _userLoggedIn = false;
      });
      return null;
    }
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LocationService _locationService = LocationService();
  final logger = Logger();

  Position? userLocation; bool userLocationDefined = false;
  bool? _userLoggedIn;

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      userLocationDefined = true;
    }
    if (permission == LocationPermission.denied) {
      await requestLocationPermission();
    } else {
      saveCurrentLocation();
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      saveCurrentLocation();
    } else {
      setState(() {
        userLocationDefined = true;
      });
      logger.e("Location permission is denied.");
    }
  }

  Future<void> saveCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        userLocation = position;
        userLocationDefined = true;
      });

      var location = await _locationService.getCurrentLocation(
          position.latitude, position.longitude);
      logger.i("Current user location: $location");
    } catch (e) {
      logger.e("Error getting current location: $e");
    }
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
                scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: <Widget>[
                        const PageTitle(
                          title: "Profile Location",
                          description: "Please specify your current location",
                          bottomPadding: 70.0,
                        ),
                        Stack(
                          children: [
                            Icon(Icons.map, size: 150, color: _customLoveTheme.textColor),
                            Positioned(
                              bottom: userLocationDefined ? 0 : 12,// 0,
                              right: userLocationDefined ? -10 : 2, // -10,
                              child: userLocationDefined == false ?
                                const CircularProgressIndicator(strokeWidth: 7) :
                              (userLocation == null ?
                                Icon(Icons.close, size: 80, color: _customLoveTheme.redColor) :
                                Icon(Icons.check, size: 80, color: _customLoveTheme.androidGreen)
                              )
                              ,
                            )
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          userLocationDefined == false ?
                              'Please allow your device to access your location' :
                              (userLocation == null ?
                              'You denied the app access to your location, please set the access to your location to enabled and reload the page' :
                              'Your location is specified'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _customLoveTheme.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Expanded(child: Container()),
                        Footer(
                            pageSection: RegistrationPageSection.location,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            email: widget.email,
                            password: widget.password,
                            gender: widget.gender,
                            genderPreference: widget.preference,
                            birthdate: widget.birthdate,
                            profilePicture: widget.profilePicture,
                            userInterestIdList: widget.userInterestIdList,
                            location: userLocation,
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
        )

    );
  }

  OutlinedButton requestLocationButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.androidGreen,
          side: BorderSide.none
      ),
      onPressed: () {
        setState(() {
          requestLocationPermission();
        });
        },
      child: const Text(
        "Request Location Access",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
