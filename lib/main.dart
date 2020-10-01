import 'package:flutter/material.dart';
import 'screen/me.dart';
import 'screen/you.dart';
import 'screen/we.dart';
import 'screen/manage.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/manage',
      routes: {
        '/we': (context) => WeBot(),
        '/you': (context) => YouBot(),
        '/me': (context) => MeBot(),
        '/manage': (context) => ManageScreen(),
      },
      debugShowCheckedModeBanner: false
    );
  }
}
