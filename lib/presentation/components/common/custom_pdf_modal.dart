import 'package:flutter/material.dart';

class CustomPdfModal extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;

  const CustomPdfModal({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.onCancel,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("PDFFFFF"),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop();
                  },
                  child: Text(cancelText),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onConfirm?.call();
                    Navigator.of(context).pop();
                  },
                  child: Text(confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
