import 'dart:typed_data';

import 'package:frontend/src/app/api/helpers/jwt_api.dart';
import 'package:frontend/src/app/api/interfaces/baseApi.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class PictureApi extends BaseApi {
  PictureApi(super.client);

  Future<http.StreamedResponse> upload(XFile image, String url) async {
    var bytes = await image.readAsBytes();
    var stream = http.ByteStream(DelegatingStream(image.openRead()));
    var length = bytes.length;
    var uri = Uri.parse(url);
    var type = MimeTypeResolver().lookup(image.name);
    var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: image.name,
        contentType: type == null ? null : MediaType.parse(type)
    );
    var api = JWTApi();

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.files.add(multipartFile);

    return await api.handleRequest(client, request);
  }

  Future<Uint8List> download(String url) async {
    var api = JWTApi();
    var response = await api.get(client, url);

    return response.bodyBytes;
  }

  Future<http.StreamedResponse> update(XFile image, String url) async {
    var bytes = await image.readAsBytes();
    var stream = http.ByteStream(DelegatingStream(image.openRead()));
    var length = bytes.length;
    var uri = Uri.parse(url);
    var type = MimeTypeResolver().lookup(image.name);
    var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: image.name,
        contentType: type == null ? null : MediaType.parse(type)
    );
    var api = JWTApi();

    http.MultipartRequest request = http.MultipartRequest('PUT', uri);
    request.files.add(multipartFile);

    return await api.handleRequest(client, request);
  }
}
