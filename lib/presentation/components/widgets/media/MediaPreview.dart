import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class MediaPreview extends StatelessWidget {
  final File? file;
  final Uint8List? videoThumbnail;

  const MediaPreview({super.key, this.file, this.videoThumbnail});

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return const Text("Seleccione un adjunto para el reclamo");
    }

    if (file!.path.endsWith(".mp4")) {
      return videoThumbnail != null
          ? Image.memory(videoThumbnail!, height: 150)
          : const Text("Cargando vista previa del video...");
    }

    return Image.file(file!, height: 150);
  }
}
