import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

import '../../provider/FormProvider.dart';

class Tab2Widget extends StatefulWidget {
  const Tab2Widget({super.key});

  @override
  _Tab2WidgetState createState() => _Tab2WidgetState();
}

class _Tab2WidgetState extends State<Tab2Widget> {
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      _videoController?.dispose();
      _videoController = null;
      context.read<FormProvider>().setArchivo(File(picked.path));
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final picked = await _picker.pickVideo(source: source);
    if (picked != null) {
      final file = File(picked.path);
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file);
      await _videoController!.initialize();
      setState(() {});
      context.read<FormProvider>().setArchivo(file);
    }
  }

  void _removeFile() {
    _videoController?.dispose();
    _videoController = null;
    context.read<FormProvider>().setArchivo(null);
  }

  bool _esImagen(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".png") ||
        ext.endsWith(".gif");
  }

  void _showSourcePicker({required bool esVideo}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(esVideo ? Icons.videocam : Icons.camera_alt),
              title: Text(esVideo ? "Grabar video" : "Tomar foto"),
              onTap: () {
                Navigator.pop(context);
                esVideo ? _pickVideo(ImageSource.camera) : _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(esVideo ? Icons.video_library : Icons.photo_library),
              title: Text(esVideo ? "Seleccionar video" : "Seleccionar foto"),
              onTap: () {
                Navigator.pop(context);
                esVideo ? _pickVideo(ImageSource.gallery) : _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final archivo = context.watch<FormProvider>().archivo;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // FormField invisible para validar archivo
          FormField<File>(
            initialValue: archivo,
            validator: (file) {
              if (file == null) return "Debe adjuntar una foto o video";
              return null;
            },
            builder: (state) => Column(
              children: [
                archivo != null
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _esImagen(archivo.path)
                                  ? Image.file(archivo,
                                      width: double.infinity,
                                      height: 250,
                                      fit: BoxFit.cover)
                                  : _videoController != null &&
                                          _videoController!.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio:
                                              _videoController!.value.aspectRatio,
                                          child: VideoPlayer(_videoController!),
                                        )
                                      : Container(
                                          width: double.infinity,
                                          height: 250,
                                          color: Colors.black,
                                          child: const Center(
                                            child: Icon(Icons.videocam,
                                                size: 60, color: Colors.white),
                                          ),
                                        ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(0.8),
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: _removeFile,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.upload_file, size: 60, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("No hay archivo seleccionado",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(state.errorText!,
                        style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Botones tipo tarjeta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionCard(
                  icon: Icons.camera_alt,
                  label: "Foto",
                  onTap: () => _showSourcePicker(esVideo: false)),
              _buildActionCard(
                  icon: Icons.videocam,
                  label: "Video",
                  onTap: () => _showSourcePicker(esVideo: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 120,
          height: 80,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
