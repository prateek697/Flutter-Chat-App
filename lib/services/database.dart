import 'package:Messenger/views/charRoomScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DatabaseMethods{
  getUserByUsername (String username) async
  {
    return await Firestore.instance.collection("users").where("name",isEqualTo:username).getDocuments();
  }
  getUserByUserEmail(String UserEmail) async
  {
    return await Firestore.instance.collection("users").where("Email",isEqualTo: UserEmail).getDocuments();
  }

  uploadUserInfo(userMap)
  {
    Firestore.instance.collection("users").add(userMap);
  }
  createChatRoom(String chatRoomid , userMap)
  {
    Firestore.instance.collection("ChatRoom").document(chatRoomid).setData(userMap).catchError((e){
      print(e.toString());
    });
  }
  addconversationmessages(String ChatRoomid,messagemap)
  {
    Firestore.instance.collection("ChatRoom").document(ChatRoomid).collection("chats").add(messagemap).catchError((e){
      print(e.toString());
    });
  }
  getconversationmessages(String ChatRoomid) async
  {
    return await Firestore.instance.collection("ChatRoom").document(ChatRoomid).collection("chats").
    orderBy("time",descending: false).snapshots(); // IT IS USED TO BRING THE WHOLE STREAM
  }
  getChatRooms(String username) async
  {
    return await Firestore.instance.collection("ChatRoom").where("users",arrayContains: username).snapshots();
  }

}