//login_page.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code/OTP_Register.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/generate_qr_page.dart';
import 'package:qr_code/UI_Selection.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
        required String password,
        required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Incorrect Email'),
            );
          },
        );
      }
      if (e.code == "wrong-password") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Incorrect Password'),
            );
          },
        );
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
        body: ListView(
          children: [
            Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50,),
            const Text(
              "HORUS",
              style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Login to HORUS",
              style: TextStyle(
                color: Colors.black,
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter email';
              }
            return null;
            },
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
              hintText: "User Password",
              prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              "Change password",
              style: TextStyle(color: Colors.blue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OTP_Check()));
                  },
                  child: const Text('Sign up',
                  style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
            const SizedBox(
              height: 50.0,
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
                User? user = await loginUsingEmailPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
                print(user);
                if (user!=null)
                {
                  //if logged in, directed to GenerateQRCode()
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GenerateQRCode()));
                }
              },
              child: const Text("Login",
                  style: TextStyle
                    (
                    color: Colors.white,
                    fontSize: 18.0,
                  )
              ),
            ),
          ),
        ],
      ),
    ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UI_Choose(),
                    ),
                  );
                },
                child: Icon(Icons.arrow_back, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.amber, // <-- Button color
                  foregroundColor: Colors.red, // <-- Splash color
                ),
              ),
            ),
    ],
        ),
    );
  }
}
