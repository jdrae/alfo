import 'package:flutter/material.dart';
import 'screen/intro.dart';
import 'screen/me-we.dart';
import 'screen/me-you.dart';
import 'screen/me.dart';
import 'screen/you.dart';
import 'screen/we.dart';
import 'screen/manage.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Intro(),
        '/we': (context) => WeBot(),
        '/you': (context) => YouBot(),
        '/me': (context) => MeBot(),
        '/me-we': (context) => MeWeBot(),
        '/me-you': (context) => MeYouBot(),
        '/manage': (context) => ManageScreen(),
      },
      debugShowCheckedModeBanner: false
    );
  }
}
