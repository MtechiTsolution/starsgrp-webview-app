import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../app.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    controller = VideoPlayerController.asset("assets/videos/star.mp4");
    controller.initialize().then((val) {
      controller.setLooping(true);
      Timer(Duration(milliseconds: 1000), () {
        setState(() {
          controller.play();
          _visible = true;
        });
      });
    });

    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => App()), (e) => false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.dispose();
      // controller = null;
    }
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(controller),
    );
  }

  _getBackgroundColor() {
    return Container(color: Colors.transparent //.withAlpha(120),
        );
  }

  _getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import '../app.dart';
//
// class SplashVideo extends StatefulWidget {
//   SplashVideo() : super();
//
//   final String title = "Video Demo";
//
//   @override
//   VideoDemoState createState() => VideoDemoState();
// }
//
// class VideoDemoState extends State<SplashVideo> {
// //
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.asset(
//         "assets/star.mp4");
//     // _controller = VideoPlayerController.network(
//     //     "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
//     _initializeVideoPlayerFuture = _controller.initialize().then((value){
//       _controller.setLooping(true);
//       _controller.setVolume(1.0);
//       _controller.play();
//     });
//
//     // Future.delayed(Duration(seconds:6), () {
//     //   _controller.pause();
//     //   Navigator.push(context, MaterialPageRoute(builder: (_) => App()));
//     // });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Center(
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }