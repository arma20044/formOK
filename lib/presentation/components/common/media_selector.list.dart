import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/widgets/media/MediaPickerButton.dart';
import 'package:form/presentation/components/widgets/media/MediaPreview.dart';
import 'package:form/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:mime/mime.dart';
import '../../../model/archivo_adjunto_model.dart';

class MediaSelectorList extends StatefulWidget {
  final List<ArchivoAdjunto> files;
  final ValueChanged<List<ArchivoAdjunto>> onChanged;
  final MediaType? type;
  final String? ayuda;
  final int maxAdjuntos; // 👈 nuevo parámetro para limitar cantidad

  const MediaSelectorList({
    super.key,
    this.type,
    required this.files,
    required this.onChanged,
    this.ayuda,
    this.maxAdjuntos = 3, // valor por defecto
  });

  @override
  State<MediaSelectorList> createState() => _MediaSelectorListState();
}

class _MediaSelectorListState extends State<MediaSelectorList>
    with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    if (widget.files.length >= widget.maxAdjuntos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Solo se permiten ${widget.maxAdjuntos} archivos adjuntos.",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final pickedFile = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    Uint8List? videoThumbnail;

    if (isVideo) {
      videoThumbnail = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 50,
      );
    }

    final size = await pickedFile.length();
    final lastMod = await pickedFile.lastModified();
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    final archivo = ArchivoAdjunto(
      file: file,
      info: {
        'origen': 'A',
        'name': pickedFile.name,
        'type': mimeType,
        'size': size,
        'lastModified': lastMod.toIso8601String(),
        'thumbnail': videoThumbnail,
      },
    );

    final nuevaLista = [...widget.files, archivo];
    widget.onChanged(nuevaLista);
    setState(() {});
  }

  void _removeFile(int index) {
    final nuevaLista = [...widget.files]..removeAt(index);
    widget.onChanged(nuevaLista);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        if (widget.files.isEmpty && widget.ayuda != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomText(widget.ayuda!, overflow: TextOverflow.clip),
          ),

        // 👇 listado de previews
        if (widget.files.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (int i = 0; i < widget.files.length; i++)
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    MediaPreview(
                      file: widget.files[i].file,
                      videoThumbnail:
                          widget.files[i].info['thumbnail'] as Uint8List?,
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: Center(
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -3,
                      top: -12,
                      child: IconButton(
                        // iconSize: 150,
                        icon: const Icon(Icons.cancel, color: Colors.pink),
                        onPressed: () {
                          _removeFile(i);
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),

        const SizedBox(height: 10),

        // 👇 botones de selección
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaPickerButton(
              onPickImage: () => _pickMedia(ImageSource.camera),
              onPickVideo: () => _pickMedia(ImageSource.camera, isVideo: true),
              onPickGallery: () => _pickMedia(ImageSource.gallery),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Text(
          "(${widget.files.length}/${widget.maxAdjuntos}) adjuntos",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
