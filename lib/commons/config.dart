 import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

abstract class Config {
  /* -----------  STRINGS ------------------ */
  static const String STR_APPLICATION_TITLE = "Kitapseç Mobil";
  static const String APPLICATION_TITLE = "Kitapseç Mobil";

  /* -----------  WS ------------------ */

  static const String WEBVIEW_URL = "https://www.kitapsec.com/";
  static const String BASE_URL = "http://demo.kitapsec.com";
  static const String END_POINT_URL = BASE_URL + "/rest/";
  static const String MEDIA_URL = BASE_URL + "/content/media/view/";
  static const String MEDIA_URL_INLINE = BASE_URL + "/content/media/inline/";
  static const int HTTP_TIME_OUT = 20;

  static const bool WORK_WITH_MOCK = false;

  /* -----------  DEBUG ------------------ */
  static const bool DEBUG = true;
  static const bool DEBUG_OUTPUT_REQ_RES = true;

  /* -----------  Behaviour  ------------------ */
  static const int BEHAVIOUR_SEARCH_HISTORY_COUNT = 5;
  static const bool BEHAVIOUR_CHECK_FOR_UPDATES = true;
  static const Duration BEHAVIOUR_REMIND_UPDATES_ON_APP_START_IN_EVERY = Duration(days: 1);
  static const bool BEHAVIOUR_CLEAR_ALL_DATA_ON_APP_START = false; //Watch out! Do not turn it on in production. Newer!
  static const List<DeviceOrientation> SUPPORTED_SCREEN_ORIENTATIONS = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    //DeviceOrientation.landscapeLeft,
    //DeviceOrientation.landscapeRight,
  ];


}


