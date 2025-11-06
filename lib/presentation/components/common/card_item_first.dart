import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/UI/custom_loader_botton.dart';
import 'package:form/presentation/components/common/UI/custom_loading.dart';
import 'package:form/utils/utils.dart';

class CardItemFirst extends StatelessWidget {
  final String title;
  final String monto;
  final String fechaLectura;
  final String lectura;
  final String consumo;
  final String fechaVencimiento;
  final String totalConComision;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final double width;
  final double height;
  final bool isLoadingFacturaDeudaTotal;

  const CardItemFirst({
    super.key,
    required this.title,
    required this.monto,
    required this.fechaLectura,
    required this.lectura,
    required this.consumo,
    required this.fechaVencimiento,
    required this.totalConComision,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.width = double.infinity,
    this.height = 250,
    required this.isLoadingFacturaDeudaTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 Colores según tema
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final borderColor = isDark ? Colors.green : Colors.black;
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white : Colors.black54;
    final accentColor = Colors.green; // acento verde para ambos temas

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: width, minHeight: height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _infoRow(
                  'Monto en Gs: ',
                  monto,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                  fontWeight: FontWeight.bold,
                ),
                _infoRow(
                  'Fecha de lectura: ',
                  fechaLectura,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Lectura: ',
                  lectura,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Consumo :',
                  consumo,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Fecha de vencimiento: ',
                  fechaVencimiento,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Total con comisión Gs.: ',
                  totalConComision,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoadingFacturaDeudaTotal
                            ? null
                            : onSecondaryPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentColor,
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoadingFacturaDeudaTotal
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Cargando..."),
                                  SizedBox(width: 8),
                                  CustomLoaderButton(),
                                ],
                              )
                            : const Text('Ver Última factura'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      // 👈 Agregamos esto para que ambos botones se expandan igual
                      child: OutlinedButton(
                        onPressed: onPrimaryPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentColor,
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Pagar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
    ThemeData theme, {
    FontWeight fontWeight = FontWeight.normal, // valor por defecto
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: labelColor,
              fontWeight: fontWeight,
            ),
          ),
          Text(
            formatearNumeroString(value),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
