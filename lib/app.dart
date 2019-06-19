import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_kitapsec/commons/config.dart';



class KitapSecMobileApp extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Stack(
            children: <Widget>[
              WebviewScaffold(
                url: Config.WEBVIEW_URL,
              )
            ],
          ),
        ),
      ),
    );
  }
}
