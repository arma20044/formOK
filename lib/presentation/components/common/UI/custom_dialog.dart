import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DialogType { success, error, warning, info }

/// Color de fondo según tipo
Color _dialogBgColor(BuildContext context, DialogType type) {
  final cs = Theme.of(context).colorScheme;

  switch (type) {
    case DialogType.success:
      return cs.primaryContainer;
    case DialogType.error:
      return cs.errorContainer;
    case DialogType.warning:
      return Colors.amber.shade200;
    case DialogType.info:
      return cs.secondaryContainer;
  }
}

/// Color del texto/ícono según tipo
Color _dialogOnColor(BuildContext context, DialogType type) {
  final cs = Theme.of(context).colorScheme;

  switch (type) {
    case DialogType.success:
      return cs.onPrimaryContainer;
    case DialogType.error:
      return cs.onErrorContainer;
    case DialogType.warning:
      return Colors.black87;
    case DialogType.info:
      return cs.onSecondaryContainer;
  }
}

/// Icono según tipo
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

/// Texto por defecto según tipo
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

/// Diálogo personalizado, seguro, moderno y reutilizable
Future<void> showCustomDialog({
  required BuildContext context,
  required String message,
  String? title,
  DialogType type = DialogType.success,
  bool showCopyButton = true,
}) async {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  final bgColor = _dialogBgColor(context, type);
  final onColor = _dialogOnColor(context, type);

  // Contexto raíz para mostrar SnackBar correctamente
  final rootContext = Navigator.of(context).context;

  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        actionsPadding: const EdgeInsets.only(right: 8, bottom: 8),

        title: Row(
          children: [
            Icon(_dialogIcon(type), color: onColor, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title ?? _defaultTitle(type),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: onColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: onColor,
          ),
        ),

        actions: [
          if (showCopyButton)
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message));
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(
                    content: const Text("Texto copiado al portapapeles"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: cs.surfaceContainerHigh,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                "Copiar",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.primary,
                ),
              ),
            ),

          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              "Aceptar",
              style: theme.textTheme.labelLarge?.copyWith(
                color: cs.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
