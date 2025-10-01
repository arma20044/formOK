import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../model/archivo_adjunto_model.dart';

class Tab2 extends FormField<ArchivoAdjunto?> {
  Tab2({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
  }) : super(
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MediaPicker(
                  file: state.value,
                  onChanged: state.didChange,
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      state.errorText ?? "",
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
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

class MediaPickerState extends State<_MediaPicker>
    with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _videoThumbnail;

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final pickedFile = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    if (isVideo) {
      _videoThumbnail = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 50,
      );
    } else {
      _videoThumbnail = null;
    }

    widget.onChanged(ArchivoAdjunto(file: file, info: {}));
    setState(() {});
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Tomar Foto"),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera);
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
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galería"),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void limpiar() {
    widget.onChanged(null);
    _videoThumbnail = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // para AutomaticKeepAliveClientMixin
    final archivo = widget.file;

    Widget preview;
    if (archivo == null) {
      preview = const Text("Seleccione un adjunto para el reclamo");
    } else if (archivo.file.path.endsWith(".mp4")) {
      preview = _videoThumbnail != null
          ? Image.memory(_videoThumbnail!, height: 150)
          : const Text("Cargando vista previa del video...");
    } else {
      preview = Image.file(archivo.file, height: 150);
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        preview,
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.attach_file),
          label: const Text("Seleccionar archivo"),
          onPressed: _showOptions,
        ),
      ],
    );
  }
}
