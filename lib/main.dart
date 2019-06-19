import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kitapsec/app.dart';
import 'package:flutter_kitapsec/commons/config.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (Config.DEBUG) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };


  runZoned<Future<Null>>(() async {
    SystemChrome.setPreferredOrientations(Config.SUPPORTED_SCREEN_ORIENTATIONS).then((_) {
      runApp(MaterialApp(home: KitapSecMobileApp()));
    });
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    debugPrint(error.toString());
  });
}



