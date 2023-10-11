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

  @override
  void initState() {
    super.initState();
    _connect = RosConnect();
    _connect.initConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        children: <Widget>[
          VideoItems(
            videoPlayerController: VideoPlayerController.asset(
              AppConstants.angryVid,
            ),
            looping: true,
            autoplay: true,
          ),
        ],
      ),
    );
  }
}
