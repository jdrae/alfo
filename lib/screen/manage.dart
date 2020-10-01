import 'package:chatbot/screen/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

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

class Chat{
  final String name;
  final int id;
  final String msg;
  final String unique;
  Chat(this.name, this.id, this.msg, this.unique);
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
  List<Chat> chatlist = new List<Chat>();
  int size = 0;
  final _textController = TextEditingController();

  void getMsgSize(){
    firestore.collection(widget.bot.name)
    .get().then((snap) {
      size = snap.size;
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'message'),
              controller: _textController,
              onSubmitted: _handleSubmitted,
            ),
          ),
          Container( 
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: FlatButton(
                child: Text('추가'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => _handleSubmitted(_textController.text),
            ),
          )
        ]
      )
    );
  }
  void _handleSubmitted(String text) {
    String botName = widget.bot.name;
    CollectionReference db = firestore.collection(botName);
    int newSize = size + 1;
    db.add({'name': widget.bot.description, 'id': newSize, 'msg': text, 'unique': randomString(8)});
    _textController.clear();
    
    setState((){size = newSize;});
  }

  void _onDeleted(String unique){
    firestore.collection(widget.bot.name).where('unique', isEqualTo: unique)
    .get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  void _onModified(String unique){
    print(unique);
  }

  @override
  Widget build(BuildContext context){
    if(size == 0){ this.getMsgSize();}

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
            Flexible(child: GetMessages(widget.bot.name, this._onDeleted, this._onModified)),
            ]
          )
          ),
        ),
      );
  }
}

class MsgTile extends StatelessWidget{
  final Chat chat;
  final Function(String) _onDeleted;
  final Function(String) _onModified;
  MsgTile(this.chat, this._onDeleted, this._onModified);

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
                child: Text(chat.id.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  child: Text(chat.name[0]), radius: 16, foregroundColor: Colors.green,
              )),
              chat.msg != null ?
              Expanded(child: Text(chat.msg, 
                    style: TextStyle(fontSize: 15)))
              : Text(" ")
            ,
            TextButton(
              child: Text("수정"),
              onPressed: () => _onModified(chat.unique),
            ),
            TextButton(
              child: Text("삭제"),
              onPressed: () => _onDeleted(chat.unique),
            ),
        ],)
      )
    );
  }
}

class GetMessages extends StatelessWidget{
  final botName; 
  final Function(String) _onDeleted;
  final Function(String) _onModified;

  GetMessages(this.botName, this._onDeleted, this._onModified);
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
            Chat my = Chat(chat.get('name'), chat.get('id'), chat.get('msg'), chat.get('unique'));
            msgs.add(MsgTile(my, this._onDeleted, this._onModified));
          });

          return ListView(children: msgs);
        }

        return Text("");
      },
    );

    
  }
}