import 'package:flutter/material.dart';
import 'package:flutter_kitapsec/commons/config.dart';
import 'package:flutter_kitapsec/routes.dart';
import 'dart:io' show Platform;
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class KitapSecMobileApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.STR_APPLICATION_TITLE,
      onGenerateRoute: (RouteSettings settings) {
        if (Config.DEBUG) {
          print("Generating Platform Named Route: ${settings.name} with arguments: ${settings.arguments.toString()}");
        }
        if (ROUTES[settings.name] != null) {
          return platformPageRoute(builder: (BuildContext context) {
            return ROUTES[settings.name](settings);
          });
        }
      },

    );
  }
}
