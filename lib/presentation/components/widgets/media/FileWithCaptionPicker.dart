import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

enum AllowedFileType { photo, video, both }

class FileWithCaptionPicker extends StatefulWidget {
  final String label;
  final String emptyLabel;
  final Function(File?) onFileSelected;
  final AllowedFileType allowedTypes;

  const FileWithCaptionPicker({
    super.key,
    required this.label,
    required this.onFileSelected,
    this.allowedTypes = AllowedFileType.both, required this.emptyLabel,
  });

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
              _videoController!.play();
            });
        } else {
          _videoController?.dispose();
          _videoController = null;
        }
      });

      widget.onFileSelected(_pickedFile);
    }
  }

  void _removeFile() {
    setState(() {
      _pickedFile = null;
      _videoController?.dispose();
      _videoController = null;
    });
    widget.onFileSelected(null);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final showPhotoButtons = widget.allowedTypes == AllowedFileType.photo ||
        widget.allowedTypes == AllowedFileType.both;
    final showVideoButtons = widget.allowedTypes == AllowedFileType.video ||
        widget.allowedTypes == AllowedFileType.both;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceVariant : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),

          if (_pickedFile == null) ...[
            // === Botones solo si no hay archivo cargado ===
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showPhotoButtons) ...[
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(ImageSource.gallery, isVideo: false),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galería"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(ImageSource.camera, isVideo: false),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Cámara"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
                if (showVideoButtons) ...[
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(ImageSource.gallery, isVideo: true),
                    icon: const Icon(Icons.video_library),
                    label: const Text("Video"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ],
            ),
          ],

          const SizedBox(height: 10),

          // === Vista previa si hay archivo cargado ===
          if (_pickedFile != null)
            Column(
              children: [
                _videoController != null
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _pickedFile!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _removeFile,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Eliminar archivo"),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              ],
            ),

            if(_pickedFile == null)
            Text(widget.emptyLabel)
        ],
      ),
    );
  }
}
