import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class ShowDocument extends StatefulWidget {
  final String url;
  const ShowDocument({super.key, required this.url});
  @override
  State createState() => _ShowDocumentState();
}

class _ShowDocumentState extends State<ShowDocument> {

  String? pdfFlePath; 

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.url.substring(62)}');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(widget.url));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadPdf());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3054),
        centerTitle: true,
        title: const Text(
          'States Vaccination Report',
          style: TextStyle(fontSize: 14)
        )
      ),
      body: SizedBox(),
      // body: Center(child: pdfFlePath == null ? const CircularProgressIndicator() : PdfView(path: pdfFlePath!))
    );
  }
}