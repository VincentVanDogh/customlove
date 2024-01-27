import 'package:frontend/src/app/api/registration_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationService {
  final RegistrationApi _registrationApi;

  RegistrationService(this._registrationApi);

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    try {
      final body = _registrationApi.getUserByEmail(email);
      return body;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> registerTo(
      String firstName,
      String lastName,
      String email,
      String password,
      String bio,
      String birthdate,
      String job,
      Position location,
      int searchRadius,
      int genderIdentityId,
      List<int> genderPreferenceIds,
      XFile? profilePicture,
      List<int> userInterestIdSet,
      List<int> languageIdSet
    ) async {
    try {
      final body = _registrationApi.registerUser(
          firstName,
          lastName,
          email,
          password,
          bio,
          birthdate,
          job,
          location,
          searchRadius,
          genderIdentityId,
          genderPreferenceIds,
          profilePicture,
          userInterestIdSet,
          languageIdSet
      );
      return body;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
