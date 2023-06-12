import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

// class CallPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: callFunc(),
//     );
//   }
// }

class callFunc extends StatefulWidget{
  @override
  _callFuncState createState() => _callFuncState();
}

class _callFuncState extends State<callFunc> {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Contact Us"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        floatingActionButton: SpeedDial(
          marginBottom: 10, //margin bottom
          icon: Icons.help_outline, //icon on Floating action button
          activeIcon: Icons.close, //icon when menu is expanded on button
          backgroundColor: Colors.yellow, //background color of button
          foregroundColor: Colors.black, //font color, icon color in button
          activeBackgroundColor: Colors.deepPurpleAccent, //background color when menu is expanded
          activeForegroundColor: Colors.white,
          buttonSize: 56.0, //button size
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'), // action when menu opens
          onClose: () => print('DIAL CLOSED'), //action when menu closes

          elevation: 8.0, //shadow elevation of button
          shape: CircleBorder(), //shape of button

          children: [
            SpeedDialChild( //speed dial child
              child: Icon(Icons.feedback),
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              label: 'Customer Feedback',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                final Uri url = Uri(
                  scheme: 'mailto',
                  path: 'feedback@horus.comm',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Customer Feedback',
                  }),
                );
                if (!await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('cannot launch this url');
                }
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.textsms),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: 'Horus Helpline',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                final Uri url = Uri(
                  scheme: 'sms',
                  path: '0164798578',
                );
                if (!await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('cannot launch this url');
                }
              },
            ),
            SpeedDialChild(
                child: Icon(Icons.call),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                label: 'Taman Ria Management',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  FlutterPhoneDirectCaller.callNumber('0165841892');
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.call),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                label: 'Guard House',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  FlutterPhoneDirectCaller.callNumber('0168359038');
                }
            ),

            //add more menu item children here
          ],
        ),

        body: Container()
    );
  }
}