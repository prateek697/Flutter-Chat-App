import 'package:Messenger/services/auth.dart';
import 'package:Messenger/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Messenger/views/charRoomScreen.dart';
import 'package:Messenger/views/forgot_password.dart';
import 'package:Messenger/services/database.dart';
import 'package:Messenger/helper/helperfunction.dart';
import 'package:Messenger/helper/theme.dart';


class SignIn extends StatefulWidget   {
  final  Function changestate;
  SignIn({this.changestate});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  QuerySnapshot snapshot;
  bool isloading=false;
  SignInMe()
  {
    if(formkey.currentState.validate())
    {
      setState(() {
        isloading=true;
      });
      print("working ok");
      return authMethods.signInWithEmailandPassword(EmailidTextEditingController.text, PasswordTextEditingController.text).then((value) async {
        HelperFunctions.SaveUserLoggedInSharedPreference(true);
        print(EmailidTextEditingController.text);
        await databaseMethods.getUserByUserEmail(EmailidTextEditingController.text).then((val) async{
          snapshot=val;
          //print(snapshot.documents);
          print("username is ");
          HelperFunctions.SaveUserNameSharedPreference(snapshot.documents[0].data["name"]);
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=> ChatRoom(Email: EmailidTextEditingController.text),
        ));
      });
    }

  }
  final formkey =GlobalKey<FormState>();
  TextEditingController EmailidTextEditingController=TextEditingController();
  TextEditingController PasswordTextEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESSENGER',style: TextStyle(fontSize: 20,
          color: Colors.white,
          letterSpacing: 1.5,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body:  isloading ? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
        child: Container(
            height:MediaQuery.of(context).size.height-90,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomCenter,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(

                        validator: (val)=> val.length==0 ? "This field is empty" : null,
                        controller: EmailidTextEditingController,
                        style:TextStyle(color: Colors.black,fontSize: 20),
                        decoration:signinfields('E-mail'),

                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val)=> val.length<=6 ? "Required password length >= 7" : null
                        ,controller: PasswordTextEditingController,
                        style:TextStyle(color: Colors.black,fontSize: 20),
                        decoration:signinfields('Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password?',style: TextStyle(color: Colors.black,fontSize: 15),),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color: Colors.blue[600]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 130,vertical: 20),
                    child: GestureDetector(
                        onTap:(){SignInMe();},
                        child: Text('Sign In',style: TextStyle(color: Colors.black),)),
                  ),
                ),
                SizedBox(height:20,),
                Container(

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.red[500]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 100),
                    child: Text('Sign In with Google',style: TextStyle(color: Colors.black),),
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Not Having Account ? ",style: TextStyle(color: Colors.black54),),
                    SizedBox(width: 5,),
                    GestureDetector(
                        onTap: (){
                          widget.changestate();
                        },
                        child: Text("Register now",style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),))
                  ],
                ),
                SizedBox(height: 40,)


              ],
            )

        ),
      ),
    );
  }
}
