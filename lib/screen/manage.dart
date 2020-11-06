import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          child: BotList(bots: [Bot('intro','나'),Bot('mebot','나'), Bot('youbot', '너'), Bot('webot', '우리'), Bot('together', '단체채팅방', true)]),
        ),
      ),
    );
  }
}

class Bot{
  final String name;
  final String description;
  bool many;
  Bot(this.name, this.description, [this.many= false]);
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

List<String> tog_option = ["나", "너", "우리"];
List<String> qa_option = ["일반", "질문", "답"]; //Q, A, Nothing

class _EditScreenState extends State<EditScreen>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Chat> chatlist = new List<Chat>();
  int size = 0;
  final _textController = TextEditingController();
  final _updateMsgController = TextEditingController();
  final _updateIdController = TextEditingController();

  List<String> _botnames = ['나', '너', '우리'];
  String _character;
  String _qORa = "";

  void getMsgSize(){
    firestore.collection(widget.bot.name)
    .get().then((snap) {
      size = snap.size;
    });
  }

  Widget _buildRadioBtn(String name){
    if(name == 'together'){
      _character = "나";
      return Row(
      children: <Widget>[
        Expanded(child: ListTile(
          title: Text(tog_option[0]),
          leading: Radio(
            value: tog_option[0],
            groupValue: _character,
            onChanged: (String value) {
              setState(() {
                _character = value;
              });
            },
          ),
        )),
        Expanded(child: ListTile(
          title: Text(tog_option[1]),
          leading: Radio(
            value: tog_option[1],
            groupValue: _character,
            onChanged: (String value) {
              setState(() {
                _character = value;
              });
            },
          ),
        )),
        Expanded(child: ListTile(
          title: Text(tog_option[2]),
          leading: Radio(
            value: tog_option[2],
            groupValue: _character,
            onChanged: (String value) {
              setState(() {
                _character = value;
              });
            },
          ),
        )),
        ]
      );
    }
    else if(name == "mebot"){
      return Row(
      children: <Widget>[
        Expanded(child: ListTile(
          title: Text(qa_option[0]),
          leading: Radio(
            value: "",
            groupValue: _qORa,
            onChanged: (String value) {
              setState(() {
                _qORa = value;
              });
            },
          ),
        )),
        Expanded(child: ListTile(
          title: Text(qa_option[1]),
          leading: Radio(
            value: "0",
            groupValue: _qORa,
            onChanged: (String value) {
              setState(() {
                _qORa = value;
              });
            },
          ),
        )),
        Expanded(child: ListTile(
          title: Text(qa_option[2]),
          leading: Radio(
            value: "1",
            groupValue: _qORa,
            onChanged: (String value) {
              setState(() {
                _qORa = value;
              });
            },
          ),
        )),
        ]
      );
    }
    else{
      return Text("");
    }
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
    CollectionReference db = firestore.collection(widget.bot.name);
    int newSize = size + 1;
    if(_character == null) _character = widget.bot.description;
    db.add({'name': _character, 'id': newSize, 'msg': text, 'unique': _qORa + randomString(8)});
    
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
    setState((){});
  }

  void _onModified(String unique){
    showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("수정 내용을 입력하세요"),
          content: TextField(
              controller: _updateMsgController,
          ),
          actions: [
            FlatButton(
              child: Text("확인"),
              onPressed: (){this._handleUpdated(unique, _updateMsgController.text, "msg"); Navigator.pop(context);},
            ),
            FlatButton(
              child: Text("취소"),
              onPressed: (){Navigator.pop(context);},
            )
          ],
        );
      }
    );
  }
  
  void _handleUpdated(String unique, dynamic value, String field){
    _updateMsgController.clear();
    
    firestore.collection(widget.bot.name).where('unique', isEqualTo: unique)
    .get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({field: value});
      });
    });
    setState((){});

  }

  void _onIdModified(String unique){
    showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("순서를 입력하세요"),
          content: TextField(
              controller: _updateIdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'number only'),
              inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
              ],
          ),
          actions: [
            FlatButton(
              child: Text("확인"),
              onPressed: (){
                try{
                this._handleUpdated(unique, int.parse(_updateIdController.text), "id"); Navigator.pop(context);
                }catch(e){}
              },
            ),
            FlatButton(
              child: Text("취소"),
              onPressed: (){Navigator.pop(context);},
            )
          ],
        );
      }
    );
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
            this._buildRadioBtn(widget.bot.name),
            this._buildTextComposer(),
            Flexible(child: GetMessages(widget.bot.name, this._onDeleted, this._onModified, this._onIdModified)),
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
  final Function(String) _onIdModified;

  MsgTile(this.chat, this._onDeleted, this._onModified, this._onIdModified);

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
                child: TextButton(
                  child: Text(chat.id.toString()),
                  onPressed: () => _onIdModified(chat.unique),
                )
              ),
              chat.unique.length == 9 ?  
                  chat.unique[0] == '0' ? //QUESTION
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      child: Text("Q"), radius: 16, foregroundColor: Colors.amber,
                  ))
                  : //ANSWER
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      child: Text("A"), radius: 16, foregroundColor: Colors.red,
                  ))
                : 
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
  final Function(String) _onIdModified;

  GetMessages(this.botName, this._onDeleted, this._onModified, this._onIdModified);
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
            msgs.add(MsgTile(my, this._onDeleted, this._onModified, this._onIdModified));
          });

          return ListView(children: msgs);
        }

        return Text("");
      },
    );

    
  }
}