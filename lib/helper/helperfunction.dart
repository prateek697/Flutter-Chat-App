import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey="ISLOGGEDIN";
  static String sharedPreferenceUsernameKey="USERNAMEKEY";
  static String sharedPreferenceUserEmailKey="EMAILKEY";

  static Future<bool> SaveUserLoggedInSharedPreference(bool isLoggedIn) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }

  static Future<bool> SaveUserNameSharedPreference(String Username) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsernameKey , Username);
  }
  static Future<bool> SaveUserEmailSharedPreference(String Email) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey , Email);
  }

  static Future<bool> GetUserLoggedInSharedPreference() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> GetUserNameSharedPreference() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUsernameKey);
  }


  static Future<String> GetUserEmailSharedPreference() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

}


