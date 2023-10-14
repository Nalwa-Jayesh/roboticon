import 'package:flutter/material.dart';
import 'package:roboticon/constants.dart';

import 'package:video_player/video_player.dart';
import 'package:roslibdart/roslibdart.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Ros ros;
  late Topic chatter;
  var message = "";
  var path = null;

  void initConnection() async {
    ros.connect();
    await chatter.subscribe(subscribeHandler);
    print("connected");
  }
  Future<void > subscribeHandler(Map<String, dynamic> msg) async {
    var msgReceived = json.encode(msg);
    var result = jsonDecode(msgReceived)["data"];
    setState(() {
      message = result;
      switch (message) {
        case "bored":
          path = AppConstants.boredVid;
          print(path);
          break;
        case "angry":
          path = AppConstants.angryVid;
          print(path);
          break;
        default:
          path = AppConstants.defaultVid;
          print(path);
          break;
      }

    });
  }
  void initRos() {
    ros = Ros(url: 'ws://192.168.0.22:9090');
    chatter = Topic(
      ros: ros,
      name: '/mood',
      type: "std_msgs/String",
      reconnectOnClose: true,
      queueLength: 10,
      queueSize: 10,
    );
  }

  @override
  void initState() {
    super.initState();
    initRos();
    initConnection();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: path == null
          ? ListView(
            children: <Widget>[
              Image.asset(
                  path,
              ),
            ],
      )
          :
      ListView(
        children: <Widget>[
          Image.asset(
              path,
          )
        ],
      ),
    );
  }
}