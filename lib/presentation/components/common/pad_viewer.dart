import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  final File stringPdf;
  const PdfViewerScreen({super.key, required this.stringPdf});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF')),
      body: PDFView(
        filePath: widget.stringPdf.path,
        enableSwipe: true,
        swipeHorizontal: true,
        backgroundColor: Colors.grey,
        onRender: (_pages) {
          setState(() {
            //pages = _pages;
            //isReady = true;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          //   _controller.complete(pdfViewController);
        },
      ),
    );
  }
}
