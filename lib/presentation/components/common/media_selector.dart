import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/widgets/media/MediaPickerButton.dart';
import 'package:form/presentation/components/widgets/media/MediaPreview.dart';
import 'package:form/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:mime/mime.dart';
import '../../../model/archivo_adjunto_model.dart';

class MediaSelector extends StatefulWidget {
  final ArchivoAdjunto? file;
  final ValueChanged<ArchivoAdjunto?> onChanged;
  final MediaType? type;
  final String? ayuda;

  const MediaSelector({super.key, this.type, this.file, required this.onChanged, this.ayuda});

  @override
  State<MediaSelector> createState() => _MediaSelectorState();
}

class _MediaSelectorState extends State<MediaSelector>
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

    final size = await pickedFile.length();
    final lastMod = await pickedFile.lastModified();
    final lastModifiedStr = lastMod.toIso8601String();
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

    widget.onChanged(archivo);
    setState(() {});
  }

  void _clearMedia() {
    widget.onChanged(null);
    _videoThumbnail = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(height: 16),
        if (widget.file != null)
          MediaPreview(
            file: widget.file?.file,
            videoThumbnail: _videoThumbnail,
          ),

          if(widget.file == null && widget.ayuda != null)
          CustomText(widget.ayuda!,overflow: TextOverflow.clip,),

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
