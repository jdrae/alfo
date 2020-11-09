import 'package:flutter/material.dart';
import 'dart:math' as math;

class QCard{
  int idx;
  String ques;
  List<String> ans;
  QCard(this.idx, this.ques, this.ans);
  
}

class SelCard extends StatelessWidget{
  SelCard({this.qcards, this.animationController, this.callback});
  
  final List<QCard> qcards;
  final AnimationController animationController; 
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: qcards.length,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                    color: Colors.grey[50],
                    margin: EdgeInsets.all(7),
                    child: InkWell(
                      onTap: () {
                        this.callback(qcards[position]);
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.all(18),
                        child: Text(qcards[position].ques,
                          style: TextStyle(
                            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )
      );
  }
}