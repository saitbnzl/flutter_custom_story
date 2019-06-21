import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_kitapsec/commons/config.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var urlString = Config.WEBVIEW_URL;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  List<Map> _pushData = List();
  final _history = [];
  bool _showWebView = true;
  double _storyHeight = 0.0;

  @override
  void dispose() {
    HomePageState();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _showWebView = true;

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);

      if (wvs.type == WebViewState.finishLoad) {
        print("Evet WebViewState.finishLoad  oldu");
        _storyHeight = MediaQuery.of(context).size.height * 0.13;
      }

      print("Evet 36.satır");
    });

    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });
    //flutterWebViewPlugin.onUrlChanged.listen(onData)
  }

  void backWebView() {
    print(_history);
    _showWebView = true;
  }

  Widget _floatPic() {
    // var item = this.stories[story];
    var item = [
      {
        "story": "1",
        "trays":
            "http://kilavuzipm.tamtutar.com/open/profile-picture.php?q=thumb-upl5cc4a0d8ce8ba2.91095686-1556390104-1556390104.846-7579469433980816358.jpeg"
      },
      {
        "story": "2",
        "trays":
            "http://kilavuzipm.tamtutar.com/open/profile-picture.php?q=thumb-upl5cc4a0d8ce8ba2.91095686-1556390104-1556390104.846-7579469433980816358.jpeg"
      },
    ];

    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showWebView = false;
                      });
                      print("Ahmet ${index} numaralı resme tıkladın");
                      /*_pushData.add({
                        "story": "1",
                        "trays":
                            "http://kilavuzipm.tamtutar.com/open/profile-picture.php?q=thumb-upl5cc4a0d8ce8ba2.91095686-1556390104-1556390104.846-7579469433980816358.jpeg"
                      });*/
                      _pushData = item;
                      Navigator.of(context).pushNamed("/pages/card").then((t) {
                        if (t == true) {
                          print("Dönüş oldu");
                          backWebView();
                        }
                      });
                      /*Navigator.of(context).pushNamed("/pages/story", arguments: _pushData).then((t) {
                        if (t == true) {
                          print("Dönüş oldu");
                          backWebView();
                        }
                      });*/
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: index == 0
                                  ? Colors.blueGrey[50]
                                  : Colors.orangeAccent[100],
                              width: 2),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "http://kilavuzipm.tamtutar.com/open/profile-picture.php?q=thumb-upl5cc4a0d8ce8ba2.91095686-1556390104-1556390104.846-7579469433980816358.jpeg")),
                          shape: BoxShape.circle,

                        ),
                      ),
                    ),
                  ),
                  Text((index == 0) ? "You" : " Friend $index")
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _floatPic(),
            _showWebView
                ? Container(
                    //height: 0,
                    margin: EdgeInsets.only(top: _storyHeight),
                    child: WebviewScaffold(
                      withZoom: false,
                      hidden: true,
                      withJavascript: true,
                      withLocalStorage: true,
                      url: Config.WEBVIEW_URL,
                      bottomNavigationBar: BottomAppBar(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                  ),
                                  onPressed: () {
                                    flutterWebViewPlugin.goBack();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    flutterWebViewPlugin.goForward();
                                  },
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.autorenew),
                                  onPressed: () {
                                    flutterWebViewPlugin.reload();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
