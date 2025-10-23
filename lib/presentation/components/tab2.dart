import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../model/archivo_adjunto_model.dart';
import 'widgets/media/MediaPickerButton.dart';
import 'widgets/media/MediaPreview.dart';
import 'package:mime/mime.dart';


class Tab2 extends FormField<ArchivoAdjunto?> {
  Tab2({super.key, super.onSaved, super.initialValue, super.validator})
    : super(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MediaPicker(
                file: state.value,
                onChanged: state.didChange, // 🔹 conecta con FormField
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    state.errorText ?? '',
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
  State<_MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<_MediaPicker>
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

    // 🔹 Actualiza el FormField
    //"/data/user/0/com.example.form/cache/393e938d-d727-4adf-9490-13a68c6749731550468659211644227.jpg"
    // Obtener info async
    final size = await pickedFile.length(); // int
    final lastMod = await pickedFile.lastModified(); // DateTime
    final lastModifiedStr = lastMod.toIso8601String(); // String o null

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';


    final archivo = ArchivoAdjunto(
      file: file,
      info: {
        'origen': 'A',
        'name': pickedFile.name,
        'type': mimeType,
        'size': size,
        'lastModified': lastModifiedStr,
      },
    );
    widget.onChanged(archivo); // ✅ esto actualiza FormField.value
    setState(() {});
  }

  void _clearMedia() {
    widget.onChanged(null); // ✅ limpia FormField.value
    _videoThumbnail = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(height: 16),
        MediaPreview(file: widget.file?.file, videoThumbnail: _videoThumbnail),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaPickerButton(
              onPickImage: () => _pickMedia(ImageSource.camera),
              onPickVideo: () => _pickMedia(ImageSource.camera, isVideo: true),
              onPickGallery: () => _pickMedia(ImageSource.gallery),
            ),
            if (widget.file != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _clearMedia,
              ),
          ],
        ),
      ],
    );
  }
}
