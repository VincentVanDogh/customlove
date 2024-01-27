import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/loading_screen/loading_screen.dart';
import 'package:frontend/src/app/service/location_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/components/login_textfield.dart';
import 'package:frontend/src/app/presentation/authentification/components/sign_in_button.dart';
import 'package:frontend/src/app/presentation/authentification/controller/login_controller.dart';
import 'package:frontend/src/app/service/login_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

import '../../../api/helpers/jwt_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
      {Key? key,
      required LoginService loginService,
      required UserService userService})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _controller = LoginController();
  final LocationService _locationService = LocationService();
  final logger = Logger();
  bool? _userLoggedIn;

  @override
  void initState() {
    super.initState();
    getAccessToken().then((token){
      if (token != null) {
        Navigator.pushNamed(context, '/home/swipe');
      }
    });
    checkLocationPermission();
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
  
  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
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
      logger.e("Location permission is denied.");
    }
  }

  Future<void> saveCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _controller.userLocation = position;

      var location = await _locationService.getCurrentLocation(
          position.latitude, position.longitude);
      logger.i("Current user location: $location");
    } catch (e) {
      logger.e("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _userLoggedIn == null ? const LoadingScreen() : Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'CUSTOMLOVE',
                      style: GoogleFonts.teko(
                        textStyle: TextStyle(
                          height: 0.6,
                          color: _customLoveTheme.primaryColor,
                          fontSize: 60,
                        ),
                      ),
                    ),
                    Text(
                      'Next Level Dating for Everybody',
                      style: GoogleFonts.teko(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                // logo
                Container(
                  height: 100,
                  child: Image.asset(
                    'lib/src/icons/handshake.png',
                    color: _customLoveTheme.primaryColor,
                  ),
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: _customLoveTheme.primaryColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                LoginTextField(
                  key: const Key('emailTextField'),
                  controller: _controller.emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                LoginTextField(
                  key: const Key('passwordTextField'),
                  controller: _controller.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 25),

                // sign in button
                LoginButton(
                  onTap: () {
                    Future<void>.value(_controller.handleLogin(context));
                  },
                  color: _customLoveTheme.primaryColor,
                  text: "Sign In",
                ),
                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style:
                              TextStyle(color: _customLoveTheme.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: _customLoveTheme.primaryColor),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/registration");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
