import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter_kitapsec/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kitapsec/pages/video_story.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* // Spacer for status bar
            new Container(
              width: double.infinity,
              height: 20.0,
            ),*/

            // Cards

            new Expanded(
              child: new CardFlipper(
                  cards: demoCards,
                  onScroll: (double scrollPercent) {
                    setState(() => this.scrollPercent = scrollPercent);
                  }),
            ),

            // Scroll Indicator
            new BottomBar(
              cardCount: demoCards.length,
              scrollPercent: scrollPercent,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    print("Buradasın card.dart 52");
    !await Navigator.of(context).pop(true);
  }
}

class CardFlipper extends StatefulWidget {
  final List<CardViewModel> cards;
  final Function onScroll;

  CardFlipper({
    this.cards,
    this.onScroll,
  });

  @override
  _CardFlipperState createState() => new _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();

    finishScrollController = new AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(
              finishScrollStart, finishScrollEnd, finishScrollController.value);

          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        print("Status 100.satır");
        print(status);
      });
  }

  void _onPanStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      scrollPercent = (startDragPercentScroll +
              (-singleCardDragPercent / widget.cards.length))
          .clamp(0.0, 1.0 - (1 / widget.cards.length));
      print('percentScroll: $scrollPercent');

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd =
        (scrollPercent * widget.cards.length).round() / widget.cards.length;
    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.cards.map((CardViewModel viewModel) {
      ++index;
      return _buildCard(viewModel, index, widget.cards.length, scrollPercent);
    }).toList();
  }

  Matrix4 _buildCardProjection(double scrollPercent) {
    // Pre-multiplied matrix of a projection matrix and a view matrix.
    //
    // Projection matrix is a simplified perspective matrix
    // http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
    // in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, 0.0],
    //  [0.0, 0.0, -perspective, 1.0]]
    //
    // View matrix is a simplified camera view matrix.
    // Basically re-scales to keep object at original size at angle = 0 at
    // any radius in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, -radius],
    //  [0.0, 0.0, 0.0, 1.0]]
    final perspective = 0.002;
    final radius = 1.0;
    final angle = scrollPercent * pi / 8;
    final horizontalTranslation = 0.0;
    Matrix4 projection = new Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1.0);

    // Model matrix by first translating the object from the origin of the world
    // by radius in the z axis and then rotating against the world.
    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
    print('Angle: $angle');
    projection *= new Matrix4.translationValues(
            horizontalTranslation + (rotationPointMultiplier * 300.0),
            0.0,
            0.0) *
        new Matrix4.rotationY(angle) *
        new Matrix4.translationValues(0.0, 0.0, radius) *
        new Matrix4.translationValues(
            -rotationPointMultiplier * 300.0, 0.0, 0.0);

    return projection;
  }

  Widget _buildCard(
    CardViewModel viewModel,
    int cardIndex,
    int cardCount,
    double scrollPercent,
  ) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / widget.cards.length);

    return new FractionalTranslation(
      translation: new Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: new Transform(
          transform: _buildCardProjection(cardScrollPercent - cardIndex),
          child: new Card(
            viewModel: viewModel,
            parallaxPercent: parallax,
            isActive: scrollPercent > (cardIndex - 0.5) / widget.cards.length &&
                scrollPercent < (cardIndex + 0.5) / widget.cards.length,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tıkladım");
        if(scrollPercent<1-(1/widget.cards.length)){
          scrollPercent = scrollPercent+1/widget.cards.length;
          _onPanEnd(null);
        }else{
          scrollPercent=0;
          _onPanEnd(null);
        }
      },
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }
}

class Card extends StatefulWidget {
  final CardViewModel viewModel;
  bool isActive;
  final double
      parallaxPercent; // [0.0, 1.0] (0.0 for all the way right, 1.0 for all the way left)

  Card({this.viewModel, this.parallaxPercent = 0.0, this.isActive});
  createState() => CardState();
}

class CardState extends State<Card> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool isVideo = false;
  @override
  void initState() {
    if (widget.viewModel.backdropAssetPath.endsWith('mp4')) {
      isVideo = true;
      _controller =
          VideoPlayerController.network(widget.viewModel.backdropAssetPath);
      _controller.setLooping(true);

      _initializeVideoPlayerFuture = _controller.initialize();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isVideo) {
      if (widget.isActive && !_controller.value.isPlaying)
        _controller.play();
      else if (!widget.isActive && _controller.value.isPlaying)
        _controller.pause();
    }
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Background
        new ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: new Container(
            child: new FractionalTranslation(
              translation: new Offset(widget.parallaxPercent * 3.0, 0.0),
              child: new OverflowBox(
                  maxWidth: double.infinity,
                  /*Emre Begin*/
                  child: isVideo
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          // Use the VideoPlayer widget to display the video.
                          child: VideoPlayer(_controller))
                      : FadeInImage(
                          fadeInDuration: Duration(milliseconds: 1000),
                          fadeOutCurve: Curves.decelerate,
                          //placeholder: NetworkImage(viewModel.backdropAssetPath),
                          placeholder: AssetImage("assets/img/loader.gif"),
                          image:
                              NetworkImage(widget.viewModel.backdropAssetPath),
                          fit: BoxFit.cover,
                        )

                  /*child: Image.network(
                  viewModel.backdropAssetPath,
                  fit: BoxFit.cover,
                ),
                Emre End*/

                  /*child: new Image.asset(
                  viewModel.backdropAssetPath,
                  fit: BoxFit.cover,
                ),  */
                  ),
            ),
          ),
        ),

        // Content
        /* new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: new Text(
                '${viewModel.address}'.toUpperCase(),
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'petita',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            new Expanded(child: new Container()),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  '${viewModel.minHeightInFeet} - ${viewModel.maxHeightInFeet}',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
                    fontFamily: 'petita',
                    letterSpacing: -5.0,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                  child: new Text(
                    'FT',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontFamily: 'petita',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: new Text(
                    '${viewModel.tempInDegrees.toStringAsFixed(1)}º',
                    style: new TextStyle(
                      color: Colors.white,
                      fontFamily: 'petita',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                )
              ],
            ),
            new Expanded(child: new Container()),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: new Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(30.0),
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: new Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new Text(
                        '${viewModel.weatherType}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        '${viewModel.windSpeedInMph}mph ${viewModel.cardinalDirection}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),*/
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  BottomBar({
    this.cardCount,
    this.scrollPercent,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Padding(
        //padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        /*Emre Begin*/
        padding:
            const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 0.0, right: 0.0),
        /*Emre End*/

        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Center(
                child: new Container(
                  width: double.infinity,
                  height: 5.0,
                  child: new ScrollIndicator(
                    cardCount: cardCount,
                    scrollPercent: scrollPercent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({
    this.cardCount,
    this.scrollPercent,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new ScrollIndicatorPainter(
        cardCount: cardCount,
        scrollPercent: scrollPercent,
      ),
      child: new Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.cardCount,
    this.scrollPercent,
  })  : trackPaint = new Paint()
          ..color = const Color(0xFF444444)
          ..style = PaintingStyle.fill,
        thumbPaint = new Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw track
    canvas.drawRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
      trackPaint,
    );

    // Draw thumb
    final thumbWidth = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;

    Path thumbPath = new Path();
    thumbPath.addRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          thumbLeft,
          0.0,
          thumbWidth,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
    );

    // Thumb shape
    canvas.drawPath(
      thumbPath,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
