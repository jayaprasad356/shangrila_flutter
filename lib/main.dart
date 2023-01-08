import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room_rent/homeScreen.dart';
import 'package:room_rent/services/apiCall.dart';
import 'package:room_rent/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Commons/Constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String emailBody;
  late String passwrod;
  late Map<String, dynamic> data;
  late Map<String, dynamic> wallets;
  late bool status;
  late int wallet;
  late int id;
  late bool isRegister;

  @override
  void initState() {

    // Get the value from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isRegister = prefs.getBool(Constant.IS_REGISTER)!;
        if (isRegister) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const HomeScreen(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color(0xFF99deab),
          child: Column(
            children: [
              const SizedBox(
                height: 230,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: TextField(

                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.pink,
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: 'Email',
                  ),
                  onChanged: (value) {
                    emailBody = value;
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.security,
                        color: Colors.pink,
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none
                          // borderSide: BorderSide(color: Colors.white24)
                          //borderSide: const BorderSide(),
                          ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      hintText: 'Password'),
                  onChanged: (value) {
                    // The value variable contains the current value of the TextField
                    // You can use it to set the email body

                    passwrod = value;
                  },
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 45,
                width: 170,
                child: ElevatedButton(
                  onPressed: () async {
                    if (emailBody.isEmpty || passwrod.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Email or Password is Empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      var url = Constant.loginUrl;
                      Map<String, dynamic> bodyObject = {
                        Constant.EMAIL: emailBody,
                        Constant.PASSWORD: passwrod,
                      };
                      try {
                        String jsonString = await apiCall(url, bodyObject);
                        dynamic json = jsonDecode(jsonString);

                        // wallet = json['data'][0];
                        //  id = json['data'][0]['id'];
                        var udate = json['data'][0];
                        wallet = udate['wallet'];

                        id = udate['id'];

                        status = json["success"];
                      } catch (e) {
                        print(e);
                      }

                      if (status) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString(
                            Constant.WALLET_BALANCE, wallet.toString());
                        prefs.setString(Constant.USER_ID, id.toString());
                        prefs.setBool(Constant.IS_REGISTER, true);
                        Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                const HomeScreen(),
                          ),
                          (route) =>
                              false, //if you want to disable back feature set to false
                        );
                      } else {
                        showToast();
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF00f131)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const SignUp()));
                    },
                    child: const Text(
                      "click here to signup",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  showToast() {
    Fluttertoast.showToast(
        msg: "Invalid Email Or Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
