import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class MediaPreview extends StatelessWidget {
  final File? file;
  final Uint8List? videoThumbnail;

  const MediaPreview({
    super.key,
    this.file,
    this.videoThumbnail,
  });

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return const Text("Seleccionar archivo desde la Galería o la Cámara");
    }

    // Widget base que renderiza imagen o video thumbnail
    Widget previewContent;

    if (file!.path.endsWith(".mp4")) {
      previewContent = videoThumbnail != null
          ? Image.memory(
              videoThumbnail!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            )
          : const Center(child: Text("Cargando vista previa del video..."));
    } else {
      previewContent = Image.file(
        file!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }

    // Contenedor con bordes redondeados y sombra opcional
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // más redondeado = valor mayor
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: previewContent,
      ),
    );
  }
}
