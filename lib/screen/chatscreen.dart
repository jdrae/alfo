import 'package:flutter/material.dart';
import 'package:chatbot/widget/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String botName;
  final String docId;
  ChatScreen(this.botName, this.docId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Bubble> _messages = [];
  int cnt = 1; int size = 0;

  final _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    for (Bubble message in _messages) {
      message.animationController.dispose();
    }
   super.dispose();
  }

  Bubble makeBubble(String text, bool isMe){
    return Bubble(
          text: text,
          animationController: AnimationController(
            duration: Duration(milliseconds: 400),
            vsync: this,
          ),
          isMe: isMe
        );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    Bubble message = makeBubble(text, true);
    setState(() {
      _messages.insert(0,message);
    });
    message.animationController.forward();
    if(size != 0 && cnt <= size){
      this._answer();
      cnt++;
    }
  }

  void _answer(){
    firestore.collection("bots").doc(widget.botName).collection(widget.docId)
    .where('id', isEqualTo: cnt).get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Bubble rmsg = this.makeBubble(doc.get('msg'), false);
        int sec = doc.get('msg').toString().length * 150; // 글자 길이에 따라 답장 속도
        Future.delayed(Duration(milliseconds: sec)).then((_) {
          setState(() {
            _messages.insert(0,rmsg);
          });
          rmsg.animationController.forward();
        });
      });
    });
  }

  void getMsgSize(){
    firestore.collection('bots').doc(widget.botName).collection(widget.docId)
    .get().then((snap) {
      size = snap.size;
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
    if(size == 0){ this.getMsgSize();}
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


