import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class GetChatroom extends StatelessWidget {
  final String botName;
  final String collId;

  GetChatroom(this.botName, this.collId);

  @override
  Widget build(BuildContext context) {
    CollectionReference chatroom = FirebaseFirestore.instance.collection('bots').doc(botName).collection(collId);
    // CollectionReference bot = FirebaseFirestore.instance.collection('bots');
    final List _messages = [];

    return FutureBuilder<QuerySnapshot>(
      future: chatroom.get(),
      builder: 
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            snapshot.data.docs.forEach((doc) {
              print(doc.get('msg'));
              _messages.insert(0,doc.get('msg'));
            });
            return Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse:true,
                    itemBuilder: (_,int index) => 
                      Text(_messages[index])
                    ,
                    itemCount: _messages.length,
                  ),
                )]
            );
          } 

          return Text("loading");
        },
    );
  }
}
