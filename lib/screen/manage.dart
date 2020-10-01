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
              MaterialPageRoute(builder: (context) => EditScreen(bot: bots[index]))
            );
          },
        );
      }
    );
  }
}

class EditScreen extends StatelessWidget{
  final Bot bot;
  EditScreen({Key key, @required this.bot}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text(bot.description),),
      body: Center(
        child:
          SizedBox(
          width: 400,
          height: 600,
          child: GetMessages(bot.name)
          
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
          Text(msg, 
                style: TextStyle(fontSize: 15))
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