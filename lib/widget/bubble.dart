import 'package:flutter/material.dart';

//메세지 하나
class Bubble extends StatelessWidget{
  Bubble({this.text, this.animationController, this.isMe});
  
  final String text;
  final AnimationController animationController; 
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if(isMe){
      return SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.60, //TODO: 데스크탑에서 깨짐
                ),
                padding: EdgeInsets.fromLTRB(10,7,10,7),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        )
        )
      );
    } else{
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(child: Text("우"), radius: 16, foregroundColor: Colors.green,),
          ),
          Container(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.60, //TODO: 데스크탑에서 깨짐
              ),
              padding: EdgeInsets.fromLTRB(10,7,10,7),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xffe5e4ea),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      )
      )
    );
    }
  }
}