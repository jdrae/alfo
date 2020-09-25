import 'package:chatbot/screen/chatscreen.dart';
import 'package:flutter/material.dart';


class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child:
          SizedBox(
          width: 400,
          height: 700,
          child: Card(
            child: ChatScreen("mebot","intro"),
          ),
        ),
      ),
    );
  }
}
