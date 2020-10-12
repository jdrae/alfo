import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          
          IconButton(
            alignment: Alignment.center,
            icon: Icon(Icons.arrow_back, color: Colors.black12),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              child: Text(name[0]), radius: 16, foregroundColor: Colors.green,
          )),
          Text(name, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}