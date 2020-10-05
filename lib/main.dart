import 'package:flutter/material.dart';
import 'chatscreenbuild.dart';
import 'screen/manage.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/me',
      routes: {
        '/we': (context) => ChatBuilder('webot', '우리'),
        '/you': (context) => ChatBuilder('webot', '우리'),
        '/me': (context) => ChatBuilder('mebot', '나'),
        '/manage': (context) => ManageScreen(),
      },
      debugShowCheckedModeBanner: false
    );
  }
}
