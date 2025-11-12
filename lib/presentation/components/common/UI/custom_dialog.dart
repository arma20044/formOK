import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DialogType { success, error, warning, info }

/// Devuelve un color base según el tipo de diálogo
Color _dialogColor(BuildContext context, DialogType type) {
  final colorScheme = Theme.of(context).colorScheme;
  switch (type) {
    case DialogType.success:
      return colorScheme.primaryContainer;
    case DialogType.error:
      return colorScheme.errorContainer;
    case DialogType.warning:
      return Colors.amber.shade200;
    case DialogType.info:
      return colorScheme.secondaryContainer;
  }
}

/// Devuelve un ícono representativo según el tipo
IconData _dialogIcon(DialogType type) {
  switch (type) {
    case DialogType.success:
      return Icons.check_circle_outline;
    case DialogType.error:
      return Icons.error_outline;
    case DialogType.warning:
      return Icons.warning_amber_outlined;
    case DialogType.info:
      return Icons.info_outline;
  }
}

/// Diálogo adaptable al tema, reutilizable y con acciones estándar
Future<void> showCustomDialog({
  required BuildContext context,
  required String message,
  String? title,
  DialogType type = DialogType.success,
  bool showCopyButton = true,
}) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final bgColor = _dialogColor(context, type);
  final iconColor = colorScheme.onPrimaryContainer;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        actionsPadding: const EdgeInsets.only(right: 8, bottom: 8),
        title: Row(
          children: [
            Icon(_dialogIcon(type), color: iconColor, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title ?? _defaultTitle(type),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Aceptar',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          if (showCopyButton)
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Texto copiado al portapapeles"),
                    backgroundColor: colorScheme.surfaceVariant,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Copiar',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      );
    },
  );
}

String _defaultTitle(DialogType type) {
  switch (type) {
    case DialogType.success:
      return "Éxito";
    case DialogType.error:
      return "Error";
    case DialogType.warning:
      return "Advertencia";
    case DialogType.info:
      return "Información";
  }
}
