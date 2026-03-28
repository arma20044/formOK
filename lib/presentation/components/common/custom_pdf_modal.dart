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

      final total = body.contentLength;
      int recibido = 0;

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Headers: ${response.headers}');
      

      final sink = archivo.openWrite();

      // Esto descarga y escribe automáticamente el stream en el archivo
      await for (final chunk in body.stream) {
        recibido += chunk.length;
        if (total != -1) {
          debugPrint(
            'Descargando: ${(recibido / total * 100).toStringAsFixed(0)}%',
          );
        }
        sink.add(chunk);
      }

      await sink.close();
      debugPrint('Descarga completada: ${archivo.path}');

      debugPrint('Tamaño del archivo: ${await archivo.length()} bytes');

      final bytes = await archivo.readAsBytes();
      debugPrint('Primeros bytes: ${String.fromCharCodes(bytes.take(100))}');

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

   void compartir(BuildContext context) async {
  final box = context.findRenderObject() as RenderBox;

  final params = ShareParams(
    files: [XFile(pdfFile.path)],
    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
  );

  final result = await SharePlus.instance.share(params);

  if (result.status == ShareResultStatus.success) {
    debugPrint('Archivo compartido correctamente');
  }
}

  

  return Dialog(
  insetPadding: EdgeInsets.zero,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: SizedBox.expand( // ✅ fuerza tamaño válido
    child: Stack(
      children: [
        SizedBox.expand(
          child: PDFView(
            filePath: pdfFile.path,
            onError: (error) {
              debugPrint('PDF error: $error');
            },
            onRender: (pages) {
              debugPrint('PDF renderizado: $pages páginas');
            },
          ),
        ),

        /// BOTÓN CERRAR
        Positioned(
          top: 20.0,
          right: 20.0,
          child: IconButton(
            icon: const Icon(Icons.close),
            style: ButtonStyle(
              iconColor: WidgetStateProperty.all(Colors.white),
              backgroundColor: WidgetStateProperty.all(Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        /// BOTÓN COMPARTIR (con contexto correcto)
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: Builder(
            builder: (btnContext) {
              return IconButton(
                icon: const Icon(Icons.share),
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  final box =
                      btnContext.findRenderObject() as RenderBox;

                  final params = ShareParams(
                    files: [XFile(pdfFile.path)],
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size,
                  );

                  SharePlus.instance.share(params);
                },
              );
            },
          ),
        ),
      ],
    ),
  ),
); }
}
