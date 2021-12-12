import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/constants.dart';
import 'package:quick_chat/screens/welcome_screen.dart';
late User loggedin;
final _firestore=FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static const String id="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  String message="";
  void getcurrentuser() async{
    try{
      final user=await _auth.currentUser;
      if(user!=null){
        loggedin=user;
      }
    }
    catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
                itemBuilder: (context){
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("My Account"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Logout"),
                    ),
                  ];
                },
                onSelected:(value){
                  if(value == 0){
                    print("My account menu is selected.");
                  }else if(value == 1){
                    _auth.signOut();
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  }
                }
            ),
          ],
          title: Text('Quick Chat'),
          backgroundColor: Colors.lightBlueAccent,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Personal',
              ),
              Tab(
                text: 'Group',
              ),
              Tab(
                text: 'Contacts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  StreamBuilder <QuerySnapshot>(
                    stream: _firestore.collection('messages').snapshots(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      final messages=snapshot.data!.docs.reversed;
                      List <MessageBubble> messagesBubbles=[];
                      for(var message in messages){
                        final messageText=message.get('text');
                        final messageSender=message.get('sender');
                        final currentUser=loggedin.email;
                        final messageBubble=MessageBubble(text: messageText,sender: messageSender,isMe: currentUser==messageSender);
                        messagesBubbles.add(messageBubble);
                      }
                      return Expanded(
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          children: messagesBubbles,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: kMessageContainerDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            onChanged: (value) {
                              //Do something with the user input.
                              message=value;
                            },
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                        FlatButton(
                          onPressed: ()
                          {
                            messageTextController.clear();
                            //Implement send functionality.
                            _firestore.collection('messages').add({
                              'sender': loggedin.email,
                              'text': message,
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
            Container(),
          ],
        ),
      ),
    );
  }
}
class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text,required this.sender,required this.isMe});
  String text,sender;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
          ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe?BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ):BorderRadius.only(
          topRight: Radius.circular(30),
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text('$text',
                style: TextStyle(
                  color: isMe?Colors.white:Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}