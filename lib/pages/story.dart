import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryPage extends StatefulWidget {
  final List<Map> pushData;

  const StoryPage({Key key, this.pushData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController;
  int selectedItem = 1;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(
        initialPage: selectedItem, keepPage: true, viewportFraction: 1);

    print(widget.pushData);
    print(widget.pushData.length);
  }

  @override
  void dispose() {
    _pageController.dispose();
    //Navigator.of(context).pop(true);
    print("Alo");
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    !await Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        /*appBar: AppBar(
        title: Text("Emre"),
      ),*/
        body: PageView.builder(
          itemBuilder: _pageBuilder,
          physics: BouncingScrollPhysics(),
          pageSnapping: true,
          onPageChanged: _onPageChange,
          controller: _pageController,
          //itemCount: items.length,
          itemCount: widget.pushData.length,
        ),
      ),
    );
  }

  Widget _pageBuilder(BuildContext context, int index) {
    //Items story = items[index];
    //return Story(story, index, selectedItem);

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          _getStoryItem(),
          Container(
            alignment: FractionalOffset.bottomCenter,
            margin: EdgeInsets.only(bottom: 48),
          ),
        ]),
      ),
    );
  }

  Widget _getStoryItem() {
    bool noVideos = true;
    return noVideos
        ? Hero(
            tag: widget.pushData[0]["story"],
            //tag: index == selectedItem ? story.id : "",
            child: GestureDetector(
              onVerticalDragEnd: (DragEndDetails dwon) {
                if (dwon.primaryVelocity > 800) {
                  Navigator.pop(context);
                }
              },
              child: FadeInImage(
                  fit: BoxFit.fill,
                  fadeInDuration: Duration(milliseconds: 1000),
                  //placeholder: NetworkImage(story.imageVersions2.candidates[5].url),
                  placeholder: NetworkImage(widget.pushData[0]["trays"]),
                  image: NetworkImage(widget.pushData[0]["trays"])),
            ),
          )
        : Container();
  }

  void _onPageChange(int value) {
    setState(() {
      selectedItem = value;
    });
  }
}
