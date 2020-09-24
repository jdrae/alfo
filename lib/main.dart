import 'package:chatbot/screen/chatscreen.dart';
import 'package:flutter/material.dart';
import 'screen/chatscreen.dart';


void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => ChatScreen(),
      // },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Card(
            child: ChatScreen("mebot","intro"),
          ),
        ),
      ),
    ),
    );
  }
}
