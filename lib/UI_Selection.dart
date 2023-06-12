//UI_Selection.dart
import 'package:flutter/material.dart';
import 'package:qr_code/login_page.dart';
import 'Management_Login_page.dart';

class UI_Choose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Login Type'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to management login page
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ManagementLoginScreen()));
              },
              child: Container(
                height: 150,
                width: 150,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Management',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(width: 50),
            GestureDetector(
              onTap: () {
                // Navigate to resident login page

                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));

              },
              child: Container(
                height: 150,
                width: 150,
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Resident',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}