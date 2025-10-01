import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/archivo_adjunto_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class Tab2 extends FormField<ArchivoAdjunto?>  {
 

  Tab2({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
  }) : super(
          builder: (FormFieldState<ArchivoAdjunto?> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MediaPicker(
                  file: state.value,
                  onChanged: (file) => state.didChange(file),
                ),
                if (state.hasError)
                  Text(
                    state.errorText ?? "",
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            );
          },
        );
}

class _MediaPicker extends StatefulWidget {
  final ArchivoAdjunto? file;
  final ValueChanged<ArchivoAdjunto?> onChanged;

  const _MediaPicker({Key? key, this.file, required this.onChanged})
      : super(key: key);

  @override
  State<_MediaPicker> createState() => MediaPickerState();
}



class MediaPickerState extends State<_MediaPicker> with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _videoThumbnail;
@override
  bool get wantKeepAlive => true;

Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
  XFile? pickedFile;

  if (isVideo) {
    pickedFile = await _picker.pickVideo(source: source);
  } else {
    pickedFile = await _picker.pickImage(source: source);
  }

  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final stat = await file.stat(); // para tamaño y fecha

    // Obtenemos metadata del archivo
    final fileInfo = {
      "origen": "W",
      "name": pickedFile.name,
      "type": pickedFile.mimeType ?? 
              (isVideo ? "video/mp4" : "image/*"), 
      "size": stat.size,
      "lastModified": stat.modified.millisecondsSinceEpoch,
    };

    debugPrint("INFO DEL ARCHIVO: $fileInfo");

    if (isVideo) {
      final thumb = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 50,
      );
      setState(() {
        _videoThumbnail = thumb;
      });
    } else {
      setState(() {
        _videoThumbnail = null;
      });
    }

    widget.onChanged(
      ArchivoAdjunto(file: file, info: fileInfo),
    );
  }
}


  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Tomar Foto"),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera, isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text("Grabar Video"),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera, isVideo: true);
              },
            ),
          ],
        ),
      ),
    );
  }

    void limpiar() {
    setState(() {
      _videoThumbnail = null;
      
    });
  }

 @override
Widget build(BuildContext context) {
  final archivo = widget.file; // ahora es ArchivoAdjunto?

  return Column(
    children: [
      const SizedBox(height: 16),
      if (archivo == null)
        const Text("Seleccione Adjunto para Reclamo")
      else if (archivo.file.path.endsWith(".mp4"))
        _videoThumbnail != null
            ? Image.memory(_videoThumbnail!, height: 150)
            : const Text("Cargando vista previa del video...")
      else
        Image.file(archivo.file, height: 150),

      const SizedBox(height: 10),


      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          ElevatedButton.icon(            
            icon: const Icon(Icons.photo_library),
            label: const Text("Galería"),
            onPressed: () => _pickMedia(ImageSource.gallery),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text("Cámara"),
            onPressed: _showCameraOptions,
          ),
        ],
      ),
    ],
  );
}

}


