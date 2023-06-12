//signup_page.dart


//import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code/auth_page.dart';
import 'package:qr_code/login_page.dart';
//import 'package:management_side/utils/utils.dart';
import 'package:flutter/material.dart';
//import 'package:management_side/generate_qr_code.dart';


class SignUpScreen extends StatefulWidget
{
  const SignUpScreen ({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose()
  {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context)
  {

return Scaffold(
    appBar: AppBar(backgroundColor: Colors.blueGrey),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox
            (
              height: 30.0
          ),
          const Text
            (
            "HORUS",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text
            (
            "Sign up",
            style: TextStyle
              (
              color: Colors.black,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox
            (
              height: 44.0
          ),
          TextFormField
            (
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration
              (
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
            ),
            validator: (value){
              if(value!.isEmpty){
                return 'Enter email';
              }
              return null;
            },
          ),
          const SizedBox
            (
            height: 10.0,
          ),
          TextField
            (
            keyboardType: TextInputType.text,
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration
              (
              hintText: "User Password",
              prefixIcon: Icon(Icons.lock, color: Colors.black),
            ),
          ),
          const SizedBox
            (
            height: 12.0,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(onPressed: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
              },
                  child: Text('Log in',
                      style: TextStyle(color: Colors.blue)
                  )
              )
            ],
          ),

          const SizedBox
            (
            height: 40.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton
              (
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(12.0)
              ),

              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailController.text.toString(),
                      password: _passwordController.text.toString())
                      .then((userCredential) {
                    print(userCredential.user?.email);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()), // Replace 'YourDesiredPage' with the page you want to navigate to
                    );
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },


              /* onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailController.text.toString(),
                      password: _passwordController.text.toString())
                      .then((userCredential) => print(userCredential.user?.email));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }

                },*/
            //),
              child: const Text("Sign Up",
                  style: TextStyle
                    (
                    color: Colors.white,
                    fontSize: 18.0,
                  )
              ),
            ),
          ),
        ], //children
      ),
    )
    );
  }
}
