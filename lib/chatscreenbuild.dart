import 'package:chatbot/screen/chatscreen.dart';
import 'package:flutter/material.dart';

class ChatBuilder extends StatelessWidget {
  final String botName; final String name;
  ChatBuilder(this.botName, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Card(
            child: ChatScreen(botName, name),
          ),
        ),
      ),
    );
  }
}
