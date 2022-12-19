import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:open_file/open_file.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  Future<File> g() async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);

    pdf.addPage(pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4.copyWith(
              marginBottom: 0.0 * PdfPageFormat.cm,
              marginLeft: 0.0 * PdfPageFormat.cm,
              marginRight: 0.0 * PdfPageFormat.cm,
              marginTop: 0.10 * PdfPageFormat.cm),
          orientation: pw.PageOrientation.portrait,
        ),
        build: (pw.Context context) {
          return [
            pw.ListView.builder(
                itemBuilder: (ctx, index) => pw.Container(
                      child: pw.Container(
                          width: 100, height: 120, color: PdfColors.green),
                    ),
                itemCount: 10)
          ];
          // Center
        }));

    return FileHandleApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var a = await widget.g();
            await FileHandleApi.openFile(a);
          },
          child: Text('data'),
        ),
      ),
    );
  }
}

class FileHandleApi {
  // save pdf file function
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
