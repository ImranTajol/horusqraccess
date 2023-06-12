//OTP_Register.dart


import 'package:qr_code/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTP_Check extends StatefulWidget {
  @override
  _OTP_CheckState createState() => _OTP_CheckState();
}

class _OTP_CheckState extends State<OTP_Check> {
  TextEditingController _userInputController = TextEditingController();
  bool _dataMatched = false;
  bool _showFailureMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Matching Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userInputController,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String userInput = _userInputController.text;
                if (userInput.isEmpty) {
                  return;
                }

                try {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('Registration_OTP')
                      .where('otp', isEqualTo: userInput)
                      .get();
                  if (querySnapshot.docs.isNotEmpty) {
                    // Display the retrieved data
                    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                      print('Found data: ${documentSnapshot.data()}');
                      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                      bool used = data['Used'];
                      if (used) {
                        setState(() {
                          _dataMatched = false;
                          _showFailureMessage = true;
                        });
                      } else {
                        // Update 'Used' field to true
                        documentSnapshot.reference.update({'Used': true});
                        setState(() {
                          _dataMatched = true;
                          _showFailureMessage = false;
                        });
                      }
                    }
                  } else {
                    print('No matching documents found');
                    setState(() {
                      _showFailureMessage = true;
                    });
                  }
                } catch (e) {
                  print('Error retrieving user data: $e');
                }
              },
              child: Text('Check'),
            ),
            if (_dataMatched && !_showFailureMessage)
              Column(
                children: [
                  Text('Key matched! You may proceed to register.'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            if (_showFailureMessage)
              Column(
                children: [
                  Text('Key invalid or already used. \nPlease try again or contact the management for assistance.'),
                  SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
