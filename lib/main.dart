import 'package:flutter/material.dart';
import 'package:qr_code/generate_qr_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qr_code/login_page.dart';
import 'package:qr_code/UI_Selection.dart';
import 'package:qr_code/pending_page.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

    periodicTimerFunc();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
      ThemeData(primaryColor: Colors.black54, primarySwatch: Colors.amber),
      //home: const GenerateQRCode(),
      home: UI_Choose(),

    );
  }
}