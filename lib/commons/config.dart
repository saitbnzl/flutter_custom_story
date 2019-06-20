
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

abstract class Config {

  static const String STR_APPLICATION_TITLE = "Google Mobil";
  static const String APPLICATION_TITLE = "Google Mobil";
  static const String WEBVIEW_URL = "https://www.google.com";
  static const bool DEBUG = true;
  static const bool DEBUG_OUTPUT_REQ_RES = true;
  static const List<DeviceOrientation> SUPPORTED_SCREEN_ORIENTATIONS = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ];


}


