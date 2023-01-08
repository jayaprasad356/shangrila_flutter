import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:room_rent/Commons/utils.dart';
import 'package:room_rent/main.dart';
import 'package:room_rent/services/apiCall.dart';

import 'Commons/Constant.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailbody = TextEditingController();
  final password = TextEditingController();
  final numberOfBedrooms = TextEditingController();
  final evcCode = TextEditingController();
  late bool status;
  late String msg;

  Utils utils = Utils();
  static const List<String> list = <String>['Detached', 'Two', 'Three', 'Four'];

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00f131),
        title: const Text("My App"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF99deab),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              //todo email TextField
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: TextField(
                  controller: emailbody,
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
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //todo password TextField
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: password,
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
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                  "Property Type",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //todo Dropdown
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: const EdgeInsets.only(right: 20, left: 20),
                width: double.infinity,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  iconEnabledColor: Colors.transparent,
                  iconDisabledColor: Colors.transparent,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  dropdownColor: const Color(0xFF99deab),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //todo number of BedRooms
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: numberOfBedrooms,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.bedroom_child_sharp,
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
                      hintText: 'Number of Bedrooms'),
                ),
              ),
              //todo EVC code
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: evcCode,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.qr_code,
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
                      hintText: 'EVC code'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: 170,
                child: ElevatedButton(
                  onPressed: () async {
                    if (emailbody.text.isEmpty) {
                      utils.showToast("email is empty");
                    } else if (password.text.isEmpty) {
                      utils.showToast("password is empty");
                    } else if (dropdownValue.isEmpty) {
                      utils.showToast("property type is empty");
                    } else if (numberOfBedrooms.text.isEmpty) {
                      utils.showToast("bedroom count is empty");
                    } else if (evcCode.text.isEmpty) {
                      utils.showToast("evc code is empty");
                    } else {
                      var url = Constant.signupUrl;
                      Map<String, dynamic> bodyObject = {
                        Constant.EMAIL: emailbody.text,
                        Constant.PASSWORD: password.text,
                        Constant.PROPERTY_TYPE: dropdownValue,
                        Constant.BEDROOMS_COUNT: numberOfBedrooms.text,
                        Constant.EVC_CODE: evcCode.text
                      };

                      try {
                        String jsonString = await apiCall(url, bodyObject);
                        dynamic json = jsonDecode(jsonString);

                        msg = json["message"];
                        status = json["success"];
                      } catch (e) {
                        // An error occurred

                      }

                      // Get the success field

                      if (status) {
                        utils.showToast(msg);
                        Navigator.pop(context);
                      } else {
                        utils.showToast(msg);
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF00f131)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  child: const Text("SignUp"),
                ),
              ),
              const SizedBox(
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
