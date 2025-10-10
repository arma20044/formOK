import 'package:flutter/material.dart';

class TituloSubtitulo extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final TextAlign align;
  final EdgeInsetsGeometry padding;
  final IconData? icono;

  const TituloSubtitulo({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.align = TextAlign.left,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icono != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(
                icono,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: align == TextAlign.center
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  textAlign: align,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitulo!,
                    textAlign: align,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
