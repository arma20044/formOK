import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/presentation/components/common/custom_message_dialog.dart';


/// Función pública que puede llamarse desde cualquier parte del proyecto.
/// Ejemplo: `DialogHelper.showMessage(context, MessageType.success, 'Título', 'Mensaje');`
class DialogHelper {
  static Future<void> showMessage(
    BuildContext context,
    MessageType type,
    String title,
    String message, {
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomMessageDialog(
        type: type,
        title: title,
        message: message,
        onClose: onClose,
      ),
    );
  }

  /// Versión que se cierra automáticamente después de unos segundos
  static Future<void> showAutoCloseMessage(
    BuildContext context,
    MessageType type,
    String title,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    showDialog(
      context: context,
      builder: (_) => CustomMessageDialog(
        type: type,
        title: title,
        message: message,
      ),
    );
    await Future.delayed(duration);
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }
}
