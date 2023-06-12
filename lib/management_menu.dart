//management_menu.dart

import 'package:qr_code/main.dart';
import 'package:flutter/material.dart';
import 'list_application.dart';
import 'package:qr_code/generate_OTP.dart';
import 'package:qr_code/Management_Login_page.dart';
import 'auth_page.dart';
import 'UI_Selection.dart';

class ManagementUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DisplayApplication()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayApplication()),);


                // Navigate to view requested QR generation page
              },
              child: Text('View Requested QR Generation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationOTPGenerator(),),);
                // Navigate to generate OTP page
              },
              child: Text('Generate OTP'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          //Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              ManagementLoginScreen()), (Route<dynamic> route) => false);
          // Navigate to UI_Choose page
        },
        child: Container(
          height: 50,
          color: Colors.indigo,
          alignment: Alignment.center,
          child: Text(
            'Sign Out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,

            ),
          ),
        ),
      ),

    );
  }
}
