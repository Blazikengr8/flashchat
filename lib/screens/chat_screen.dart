import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:flutter/widgets.dart';
final _firestore= Firestore.instance;
FirebaseUser loggedInUser;
int counter;
class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth=FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  String messageText;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }
  void getCurrentUser() async{
    try{
      final user=await _auth.currentUser();
      if(user!=null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);

              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.yellow[800],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': messageText,
                        'count': counter++,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('count', descending : true).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){return Center(
          child: CircularProgressIndicator(),
        );}
        else
        {
          final messages=snapshot.data.documents;
          List<MessageBubble> messageBubbles=[];
          for(var message in messages)
          {
            final messageText=message.data['text'];
            final messageSender=message.data['sender'];

            final currentUser=loggedInUser.email;




            final messageBubble=MessageBubble(text: messageText,sender: messageSender,isMe: currentUser==messageSender
                ?true
                :false
              ,);
            messageBubbles.add(messageBubble);

          }
          counter=messageBubbles.length;
          for(int i=0;i<messageBubbles.length;i++)
          {

          }
          return Expanded(
            child:

            ListView(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              reverse: true,
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }

}
class MessageBubble extends StatelessWidget{
  MessageBubble({this.text,this.sender,this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children:<Widget>[
          Text(sender,style: TextStyle(color: Colors.white,fontSize: 12.0),),
          Material(
            elevation: 10.0,
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
                : BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            color: isMe?Colors.white38:Colors.blueGrey,
            child:Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text('$text',
                style: TextStyle(fontSize: 15),),
            ),
          ),
        ],
      ),
    );
  }
}
