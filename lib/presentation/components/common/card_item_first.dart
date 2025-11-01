import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 Colores según tema
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final borderColor = isDark ? Colors.green : Colors.black;
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
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
                  'Monto en Gs',
                  monto,
                  secondaryTextColor,
                  accentColor,
                  theme,
                ),
                _infoRow(
                  'Fecha de lectura',
                  fechaLectura,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Lectura',
                  lectura,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Consumo',
                  consumo,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Fecha de vencimiento',
                  fechaVencimiento,
                  secondaryTextColor,
                  mainTextColor,
                  theme,
                ),
                _infoRow(
                  'Total con comisión',
                  totalConComision,
                  secondaryTextColor,
                  accentColor,
                  theme,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: onSecondaryPressed,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accentColor),
                        foregroundColor: accentColor,
                      ),
                      child: const Text('Ver Última Factura'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onPrimaryPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Pagar'),
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
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: labelColor),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
