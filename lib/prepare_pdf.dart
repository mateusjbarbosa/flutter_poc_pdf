import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

void preparePdf() async {
  // Create a pdf file
  final pdf = pw.Document();

  // Prepare Image
  final ByteData img;
  final pw.Image image;

  if (!kIsWeb) {
    img = await rootBundle.load('assets/bola.jpg');
    final imageBytes = img.buffer.asUint8List();
    image = pw.Image(pw.MemoryImage(imageBytes));
  } else {
    img = await rootBundle.load('assets/bola.jpg');
    final imageBytes = img.buffer.asUint8List();
    image = pw.Image(pw.MemoryImage(imageBytes));
  }

  // Mount page
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              alignment: pw.Alignment.topCenter,
              height: 50,
              child: pw.Text(
                "PoC PDF",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Container(
              alignment: pw.Alignment.topCenter,
              height: 150,
              child: pw.Column(
                children: [
                  pw.Text("Texto regular"),
                  pw.Text(
                    "Texto negrito",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    "Texto itálico",
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                  ),
                  pw.Text(
                    "Texto em vermelho",
                    style: const pw.TextStyle(color: PdfColor(1, 0, 0)),
                  ),
                ],
              ),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              height: 200,
              child: image,
            ),
          ],
        ); // Center
      },
    ),
  );

  if (!kIsWeb) {
    final outputDirectory = await getExternalStorageDirectory();
    final file = File("${outputDirectory?.path}/poc_pdf.pdf");
    await file.writeAsBytes(await pdf.save());

    final validation = await File(file.path).exists();
    if (validation) {
      await OpenFile.open(file.path);
    } else {
      print("Error during file opening");
    }
  } else {
    final savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);

    html.AnchorElement()
      ..href =
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
      ..setAttribute("download", "poc_pdf.pdf")
      ..click();
  }
}
