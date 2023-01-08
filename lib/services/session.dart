// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GlobalSharedPreferences {
//   static late GlobalSharedPreferences _instance;
//   static late SharedPreferences _preferences;
//
//   static Future<GlobalSharedPreferences> get instance async {
//     if (_instance == null) {
//       _instance = GlobalSharedPreferences._();
//       _preferences = await SharedPreferences.getInstance();
//     }
//     return _instance;
//   }
//
//   GlobalSharedPreferences._();
//
//   static setString(String key, String value) {
//     _preferences.setString(key, value);
//   }
//
//   String getString(String key) {
//     return _preferences.getString(key) ?? '';
//   }
//
//
// // Add more methods for other data types as needed
// }
