import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:room_rent/Commons/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:room_rent/payment_screen.dart';
import 'package:room_rent/services/apiCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Commons/Constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateinput = TextEditingController();
  final electricityDay = TextEditingController();
  final electricityNight = TextEditingController();
  final gstMeterReading = TextEditingController();
  Utils u = Utils();

  Utils utils = Utils();
  String _dateText = 'Select Date';
  String _value = '';

  @override
  void initState() {
    super.initState();

    // Get the value from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _value = prefs.getString(Constant.WALLET_BALANCE)!;
      });
    });
  }

  late DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF99deab),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF00f131),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool(Constant.IS_REGISTER, false);
                SystemNavigator.pop();
                // Log the user out
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              (Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF00f131)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        child: const Text("Recharge Wallet"),
                        onPressed: () {
                          showPopup(context);

                          // Button pressed
                        },
                      ),
                    ),
                    //todo wallet balance
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00f131)),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: Text('Wallet Balance: $_value'),
                    )
                  ])),
              const SizedBox(
                height: 50,
              ),
              //todo electricity day
              TextField(
                keyboardType: TextInputType.number,
                controller: electricityDay,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: 'Electricity Meter Reading _ Day'),
              ),
              const SizedBox(
                height: 30,
              ),
              //todo electricity night
              TextField(
                keyboardType: TextInputType.number,
                controller: electricityNight,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: 'Electricity Meter Reading _ Night'),
              ),
              const SizedBox(
                height: 30,
              ),
              //todo Gas meter
              TextField(
                keyboardType: TextInputType.number,
                controller: gstMeterReading,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: 'Gas Meter Reading'),
              ),
              const SizedBox(
                height: 30,
              ),
              //todo date picker
              Container(
                height: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                //color: Colors.cyan,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _dateText =
                            DateFormat('dd-MM-yyyy').format(_selectedDate);
                      });
                    }
                  },
                  readOnly: true,
                  controller: TextEditingController(text: _dateText),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //todo calculate button
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF00f131)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
                child: const Text("CALCULATE"),
                onPressed: () async {
                  if (!(electricityDay.text.isEmpty ||
                      electricityNight.text.isEmpty ||
                      gstMeterReading.text.isEmpty ||
                      _dateText=="Select Date")) {
                    String url = Constant.CALCULATE_BILL_URL;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String userId = prefs.getString(Constant.USER_ID)!;
                    Map<String, dynamic> bodyObject = {
                      Constant.USER_ID: userId,
                      Constant.EMR_DAY: electricityDay.text,
                      Constant.EMR_NIGHT: electricityNight.text,
                      Constant.GMR: gstMeterReading.text,
                      Constant.DATE: _dateText
                    };
                    String jsonString = await apiCall(url, bodyObject);
                    dynamic json = jsonDecode(jsonString);
                    bool status = json["success"];

                    String msg = json["message"];
                    if (status) {
                      int total = json["total_amount"];
                      prefs.setInt(Constant.TOTAL_AMOUNT, total);
                      prefs.setString(Constant.EMR_DAY, electricityDay.text);
                      prefs.setString(
                          Constant.EMR_NIGHT, electricityNight.text);
                      prefs.setString(Constant.GMR, gstMeterReading.text);
                      prefs.setString(Constant.DATE, _dateText);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const PaymentScreen()));
                    } else {
                      u.showToast(msg);
                    }
                  } else {
                    Utils().showToast("Empty fields not allowed");
                  }
                },
              ),
            ],
          ),
        ));
  }

  void showPopup(BuildContext context) {
    TextEditingController evcCode = TextEditingController();
    String userId;

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  controller: evcCode,
                  decoration: const InputDecoration(
                    fillColor: Color(0xFF99deab),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(),
                    filled: true,
                    hintText: 'Enter Evc Code',
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF00f131)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    userId = prefs.getString(Constant.USER_ID)!;
                    var url = Constant.RechargeUrl;
                    Map<String, dynamic> bodyObject = {
                      "user_id": userId,
                      "evc_code": evcCode.text,
                    };
                    String jsonString = await apiCall(url, bodyObject);

                    dynamic json = jsonDecode(jsonString);

                    bool status = json["success"];
                    String msg = json["message"];
                    int wallet = json['data'][0]['wallet'];
                    print(wallet);
                    setState(() {
                      _value = wallet.toString();
                    });
                    if (status) {
                      _value = wallet.toString();
                      prefs.setString(Constant.WALLET_BALANCE, wallet.toString());
                      Navigator.of(context).pop(wallet);
                    } else {
                      Utils u = Utils();
                      u.showToast(msg);
                    }
                  },
                  child: const Text('RECHARGE'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
