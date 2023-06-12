//generate_OTP.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:qr_code/management_menu.dart';


class RegistrationOTPGenerator extends StatefulWidget {
  @override
  _RegistrationOTPGeneratorState createState() => _RegistrationOTPGeneratorState();
}

class _RegistrationOTPGeneratorState extends State<RegistrationOTPGenerator> {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('Registration_OTP');

  String generatedOTP = '';

  Future<void> generateOTP() async {
    // Generate a random 6-digit OTP
    final otp = Random().nextInt(999999).toString().padLeft(6, '0');

    // Store the OTP in the Firestore collection with additional 'Used' field
    await _collectionReference.doc().set({
      'otp': otp,
      'Used': false,
    });

    setState(() {
      generatedOTP = otp;
    });
  }

  @override
  void initState() {
    super.initState();
    generateOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ManagementUse(),
              ),
            );
          },
        ),
        title: Text('OTP Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Generated OTP:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              generatedOTP,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (generatedOTP.isEmpty)
              ElevatedButton(
                onPressed: generateOTP,
                child: Text('Generate OTP'),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegistrationOTPGenerator(),
  ));
}
