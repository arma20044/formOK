import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CustomPdfModal extends StatelessWidget {
  final File pdfFile;
  final String title;
  final Widget content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;

  const CustomPdfModal({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.onCancel,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
    required this.pdfFile,
  });

  Future<File> descargarPdfConPipe(String url, String nombreArchivo) async {
    Dio dio = Dio();

    Directory dir = await getTemporaryDirectory();
    String ruta = '${dir.path}/$nombreArchivo';
    File archivo = File(ruta);

    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'application/pdf',
            'x-so': Platform.isAndroid ? 'Android' : 'IOS',
          },
        ),
      );

      final body = response.data as ResponseBody;

      final total = body.contentLength ?? -1;
      int recibido = 0;

      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');

      final sink = archivo.openWrite();

      // Esto descarga y escribe automáticamente el stream en el archivo
      await for (final chunk in body.stream) {
        recibido += chunk.length;
        if (total != -1) {
          print('Descargando: ${(recibido / total * 100).toStringAsFixed(0)}%');
        }
        sink.add(chunk);
      }

      await sink.close();
      print('Descarga completada: ${archivo.path}');

      print('Tamaño del archivo: ${await archivo.length()} bytes');

      final bytes = await archivo.readAsBytes();
      print('Primeros bytes: ${String.fromCharCodes(bytes.take(100))}');

      return archivo;
    } catch (e) {
      throw Exception('Error al descargar PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = ShareParams(
      //  uri: widget.stringPdf.uri,
      // text: 'Great picture',
      files: [XFile(pdfFile.path)],
    );

    void compartir() async {
      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing my website!');
      }
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Scaffold(
        // appBar: AppBar(title: const Text('PDF Viewer with Button')),
        body: Stack(
          children: [
            PDFView(
              filePath: pdfFile.path,
              onViewCreated: (PDFViewController pdfViewController) {
                //_pdfViewController = pdfViewController;
              },
              // Other PDFView options as needed
            ),
            Positioned(
              top: 20.0,
              right: 20.0,
              child: IconButton(
                icon: Icon(Icons.close),
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: IconButton(
                icon: Icon(Icons.share),
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  compartir();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
