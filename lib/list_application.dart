//list_application.dart


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code/management_menu.dart';


class DisplayApplication extends StatefulWidget {
  @override
  State<DisplayApplication> createState() => _DisplayApplicationState();
}

class _DisplayApplicationState extends State<DisplayApplication> {
  final CollectionReference _collectionReference =
  //FirebaseFirestore.instance.collection('QR_Application');
  FirebaseFirestore.instance.collection('qr_generated');


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
        title: Text("View QR Application"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _collectionReference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final documentData = document.data() as Map<String, dynamic>;
              final status = documentData['status'];
              Color? backgroundColor;

              if (status == 'pending') {
                backgroundColor = Colors.yellow;
              } else if (status == 'APPROVED') {
                backgroundColor = Colors.green;
              } else if (status == 'DENIED') {
                backgroundColor = Colors.red;
              }

              return Card(
                color: backgroundColor,
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Visitor QR Applications'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Number: ${documentData['id']}'),
                              Text('Status: $status'),
                              if (status == 'pending')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Perform the approve action
                                        approveDocument(document, 'APPROVED');
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Approve'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Perform the deny action
                                        approveDocument(document, 'DENIED');
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Deny'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  title: Text('Document ${document.id}'),
                ),

              );
            },
          );
        },
      ),
    );
  }

  void approveDocument(DocumentSnapshot document, String newStatus) {
    document.reference.update({'status': newStatus});
  }
}
