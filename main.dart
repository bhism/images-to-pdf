import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "images to pdf",
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
      ),
      home: Firstpage(),
    );
  }
}

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> image = [];
  var pageformat = "A4";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          image.length == 0
              ? Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/images/r5.png',
                            ),
                            height: 200,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Select Image From Camera or Gallary',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 30,
                            ),
                          ),
                          Image(
                            image: AssetImage(
                              'assets/images/r6.png',
                            ),
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : PdfPreview(
                  maxPageWidth: 1000,
                  // useActions: false,
                  // canChangePageFormat: true,
                  canChangeOrientation: true,
                  // pageFormats:pageformat,
                  canDebug: false,

                  build: (format) => generateDocument(
                    format,
                    image.length,
                    image,
                  ),
                ),
          Align(
            alignment: Alignment(-0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.image,
              ),
              backgroundColor: Colors.indigo[900],
              onPressed: getImageFromGallery,
            ),
          ),
          Align(
            alignment: Alignment(0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.camera,
              ),
              backgroundColor: Colors.indigo[900],
              onPressed: getImageFromcamera,
            ),
          ),
        ],
      ),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  getImageFromcamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, imagelenght, image) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    for (var im in image) {
      final showimage = pw.MemoryImage(im.readAsBytesSync());

      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0,
            ),
            orientation: pw.PageOrientation.portrait,
            // buildBackground: (context) =>
            //     pw.Image(showimage, fit: pw.BoxFit.contain),
            theme: pw.ThemeData.withFont(
              base: font1,
              bold: font2,
            ),
          ),
          build: (context) {
            return pw.Center(
              child: pw.Image(showimage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    return await doc.save();
  }
}
