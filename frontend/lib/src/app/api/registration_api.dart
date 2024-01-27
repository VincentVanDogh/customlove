import 'dart:convert';
import 'package:frontend/src/app/exceptions/not_found_exception.dart';
import 'package:frontend/src/config/exceptions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';



class RegistrationApi {
  final http.Client httpClient;

  RegistrationApi({required this.httpClient});

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final response = await httpClient.get(
        Uri.parse('${ApiConfig.baseUrl}/users/email/$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 422) {
      throw NotFoundException("User with email $email does not exist");
    } else {
      throw Exception('Error during user-retrieval based on their email');
    }
  }

  Future<Map<String, dynamic>> registerUser(
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
      List<int> interests,
      List<int> languages
      ) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${ApiConfig.baseUrl}/users/'));

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['bio'] = bio;
    request.fields['date_of_birth'] = birthdate;
    request.fields['job'] = job;
    request.fields['search_radius'] = searchRadius.toString();
    request.fields['gender_identity_id'] = genderIdentityId.toString();
    request.fields['gender_preference_ids'] = genderPreferenceIds.toString();
    request.fields['longitude'] = location.longitude.toString();
    request.fields['latitude'] = location.latitude.toString();
    request.fields['interest_ids'] = interests.toString();
    request.fields['matching_algorithm'] = 1.toString();
    request.fields['language_ids'] = languages.toString();

    var bytes = await profilePicture!.readAsBytes();
    var stream = http.ByteStream(DelegatingStream(profilePicture.openRead()));
    var length = bytes.length;
    var type = MimeTypeResolver().lookup(profilePicture.name);

    request.files.add(
        http.MultipartFile(
            'profile_picture',
            stream,
            length,
            filename: profilePicture.name,
            contentType: type == null ? null : MediaType.parse(type)
        )
    );


    request.headers.addAll({
      'Content-Type': 'application/json',
      'accept': 'application/json'
    });
    http.StreamedResponse streamedResponse = await httpClient.send(request);
    final http.Response response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 422) {
      throw InvalidRegistrationInputsException();
    } else {
      throw Exception('Error during Registration');
    }
  }
}
