//auth_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code/login_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/generate_qr_page.dart';
import 'main.dart';

//checks if user is logged in or not
class AuthPage extends StatelessWidget
{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //if user is logged in
          if(snapshot.hasData)
          {
            return GenerateQRCode();
          }
          //if user is NOT logged in
          else
          {
            return LoginScreen();
          }
        },
      ),
    );
  }
}