import 'package:Messenger/services/auth.dart';
import 'package:Messenger/views/conversation_screen.dart';
import 'package:Messenger/views/signin.dart';
import 'package:Messenger/views/search.dart';
import 'package:Messenger/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Messenger/helper/authenticate.dart';
import 'package:Messenger/helper/constants.dart';
import 'package:Messenger/helper/helperfunction.dart';
import 'package:Messenger/services/database.dart';
import 'package:Messenger/helper/theme.dart';
/// chatroomid
class ChatRoom extends StatefulWidget {
  @override
  String Email;

  ChatRoom({this.Email});
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  @override
  //int x=0;
  Stream chatroomstream;
  Widget ChatRoomList()
  {
    return  StreamBuilder(
      stream: chatroomstream,
      builder: (context,snapshot)
      {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              // print("one");
              // print(Constants.myName);
              return ChatRoomtile(username: snapshot.data.documents[index].data["chatroomid"].
              toString().replaceAll("_", "").replaceAll(Constants.myName, ""),chatroomid: snapshot.data.documents[index].data["chatroomid"],);
            }): Container();
      },
    );
  }

  void initState()
  {
    getuserinfo();



  }

  getuserinfo() async
  {
    Constants.myName=await HelperFunctions.GetUserNameSharedPreference();
    await databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatroomstream=val;
      });
    });
    // print(Constants.myName);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('CHATS',style: TextStyle(color: Colors.white,letterSpacing: 2.0),),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push( context,MaterialPageRoute(builder: (BuildContext context) => Search()));
              },
              child: Container(padding:EdgeInsets.symmetric(horizontal: 10),child: Icon(Icons.search))),
          GestureDetector(
              onTap: ()async {
                await HelperFunctions.SaveUserLoggedInSharedPreference(false);
                authMethods.SignOut();
                Navigator.pushReplacement( context,MaterialPageRoute(builder: (BuildContext context) => Authenticate()));
              },
              child: Container(padding:EdgeInsets.symmetric(horizontal: 20),child: Icon(Icons.exit_to_app)))
        ],
      ),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(
              builder: (context)=>Search()

          ));
        },
      ),
      body: ChatRoomList(),

    );
  }
}
class ChatRoomtile extends StatelessWidget {
  @override
  String username="username";
  String chatroomid;
  ChatRoomtile({this.username,this.chatroomid});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=>ConversationScreen(chatroomid: chatroomid,personusername: username,)
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          color: Colors.blue[50],
          child: Row(
            children: <Widget>[
              Container(

                child: Text(username.length >0 ? username.substring(0,1).toUpperCase() : "ChatHere",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ),
              SizedBox(width: 20,),
              Container(

                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color:Colors.blue[100],shape: BoxShape.rectangle,borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0))),
                child: Text(username.toUpperCase(),style: TextStyle(color: Colors.black,letterSpacing: 1.5),),
              ),






            ],
          ),
        ),
      ),
    );
  }
}
