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
  late VideoPlayerController _currentVideoController;

  @override
  void initState() {
    super.initState();
    _connect = RosConnect();
    _connect.initConnection();

    // Initialize the video controller with the default video (e.g., 'angryVid').
    _currentVideoController = VideoPlayerController.asset(AppConstants.angryVid);
    _currentVideoController.initialize().then((_) {
      _currentVideoController.play();
      _currentVideoController.setLooping(true);
    });

    // Listen to ROS messages and switch videos accordingly.
    _connect.chatter.subscribe((message) {
      // Assuming that the message contains a string, e.g., 'angry' or 'bored'.
      String mood = message['data'];
      switchVideoBasedOnMood(mood);
      return Future.value();
    });
  }

  void switchVideoBasedOnMood(String mood) {
    String videoAssetPath;

    // Determine the video asset to display based on the mood.
    if (mood == 'angry') {
      videoAssetPath = AppConstants.angryVid;
    } else if (mood == 'bored') {
      videoAssetPath = AppConstants.boredVid;
    } else {
      // Default video if mood is unknown.
      videoAssetPath = AppConstants.defaultVid;
    }

    // Switch to the new video.
    _currentVideoController.pause();
    VideoPlayerController newController = VideoPlayerController.asset(videoAssetPath);

    newController.initialize().then((_) {
      setState(() {
        _currentVideoController.dispose();
        _currentVideoController = newController;
        _currentVideoController.play();
        _currentVideoController.setLooping(true);
      });
    }).catchError((error) {
      print('Error initializing video: $error');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        children: <Widget>[
          VideoItems(
            videoPlayerController: _currentVideoController,
          ),
        ],
      ),
    );
  }
}
