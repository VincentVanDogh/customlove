import 'package:frontend/src/config/connection.dart';

// Comment out the above import and use this when running on emulator:
// import 'package:frontend/src/config/connection_emulator.dart';

import 'package:flutter/material.dart';

class ApiConfig {
  String _baseUrl = "";
  String _socketsUrl = "";

  ApiConfig() {
    String urlPrefix = config['use_tls'] ? "https" : "http";
    String socketsPrefix = config['use_tls'] ? "wss" : "ws";
    String port = config['port'] != '' ? ":${config['port']}" : "";

    _baseUrl = "$urlPrefix://${config['server']}$port";
    _socketsUrl = "$socketsPrefix://${config['server']}$port";
  }

  static ApiConfig? _instance;
  static ApiConfig _getInstance() {
    _instance ??= ApiConfig();
    return _instance!;
  }

  static String get baseUrl => _getInstance()._baseUrl;
  static String get socketsUrl => _getInstance()._socketsUrl;
}
