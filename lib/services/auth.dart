import 'package:Messenger/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthMethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  User _userfromfirebaseuser(FirebaseUser user)
  {
    return user !=null ?  User(uid: user.uid) : null;
  }
  Future signInWithEmailandPassword(String email,String password) async
  {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseuser=result.user;
      return _userfromfirebaseuser(firebaseuser);

    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  Future signupWithEmailandPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser=result.user;
      return _userfromfirebaseuser(firebaseUser);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
  Future resetpassword(String email)
  {
    try{
      return _auth.sendPasswordResetEmail(email: email);
    }
    catch(e)
    {
      print(e.toString());
      return null;

    }
  }

  Future SignOut() async
  {
    try{
      return await _auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }



}