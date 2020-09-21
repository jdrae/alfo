import 'package:flutter/material.dart';

class Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "나",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              TextSpan(text: '\n'),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
    );
  }
}