import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roboticon/constants.dart';
import 'package:roboticon/video_items.dart';
import 'package:roslibdart/core/ros.dart';
import 'package:roslibdart/core/topic.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home:  const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: ListView(
        children: <Widget>[
          VideoItems(
            videoPlayerController: VideoPlayerController.asset(
              AppConstants.defaultVid,
            ),
            looping: true,
            autoplay: true,
          ),
        ],
      ),
    );
  }
}

void connect() async {
  var ros = Ros(url: 'ws://127.0.0.1:9090');
  var chatter = Topic(ros: ros, name: '/topic', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
  ros.connect();

  Future<void> subscribeHandler(Map<String, dynamic> msg) async {
    var msgReceived = json.encode(msg);
  }
  await chatter.subscribe(subscribeHandler);
}