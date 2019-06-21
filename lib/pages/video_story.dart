import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoStory extends StatefulWidget {
  int index = 0;
  int selectedItem;
  String story;

  VideoStory({
    Key key,
    @required this.selectedItem,
    @required this.index,
    @required this.story,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _VideoStory(selectedItem: selectedItem, story: story, index: index);
}

class _VideoStory extends State<VideoStory> {
  int index = 0;
  VideoPlayerController _controller;
  int selectedItem;
  String story;

  _VideoStory({
    Key key,
    this.selectedItem,
    this.story,
    this.index,
  });

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(story)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          //_controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: index == selectedItem ? selectedItem : "",
        child: GestureDetector(
            onVerticalDragEnd: (DragEndDetails dwon) {
              if (dwon.primaryVelocity > 800) {
                Navigator.pop(context);
              }
            },
            child:


            _controller.value.initialized
                ? Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ],
                  )
                : Container()));
  }


}
