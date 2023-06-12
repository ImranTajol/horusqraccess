import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class QRImage extends StatelessWidget {
  const QRImage(this.controllerFullName,this.housefloor,this.housenumber, this.randomNumber,{super.key});

  final TextEditingController controllerFullName;
  final housefloor;
  final housenumber;
  final randomNumber;




  @override
  Widget build(BuildContext context) {
    //final qrData = controllerFullName.text + housefloor + housenumber + randomNumber.toString();
    //if 'name' --> need \'name\'
    final jsonformatData = '{"id":${randomNumber},'
        '"name":\"${controllerFullName.text}\",'
        '"house_floor":$housefloor,'
        '"house_number":$housenumber}';

    //function to share QR image
    Future _shareQRImage() async {

      final image = await QrPainter(
        data: jsonformatData,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
        embeddedImageStyle: QrEmbeddedImageStyle(size: Size(50,50) ,color: Colors.black),
      ).toImageData(300.0); // Generate QR code image data


      final filename = 'qr_code.png';
      final tempDir = await getTemporaryDirectory(); // Get temporary directory to store the generated image
      final file = await File('${tempDir.path}/$filename').create(); // Create a file to store the generated image
      var bytes = image!.buffer.asUint8List(); // Get the image

      await file.writeAsBytes(bytes); // Write the image bytes to the file
      Share.shareXFiles([XFile(file.path)], subject: 'QR Code'); // Share the generated image using the share_plus package
      //print('QR code shared to: $path');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horus QR Access'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child:
              Center(
                child: QrImage(
                  data: jsonformatData,
                  size: 280,
                  // You can include embeddedImageStyle Property if you
                  //wanna embed an image from your Asset folder
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(
                      100,
                      100,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child:
              Column(
                children: [
                  const Text('QR Data:',style: TextStyle(fontSize: 25),),
                  Text(jsonformatData,style: TextStyle(fontSize: 25))
                ],
              ),
            ),
            Container(
              child: Center(
                child: Column(children: [
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                          onPressed: _shareQRImage,
                          icon: const Icon(Icons.share),
                          label: const Text('Share QR Code'))
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
