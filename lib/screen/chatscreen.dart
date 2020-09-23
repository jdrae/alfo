import 'package:flutter/material.dart';
import 'package:chatbot/widget/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Bubble> _messages = [];
  int cnt = 1;

  final _textController = TextEditingController();
  
  bool _isComposing = false;

  @override
  void dispose() {
    for (Bubble message in _messages) {
      message.animationController.dispose();
    }
   super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    Bubble message = Bubble(
      text: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this,
      ),
      isMe: true
    );
    setState(() { //수정하고 다시 빌드 -> 동기화 작업만 수행. 비동기는 완료전에 다시 수행
      _messages.insert(0,message);
    });
    message.animationController.forward();
    if(cnt < 6){
      this._answer();
      cnt++;
    }
  }

  void _answer(){
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection("bots").doc("webot").collection("chat1")
    .where('id', isEqualTo: cnt).get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Bubble rmsg = Bubble(
          text: doc.get('msg'),
          animationController: AnimationController(
            duration: Duration(milliseconds: 400),
            vsync: this,
          ),
          isMe: false
        );

        Future.delayed(Duration(milliseconds: 1300)).then((_) {
        setState(() { //수정하고 다시 빌드 -> 동기화 작업만 수행. 비동기는 완료전에 다시 수행
          _messages.insert(0,rmsg);
        });
        rmsg.animationController.forward();
        });
      });
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
              controller: _textController,
              onChanged: (String text){
                setState((){
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration:  InputDecoration.collapsed(hintText: ''),
              ),
            ),
          Container( 
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
            ), 
          )
        ]
      )
    ));
  }
  
  @override
  Widget build(BuildContext context){
  
    return Column(
      children: [
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
    );
  }

}


