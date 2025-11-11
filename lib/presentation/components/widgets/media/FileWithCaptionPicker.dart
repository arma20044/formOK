import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class FileWithCaptionPicker extends StatefulWidget {
  final String label;
  final Function(File?) onFileSelected;

  const FileWithCaptionPicker({
    Key? key,
    required this.label,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  State<FileWithCaptionPicker> createState() => _FileWithCaptionPickerState();
}

class _FileWithCaptionPickerState extends State<FileWithCaptionPicker> {
  File? _pickedFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile(ImageSource source, {bool isVideo = false}) async {
    XFile? file;
    if (isVideo) {
      file = await _picker.pickVideo(source: source);
    } else {
      file = await _picker.pickImage(source: source, imageQuality: 80);
    }

    if (file != null) {
      setState(() {
        _pickedFile = File(file!.path);

        if (isVideo) {
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(_pickedFile!)
            ..initialize().then((_) {
              setState(() {});
              _videoController!.setLooping(true);
            });
        }
      });

      widget.onFileSelected(_pickedFile);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickFile(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Galería"),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _pickFile(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Cámara"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_pickedFile != null)
          _videoController != null
              ? AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _pickedFile!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
      ],
    );
  }
}
