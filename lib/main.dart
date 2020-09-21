import 'package:flutter/material.dart';
import 'widgets/chatscreen.dart';
import 'database/messages.dart';


void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          height: 300,
          child: Card(
            child: Container(child: GetChatroom('mebot', 'intro')),
          ),
        ),
      ),
    ),
    );
  }
}
