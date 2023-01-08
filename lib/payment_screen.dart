import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_rent/Commons/utils.dart';
import 'package:room_rent/homeScreen.dart';
import 'package:room_rent/services/apiCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Commons/Constant.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen( {Key? key}) : super(key: key);
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late int total;
  late String emrDay,emrNight,gmr,date,userId;
  @override
  void initState() {
    super.initState();

    // Get the value from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        total = prefs.getInt(Constant.TOTAL_AMOUNT)!;
        emrDay=prefs.getString(Constant.EMR_DAY)!;
        emrNight=prefs.getString(Constant.EMR_NIGHT)!;
        gmr=prefs.getString(Constant.GMR)!;
        date=prefs.getString(Constant.DATE)!;
        userId=prefs.getString(Constant.USER_ID)!;

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF99deab),

        body: Column(
      children: [
        const SizedBox(
          height: 150,
        ),
        //todo wallet balance
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF00f131)),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Text('Total Amout is : $total'),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF00f131)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)))),
            child: const Text("PAY NOW"),
            onPressed: () async{
              String url = Constant.PAYBILL_URL;


              Map<String, dynamic> bodyObject = {
                Constant.USER_ID: userId,
              //  Constant.EMR_DAY: emrDay,
              //  Constant.EMR_NIGHT: emrNight,
              //  Constant.GMR: gmr,
                Constant.DATE: date,
                "total":total.toString()
              };
              String jsonString = await apiCall(url, bodyObject);
              dynamic json = jsonDecode(jsonString);
              bool status = json["success"];
              String msg = json["message"];

              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              if(status){
                int wallet = json['data'][0]['wallet'];
                prefs.setString(Constant.WALLET_BALANCE, wallet.toString());

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()),
                    ModalRoute.withName('/')
                );
                Utils().showToast(msg);
              }else{
                Utils().showToast(msg);
              }





            },
          ),
        ),
      ],
    ));
  }
}
