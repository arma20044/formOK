import 'package:flutter/material.dart';

class MediaPickerButton extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onPickGallery;

  const MediaPickerButton({
    super.key,
    required this.onPickImage,
    required this.onPickVideo,
    required this.onPickGallery,
  });

  void _showOptions(BuildContext context) {
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
                onPickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text("Grabar Video"),
              onTap: () {
                Navigator.pop(context);
                onPickVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galería"),
              onTap: () {
                Navigator.pop(context);
                onPickGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.attach_file),
      label: const Text("Seleccionar archivo"),
      onPressed: () => _showOptions(context),
    );
  }
}
