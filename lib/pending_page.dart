import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_code/generate_qr_page.dart';
import 'package:qr_code/qr_image.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import  'package:intl/intl.dart';
import 'package:qr_code/login_page.dart';
import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';

  
  class pending extends StatefulWidget {
    @override
    State<pending> createState() => _pendingState();
    final TextEditingController controllerFullName;
    final housefloor;
    final housenumber;
    final randomNumber;

    pending(this.controllerFullName,this.housefloor,this.housenumber, this.randomNumber,{super.key});

  }
  
  class _pendingState extends State<pending> {

    bool isConditionMet = false;

    @override
    void initState() {
      super.initState();
      checkCondition().then((value) {
        setState(() {
          isConditionMet = value;
        });
      });
    }
    //boolean function
    Future<bool> checkCondition() async {
      bool condition = false;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('qr_generated') // Replace with your actual collection
          .doc(widget.randomNumber.toString()) // Replace with your actual document ID
          .get();
      if(snapshot.exists)
        {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

          if (data != null)
          {
                condition = true;
                dynamic fieldValue = data["id"];

                // Process the field value
                print('Field Value: $fieldValue');
                return condition;
          }
        }
      return condition;
    }

    void periodicFuncForCheckStatus()
    {
      Timer.periodic(const Duration(seconds: 10), (timer) {
        checkCondition();
        //timer.cancel();
      });
    }

    //RETRIEVE DATA FROM FIRESTORE
    Future<bool> retrieveData() async
    {
      bool condition = false;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('qr_generated').doc(widget.randomNumber.toString()).get();
      if(snapshot.exists)
      {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null)
        {
          // Access the specific field using its key
          if(data["status"] == "approved")
            {
              condition = true;
              return condition;
            }
        }
        else
          {
            print("Process pending...");
            return  condition;
          }
      }
      return condition;
    }//end func retrieveData

    Future<bool> checkStatus() async
    {
      bool condition = false;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('qr_generated').doc(widget.randomNumber.toString()).get();
      if(snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data["status"] != "approved") {
            condition = true;
            print("QR process pending...");
            return Future.value(false);
          }
          else {
            print("QR approved!");
            return Future.value(true);
          }
        }
      }
      return condition;
    }//end func

    void getQRstatus(fullName, housefloor, housenumber, randomNumber) async {
      bool statusChecked = await checkStatus();

      if (statusChecked) {
        print(statusChecked);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRImage(
              fullName,
              housefloor,
              housenumber,
              randomNumber,
            ),
          ),
        );
      }
      else
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Horus QR Access"),
                content: new Text("Your request is pending."),
                actions: <Widget>[
                  new ElevatedButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print(statusChecked);
          print("QR request is still pending...");
        }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Horus QR Access'),
        ),
        body: ListView(
          children:
          [
            Center
              (
              child: isConditionMet
              ? ElevatedButton
                (
                  onPressed: ()
                  {
                    getQRstatus(widget.controllerFullName,widget.housefloor,widget.housenumber,widget.randomNumber.toString());
                    // print("The return value of check Status function: ${var_checkStatus}");
                  },
                    child: Text('Show QR Code'),
                )
              : Container(),
              ),
            Center(
              child: Text(''),
            ),
        ],
        ),
      );
    }
  }




