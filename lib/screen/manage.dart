import 'package:chatbot/screen/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('managing messages'),),
      body: Center(
        child:
          SizedBox(
          width: 400,
          height: 600,
          child: BotList(bots: [Bot('mebot','나'), Bot('youbot', '너'), Bot('webot', '우리'), Bot('together', '단체채팅방')]),
        ),
      ),
    );
  }
}

class Bot{
  final String name;
  final String description;
  Bot(this.name, this.description);
}

class BotList extends StatelessWidget{
  final List<Bot> bots;
  BotList({Key key, @required this.bots}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: bots.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(bots[index].name),
          onTap: (){
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => EditScreen(bots[index]))
            );
          },
        );
      }
    );
  }
}

class EditScreen extends StatefulWidget{
  final Bot bot;
  EditScreen(this.bot);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _textController = TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'message'),
              controller: _textController,
              onChanged: (String text){
                setState((){
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted,
            ),
          ),
          Container( 
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: FlatButton(
                child: Text('추가'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: _isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
            ),
          )
        ]
      )
    );
  }
  void _handleSubmitted(String text) {
    firestore.collection(widget.bot.name).add({'name': widget.bot.description, 'id': 3, 'msg': text});
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    print(text);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text(widget.bot.description),),
      body: Center(
        child:
          SizedBox(
          width: 400,
          height: 600,
          child: Column(
            children:[
            this._buildTextComposer(),
            Flexible(child: GetMessages(widget.bot.name),)
            ]
          )
          ),
        ),
      );
  }
}

class MsgTile extends StatelessWidget{
  final bot, id ,msg;
  MsgTile(this.bot, this.id, this.msg);

  @override
  Widget build(BuildContext context){
    return Container(      
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: Text(id.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              child: Text(bot[0]), radius: 16, foregroundColor: Colors.green,
          )),
          msg != null ?
          Expanded(child: Text(msg, 
                style: TextStyle(fontSize: 15)))
          : Text(" ")
        ],)
      )
    );
  }
}

class GetMessages extends StatelessWidget{
  final botName; GetMessages(this.botName);
  @override
  Widget build(BuildContext context){
    CollectionReference firestore = FirebaseFirestore.instance.collection(botName);

    return FutureBuilder<QuerySnapshot>(
      future: firestore.orderBy('id').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot){
        if(querySnapshot.hasError){
          return Text("failed");
        }
        
        if (querySnapshot.connectionState == ConnectionState.done) {
          List<MsgTile> msgs  = new List<MsgTile>();
          querySnapshot.data.docs.forEach((chat) {
            msgs.add(MsgTile(chat.get('name'), chat.get('id'), chat.get('msg')));
          });

          return ListView(children: msgs);
        }

        return Text("");
      },
    );

    
  }
}