import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Header extends StatelessWidget {
  final String name;
  Header(this.name);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            alignment: Alignment.center,
            icon: Icon(Icons.arrow_back, color: Colors.black12),
            onPressed: () {
              
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              child: Text(name), radius: 16, foregroundColor: Colors.green,
          )),
          Text(name, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}