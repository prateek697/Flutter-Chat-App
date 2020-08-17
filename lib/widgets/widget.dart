import 'package:flutter/material.dart';

AppBar appbarfunction(context)
{
  return AppBar(
      backgroundColor: Colors.blue,
      title : Text(
        "MESSENGER",
        style:TextStyle(
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1.5,
        ) ,
      )
  );
}
InputDecoration signinfields(String hint)
{
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.black54
      ,fontSize: 15,
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color:Colors.white)
    ),
    focusColor: Colors.orange,

  );
}
