import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_code/pending_page.dart';
import 'package:qr_code/callfunction.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import  'package:intl/intl.dart';
import 'package:qr_code/login_page.dart';
import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';

int randNum = 0;
int i=0;
String name = '';
String housefloor = '';
String housenumber = '';


//better to make a loop to create list
const List<String> houseFloorList = <String>['1', '2', '3', '4','5','6','7','8','9','10'];
const List<String> houseNumberList = <String>['1', '2', '3', '4','5','6','7','8','9','10'];

//Function to store at RealTime Firebase
Future <void>addUserRealTime(String Name, String HouseFloor, String HouseNumber, int num) async
{
  DateTime now = DateTime.now();
  DateTime expired = now.add(Duration(minutes: 10));

  //Finding idea to compare time for 10 minute expiration
  // if(expired.minute - now.minute == 10)
  //   {
  //
  //   }

  String create_time = DateFormat("HH:mm:ss").format(now);
  String expired_time = DateFormat("HH:mm:ss").format(expired);
  print(create_time);
  print(expired_time);

  //FirebaseDatabase db = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

    // Map<String, String>qrCodeData ={
    //   "id": num.toString(),
    //   "full_name": Name, // John Doe
    //   "house_floor": HouseFloor, // 6
    //   "house_number": HouseNumber, // 12
    //   "time_create": create_time,
    //   "time_expires": expired_time,
    //   "timestamp": 1800000.toString()
    // };

  Map<String, dynamic> dataToStore ={
    "id": num.toString(),
    "full_name": Name, // John Doe
    "house_floor": HouseFloor, // 6
    "house_number": HouseNumber, // 12
    "time_create": create_time,
    "time_expires": expired_time,
    "timestamp": 300000
  };


  ref.child("QRCode").child(num.toString()).set(dataToStore);

}

//Function to store using Firestore
Future <void>addUser(String Name, String HouseFloor, String HouseNumber, int num) async
{
  final db = FirebaseFirestore.instance;
  DateTime create_time = DateTime.now();
  DateTime expired_time = create_time.add(Duration(minutes: 10));

  final now_minute = create_time.minute;
  final expired_minute = expired_time.minute;

  print('Now_minute:  $now_minute');
  print('Expired_minute: $expired_minute');

  Map<String, dynamic> dataToStore = {
    "id": num.toString(),
    "full_name": Name, // John Doe
    "house_floor": HouseFloor, // 6
    "house_number": HouseNumber, // 12
    "time_create": create_time,
    "time_expires": expired_time,
    "status": "pending",
    "qr_data": "{\"id\":$num,\"name\":\"$Name\",\"house_floor\":$HouseFloor,\"house_number\":$HouseNumber}"
  };
  await db.collection("qr_generated").doc(num.toString()).set(dataToStore);
  await db.collection("request_management").doc(num.toString()).set(dataToStore);

}// end addUser

//RETRIEVE DATA FROM FIRESTORE
void retrieveData()
{
  final db = FirebaseFirestore.instance;
  Timestamp t = new Timestamp(0, 0);
  String doc_ID;
  DateTime now = DateTime.now();
  DateTime newData;
  Duration diff;
  int limitTime = 10 * 60;
  var exceedMinutes = [];
  db.collection('qr_generated').get().then((snapshot) => {
    print('Date Now: $now'),
    if(snapshot != 0)
      {
        //iterate snapshots(data from database)
        for(var i in snapshot.docs)
          {
            doc_ID = i.get('id'), //store id(string type) into variable
            t = i.get('time_create'), //obtain timestamp data
            newData = t.toDate(), //timestamp -> dateTime
            diff = now.difference(newData), //current time - data created time
            print('$doc_ID || ${diff.inSeconds}'),

            //check the respective data with limit Time(10minutes)
            if(diff.inSeconds > limitTime)
              {
                exceedMinutes.add(doc_ID)
              },
          },

        //print list of ID exceed
        print(exceedMinutes),

        //delete document which id have in exceedMinutes List
        for(var id in exceedMinutes)
          {
            db.collection("qr_generated").doc(id).delete().then(
                    (doc) => print("Document $id deleted"),
                onError: (e) => print("Error updating document $e")
            )},
      }
    else{
      print('Empty Snapshot')
    }

  }); //.then(snapshot)

}//end func retrieveData
void periodicTimerFunc()
{
  Timer.periodic(Duration(seconds: 10), (timer) {
    retrieveData();
    //timer.cancel();
  });
}


int generateRandomNumber()
{
  var random = Random();
  int randNumber  = random.nextInt(8999999);
  print('randNum before add 1000000: $randNumber');
  randNumber = randNumber + 1000000;
  return randNumber;
}

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerHouseFloor = TextEditingController();
  TextEditingController controllerHouseNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horus QR Access'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: controllerFullName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Full Name '),
            ),
          ),
          Container(
            child: Center(
              child: Text('House Floor:'),
            )
          ),
          Container(
            child: Center(
                child: HouseFloorDropDownButton(),
            ),
          ),
          Container(
              child: Center(
                child: Text('House Number:'),
              )
          ),
          Container(
            child: Center(
              child: HouseNumberDropDownButton(),
            ),
          ),

          //This button when pressed navigates to QR code generation
          ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      print(controllerFullName);
                      randNum = generateRandomNumber();
                      name = controllerFullName.text;

                      //JSON format in console
                      print('{\"name\":$name,\"house_floor\":$housefloor,\"house_number\":$housenumber}');
                      addUser(name, housefloor, housenumber,randNum);
                      //addUserRealTime(name, housefloor, housenumber,randNum);
                      return pending(controllerFullName,housefloor,housenumber,randNum);
                    }),
                  ),
                );
              },
              child: const Text('GENERATE QR CODE')
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)
              ),
              onPressed: () async {
                  //if logged out, directed to LoginScreen()
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginScreen()), (Route<dynamic> route) => false);
              },
              child: const Text("Log Out",
                  style: TextStyle
                    (
                    color: Colors.white,
                    fontSize: 18.0,
                  )
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CallPage()));
                      return callFunc();
                      }),
                    ),
                  );
                },
                child: const Text('Contact Us')
            )
          )
        ],
      ),
    );
  }
}

//class for House Floor
class HouseFloorDropDownButton extends StatefulWidget {
  const HouseFloorDropDownButton({super.key});

  @override
  State<HouseFloorDropDownButton> createState() => _HouseFloorDropDownButtonState();
}

class _HouseFloorDropDownButtonState extends State<HouseFloorDropDownButton> {
  String housefloorvalue = houseFloorList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: housefloorvalue,
      hint: Align(
        child: Text('House Floor: '),
      ),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          housefloorvalue = value!;
          housefloor = value!;
        });
      },
      items: houseFloorList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),

    );

  }

}

//class for House Number
class HouseNumberDropDownButton extends StatefulWidget {
  const HouseNumberDropDownButton({super.key});

  @override
  State<HouseNumberDropDownButton> createState() => _HouseNumberDropDownButtonState();
}

class _HouseNumberDropDownButtonState extends State<HouseNumberDropDownButton> {
  String housenumbervalue = houseNumberList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: housenumbervalue,
      hint: Align(
        child: Text('House Number: '),
      ),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          housenumbervalue = value!;
          housenumber = value;
        });
      },
      items: houseNumberList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),

    );

  }

}
