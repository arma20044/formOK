import 'package:flutter/material.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_title.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoScreen extends StatefulWidget {
  final String videoUrl;
  const YoutubeVideoScreen({super.key, required this.videoUrl});

  @override
  State<YoutubeVideoScreen> createState() => _YoutubeVideoScreenState();
}

class _YoutubeVideoScreenState extends State<YoutubeVideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      throw Exception('URL de YouTube inválida');
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Video Demostrativo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTitle(text: "Video Demostrativo"),
              // Reproductor con proporción 16:9
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {
                      print('Player is ready.');
                    },
                  ),
                ),
              
              // Ejemplo de contenido adicional
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Descripción del video o contenido adicional...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),*/
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: context.pop, child: CustomText("Cerrar")))
            ],
          ),
        ),
      ),
    );
  }
}
