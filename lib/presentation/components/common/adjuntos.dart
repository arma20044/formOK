import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/widgets/media/MediaPickerButton.dart';
import 'package:form/presentation/components/widgets/media/MediaPreview.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Componente reutilizable para seleccionar imagen o video
class Adjuntos extends FormField<ArchivoAdjunto?> {
  Adjuntos({
    Key? key,
    ArchivoAdjunto? initialValue,
    FormFieldSetter<ArchivoAdjunto?>? onSaved,
    FormFieldValidator<ArchivoAdjunto?>? validator,
    ValueChanged<ArchivoAdjunto?>? onChanged,
    String? label,
  }) : super(
         key: key,
         onSaved: onSaved,
         validator: validator,
         initialValue: initialValue,
         builder: (state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               if (label != null)
                 Padding(
                   padding: const EdgeInsets.only(bottom: 8.0),
                   child: Text(
                     label,
                     style: const TextStyle(
                       fontWeight: FontWeight.w600,
                       fontSize: 16,
                     ),
                   ),
                 ),
               _MediaPicker(
                 file: state.value,
                 onChanged: (value) {
                   state.didChange(value);
                   onChanged?.call(value);
                 },
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

/// Selector principal (privado)
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

    widget.onChanged(ArchivoAdjunto(file: file, info: {}));
    setState(() {});
  }

  void _clear() {
    widget.onChanged(null);
    _videoThumbnail = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          MediaPreview(
            file: widget.file?.file,
            videoThumbnail: _videoThumbnail,
          ),
          const SizedBox(height: 10),
          MediaPickerButton(
            onPickImage: () => _pickMedia(ImageSource.camera),
            onPickVideo: () => _pickMedia(ImageSource.camera, isVideo: true),
            onPickGallery: () => _pickMedia(ImageSource.gallery),
          ),
          if (widget.file != null)
            TextButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Eliminar archivo',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
