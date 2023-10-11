import 'package:flutter/material.dart';
import 'package:roboticon/constants.dart';
import 'package:roboticon/ros_connect.dart';
import 'package:roboticon/video_items.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RosConnect _connect;
  VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset(AppConstants.angryVid);

  @override
  void initState() {
    super.initState();
    _connect = RosConnect();
    _connect.initConnection();
    _connect.subscribeToMessages((message) {
      updateVideo(message);
    });
  }

  void updateVideo(String message) {
    switch (message) {
      case 'angry':
        _videoPlayerController = VideoPlayerController.asset(AppConstants.angryVid);
        break;
      case 'bored':
        _videoPlayerController = VideoPlayerController.asset(AppConstants.boredVid);
        break;
      default:
        _videoPlayerController = VideoPlayerController.asset(AppConstants.defaultVid);
        break;
    }
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        children: <Widget>[
          VideoItems(
            videoPlayerController: _videoPlayerController,
            looping: true,
            autoplay: true,
          ),
        ],
      ),
    );
  }
}
