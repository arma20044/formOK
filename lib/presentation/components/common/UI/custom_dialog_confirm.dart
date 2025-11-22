import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';

Color _dialogBgColor(BuildContext context, DialogType type) {
  final cs = Theme.of(context).colorScheme;

  switch (type) {
    case DialogType.success:
      return cs.primaryContainer;
    case DialogType.error:
      return cs.errorContainer;
    case DialogType.warning:
      return Colors.amber.shade200; // Warning no tiene container estándar
    case DialogType.info:
      return cs.secondaryContainer;
  }
}

Color _dialogOnColor(BuildContext context, DialogType type) {
  final cs = Theme.of(context).colorScheme;

  switch (type) {
    case DialogType.success:
      return cs.onPrimaryContainer;
    case DialogType.error:
      return cs.onErrorContainer;
    case DialogType.warning:
      return Colors.black87; // mejor contraste con el amberContainer
    case DialogType.info:
      return cs.onSecondaryContainer;
  }
}

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

Future<void> showConfirmDialog({
  required BuildContext context,
  required String message,
  required Function() onConfirm, // callback al Aceptar
  String? title,
  DialogType type = DialogType.warning,
  bool? showIcon=false
}) async {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  final bgColor = _dialogBgColor(context, type);
  final onColor = _dialogOnColor(context, type);

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
            showIcon == true ? Icon(_dialogIcon(type), color: onColor, size: 28) : Text(""),
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
          style: theme.textTheme.bodyMedium?.copyWith(color: onColor),
        ),

        actions: [
          // ACEPTAR (EJECUTA CALLBACK)
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // cerrar diálogo
              onConfirm(); // ejecutar acción
            },
            child: Text(
              "Aceptar",
              style: theme.textTheme.labelLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // CANCELAR
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              "Cancelar",
              style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
            ),
          ),
        ],
      );
    },
  );
}
