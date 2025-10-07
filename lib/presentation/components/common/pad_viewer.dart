import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerScreen extends StatefulWidget {
  final File stringPdf;
  const PdfViewerScreen({super.key, required this.stringPdf});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final params = ShareParams(
    //  uri: widget.stringPdf.uri,
     // text: 'Great picture',
      files: [XFile(widget.stringPdf.path)],
    );

    void compartir() async {
      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing my website!');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('PDF')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          compartir();
        },
        child: Icon(Icons.share),
      ),
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
