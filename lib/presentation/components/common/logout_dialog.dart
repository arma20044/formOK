import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: theme.colorScheme.surface,

      // ✅ sombra
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.4),

      // ✅ borde + esquinas redondeadas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1.2,
        ),
      ),

      title: Row(
        children: [
          Icon(Icons.logout, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Cerrar sesión',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),

      content: Text(
        '¿Desea cerrar su sesión?',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),

      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: isDark
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.primary,
          ),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Sí'),
        ),
      ],
    );
  }
}