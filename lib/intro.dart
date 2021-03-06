import 'package:chatbot/widget/selcard.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/widget/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatbot/widget/header.dart';
import 'dart:async';
class Intro extends StatefulWidget {
  
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> with TickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Widget> _messages = [];
  int cnt = -1; int size = 0; bool wait = false;
  List<QCard> qcards = [];

  Bubble makeBubble(String name, String text, bool isMe){
      return Bubble(
            name: name,
            text: text,
            animationController: AnimationController(
              duration: Duration(milliseconds: 400),
              vsync: this,
            ),
            isMe: isMe
          );
  }

  SelCard makeCard(coll){
    if(qcards.length == 0){  
      firestore.collection(coll).orderBy('id').get()
      .then((qs){
        String ques = ""; int idx = -1;
        for(; cnt < size; cnt ++){
          var doc = qs.docs[cnt];
          var isCard = doc.get('unique');
          if(isCard.length != 9) break;
          if(isCard[0] == '0') {ques = doc.get('msg'); idx += 1;}
          else {
            List<String> ans = [];
            for(; cnt < size; cnt++){
              var tmp = qs.docs[cnt];
              if(tmp.get('unique')[0] != '1') {cnt--; break;}
              ans.add(tmp.get('msg'));
            }
            QCard card = QCard(idx, ques, ans);
            if(qcards.length < 4) qcards.add(card);
            else break;
          }
        }
        if(qcards.length == 0) throw Exception("no selcards");
      });
    }
    return SelCard(
      qcards: qcards,
      animationController: AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this,
      ),
      callback: (QCard card){
        _cardanswer(card.ans);
        /*
        for(int i = 0; i<qcards.length; i++){
          if(qcards[i].idx == card.idx){
            qcards.remove(card);
          }
        }*/
      }
    );
  }

  void _cardanswer(List<String> ans){
    int sec = 0;
    for(int i = 0; i<ans.length; i++){
      sec += msgsec(ans[i]);
      Bubble msg = this.makeBubble("나", ans[i], false);
      addmsg(sec, msg);
    }
    sec+= 1000;
    SelCard cards = this.makeCard('mebot');
    addmsg(sec, cards);
  }

  @override
  void dispose() {
    for (Bubble message in _messages) {
      message.animationController.dispose();
    }
   super.dispose();
  }

  @override
  void initState(){
    super.initState();
    if(size == 0) this.start('intro');
  }

  void start(coll) async{
    await firestore.collection(coll)
    .get().then((snap) {
      size = snap.size;
    });
    cnt = 0;
    _answer(coll);
  }

  int msgsec(String text){
    int sec = text.length * 120; // 글자 길이에 따라 답장 속도
    if(sec > 2500) sec = 2500; //최대 속도 3초
    if(cnt == 0) sec = 100; // 처음일 경우 빨리
    return sec;
  }

  void addmsg(sec, msg){
    Timer(Duration(milliseconds: sec),(){
    setState(() {
      _messages.insert(0,msg);
    });
    msg.animationController.forward();
    });
  }

  void _answer(String coll) async{
    var msg; int sec = 100;
    
    await firestore.collection(coll).orderBy('id').get()
    .then((qs){
      var doc = qs.docs[cnt];
      var isCard = doc.get('unique');
      
      sec = msgsec(doc.get('msg').toString());
      //QUESTION
      if(isCard.length == 9 && isCard[0] == '0'){ 
        msg = this.makeCard(coll);
        wait = true;
      }
      //MSG
      else{ 
        msg = this.makeBubble("나" ,doc.get('msg'), false);
      }
    });

    Timer(Duration(milliseconds: sec),(){
      setState(() {
        _messages.insert(0,msg);
      });
      msg.animationController.forward();

      if(wait) return;

      cnt += 1;
      if(cnt < size) return _answer(coll);
      if(coll == 'intro') return start('mebot');
    });
  }


  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.black87),
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              readOnly: true,
              decoration:  InputDecoration.collapsed(hintText: '메세지를 입력할 수 없습니다.'),
              ),
            ),
          Container( 
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed:  null,
            ), 
          )
        ]
      )
    ));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Card(
            child:
              Column(
                children: [
                  Header("나"),
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse:true,
                      itemBuilder: (_,int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                  Divider(height: 1.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor
                    ),
                    child: _buildTextComposer(),
                  )
                ],
              ),
          ),
        ),
      ),
    );
    
  }
}