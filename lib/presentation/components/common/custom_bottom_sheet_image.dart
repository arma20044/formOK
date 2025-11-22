import 'package:flutter/material.dart';

class CustomBottomSheetImage extends StatelessWidget {
  const CustomBottomSheetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bottom Sheet Imagen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const ImageBottomSheet(
                assetPath: 'assets/images/yofacturo.png',
              ),
            );
          },
          child: const Text("Mostrar Imagen"),
        ),
      ),
    );
  }
}

class ImageBottomSheet extends StatelessWidget {
  final String assetPath;

  const ImageBottomSheet({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight, // Ocupa toda la pantalla
      width: screenWidth,
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta al contenido
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                assetPath,
                width: screenWidth , // 80% del ancho de pantalla
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20), // Espacio entre imagen y botón
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
              child: const Text(
                "Comprendo las instrucciones y deseo realizar la lectura",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

