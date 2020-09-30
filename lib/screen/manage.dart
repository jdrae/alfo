import 'package:flutter/material.dart';

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
          height: 700,
          child: Card(
            child: BotList(bots: [Bot('mebot','나'), Bot('youbot', '너'), Bot('webot', '우리'), Bot('together', '단체채팅방')]),
          ),
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
          height: 700,
          child: Card(
            child: Column(
              children: [
                Text(bot.description),
                MsgTile("jo", 1, "ho")
              ]
            )
          ),
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
        padding:EdgeInsets.all(15),
        child: 
        msg != null ?
        Text(msg, 
              style: TextStyle(fontSize: 15))
        : Text("fail")
      )
    );
  }
}