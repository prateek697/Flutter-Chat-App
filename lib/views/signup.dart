import 'package:Messenger/services/auth.dart';
import 'package:Messenger/views/charRoomScreen.dart';
import 'package:Messenger/widgets/widget.dart';
import 'package:Messenger/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Messenger/helper/helperfunction.dart';
import 'package:Messenger/helper/theme.dart';

class SignUp extends StatefulWidget {
  final Function changestate;
  SignUp({this.changestate});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  bool isloading =false;


  signMeUp() {
    if(formkey.currentState.validate())
    {
      setState(() {
        isloading=true;

      });
      authMethods.signupWithEmailandPassword(EmailidTextEditingController.text, PasswordTextEditingController.text).then((value) {
        print(value.uid);
        Map<String ,String > userMap={
          "Email": EmailidTextEditingController.text,
          "name":UsernameTextEditingController.text
        };
        HelperFunctions.SaveUserLoggedInSharedPreference(true);
        HelperFunctions.SaveUserNameSharedPreference(UsernameTextEditingController.text);
        HelperFunctions.SaveUserEmailSharedPreference(EmailidTextEditingController.text);

        databaseMethods.uploadUserInfo(userMap);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=> ChatRoom()
        ));
      });
    }
  }

  TextEditingController UsernameTextEditingController=TextEditingController();
  TextEditingController EmailidTextEditingController=TextEditingController();
  TextEditingController PasswordTextEditingController=TextEditingController();


  final formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESSENGER',style: TextStyle(fontSize: 20,
            color: Colors.white,
            letterSpacing: 1.5,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: isloading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                        validator: (val){
                          return val.length<=3 ? "Atleast 4 charerters required" : null;},
                        controller: UsernameTextEditingController,
                        style:TextStyle(color: Colors.black,fontSize: 20),
                        decoration:signinfields('Username'),
                      ),
                      TextFormField(
                        validator: (val){
                          return val.length==0 ? "This field is  required" : null;
                        },
                        controller: EmailidTextEditingController,
                        style:TextStyle(color: Colors.black,fontSize: 20),
                        decoration:signinfields('E-mail'),

                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length<=6 ? "Atleast 6 characters required" : null;
                        },
                        controller: PasswordTextEditingController,
                        style:TextStyle(color: Colors.black,fontSize: 20),
                        decoration:signinfields('Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: (){
                    signMeUp();

                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color: Colors.blue[600]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130,vertical: 20),
                      child: Text('Sign Up',style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
                SizedBox(height:20,),
                Container(

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.red[500]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 100),
                    child: Text('Sign Up with Google',style: TextStyle(color: Colors.black),),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already Having Account ?",style: TextStyle(color: Colors.black54),),
                    SizedBox(width: 5,),
                    GestureDetector(
                        onTap: (){
                          widget.changestate();
                        },
                        child: Text(" Sign in ",style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),))
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
