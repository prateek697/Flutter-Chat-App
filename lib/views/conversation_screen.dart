
import 'package:Messenger/helper/constants.dart';
import 'package:Messenger/services/database.dart';
import 'package:Messenger/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  String chatroomid;
  String personusername="conversation";
  ConversationScreen({this.chatroomid,this.personusername});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messagecontroller=new TextEditingController();
  DatabaseMethods databaseMethods=new  DatabaseMethods();
  Stream chatmessagestream;

  sendmessage()
  {
    if(messagecontroller.text.length!=0)
    {
      Map<String,dynamic> messagemap={
        "message":messagecontroller.text,
        "sendBy":Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch,
      };
      print(messagecontroller.text);
      print(Constants.myName);
      databaseMethods.addconversationmessages(widget.chatroomid, messagemap);
      messagecontroller.clear();
    }
  }
  @override
  Chatmessagebuilder()
  {
    return StreamBuilder(
      stream: chatmessagestream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            //  print(Constants.myName);
            // print(snapshot.data.documents[index].data["sendBy"]);
            return MessageTile(snapshot.data.documents[index].data["message"],
                snapshot.data.documents[index].data["sendBy"]==Constants.myName);
          },

        ) : Container();
      },
    );
  }
  void initState() {
    databaseMethods.getconversationmessages(widget.chatroomid).then((value){
      if(value!=null)
      {
        setState(() {
          chatmessagestream=value;
        });
      }
    });
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(widget.personusername.toUpperCase(),style: TextStyle(color: Colors.white,letterSpacing: 1.5),),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Chatmessagebuilder(),
            Container(
              padding: EdgeInsets.fromLTRB(0,10, 0, 0),
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messagecontroller,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(border:InputBorder.none,hintText: 'Type a message',hintStyle:TextStyle(color: Colors.black)),
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                          sendmessage();
                        },
                        child: Icon(Icons.send))
                  ],
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
class MessageTile extends StatelessWidget {
  @override
  String message="message";
  bool issendbyme=false;
  double radius =23.0;
  MessageTile(this.message,this.issendbyme);
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: issendbyme ? 12 : 8),
      alignment: issendbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        decoration: BoxDecoration(
            color: issendbyme ? Colors.amber[50] : Colors.white
            ,borderRadius: issendbyme ? BorderRadius.only(
            topLeft:Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius)
        ) : BorderRadius.only(
            topLeft:Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius)
        )),
        child: Text(message,style: TextStyle(fontSize: 18, color: Colors.black),),

      ),
    );
  }
}

