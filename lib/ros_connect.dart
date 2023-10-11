import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:roslibdart/roslibdart.dart';

class RosConnect {
  late Ros ros;
  late Topic chatter;

  RosConnect() {
    initState();
  }

  void initState() {
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

  Future<void> subscribeHandler(Map<String, dynamic> msg) async {
    var msgReceived = json.encode(msg);
    var result = jsonDecode(msgReceived)["data"];
    if (kDebugMode) {
      print(result);
    }
    return result;
  }

  void initConnection() async {
    ros.connect();
    await chatter.subscribe(subscribeHandler);
    print("connected");
  }
}
