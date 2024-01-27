import 'dart:typed_data';


import 'package:frontend/src/config/api_config.dart';
import 'package:image_picker/image_picker.dart';

import '../api/picture_api.dart';

class ImageService {
  final PictureApi _pictureApi;

  ImageService(this._pictureApi);

  Future<void> postImage(XFile image, String url) async {
    await _pictureApi.upload(image, "${ApiConfig.baseUrl}/$url");
  }

  Future<Uint8List> getImage(String url) async {
    return await _pictureApi.download(url);
  }

  Future<void> putImage(XFile image, String url) async {
    await _pictureApi.update(image, "${ApiConfig.baseUrl}/$url");
  }
}
