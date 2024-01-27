import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:xml/xml.dart';

class LocationService {
  var logger = Logger();
  final String _baseUrl =
      'https://nominatim.openstreetmap.org/reverse?format=xml&lat={latitude}&lon={longitude}';

  Future<String> getCurrentLocation(double latitude, double longitude) async {
    String url = _baseUrl
        .replaceAll('{latitude}', latitude.toString())
        .replaceAll('{longitude}', longitude.toString());

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return _convertXmlToAddress(response.body);
      } else {
        throw Exception('Failed to get location: ${response.statusCode}');
      }
    } catch (error) {
      logger.e('Error: $error');
      throw Exception('Failed to get location');
    }
  }

  String _convertXmlToAddress(responseBody) {
    try {
      var document = XmlDocument.parse(responseBody);
      //var result = document.rootElement.findElements('result').first.innerText;
      var addressParts =
          document.rootElement.findElements('addressparts').first;
      var result = addressParts.findElements('city').first.innerText;
      return result;
    } on StateError catch (error) {
      logger.e("Error while converting current location to Address.");
      logger.e(error);
      logger.i("Trying again with different converter.");
      try {
        var document = XmlDocument.parse(responseBody);
        var addressParts =
            document.rootElement.findElements('addressparts').first;
        var result = addressParts.findElements('village').first.innerText;
        return result;
      } on StateError catch (error) {
        logger.e("Error while converting current location to Address.");
        logger.e(error);
        logger.i("Trying again with different converter.");
        try {
          var document = XmlDocument.parse(responseBody);
          var addressParts =
              document.rootElement.findElements('addressparts').first;
          var result = addressParts.findElements('town').first.innerText;
          return result;
        } catch (error) {
          logger.e("Error while converting current location to Address.");
          logger.e(error);
        }
      } catch (error) {
        logger.e("Error while converting current location to Address.");
        logger.e(error);
      }
    }
    return "";
  }
}
