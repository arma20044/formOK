import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/UI/custom_loader_botton.dart';
import 'package:form/utils/utils.dart';

class CardItemSecond extends StatelessWidget {
  final String monto;
  final String estadoPago; // texto del estado, ej. "Pagado", "Pendiente"
  final Color estadoColor; // color del cuadro de estado
  final String fechaEmision;
  final String fechaVencimiento;
  final VoidCallback onVerFacturaPressed;
  final bool isLoadingFactura;

  const CardItemSecond({
    super.key,
    required this.monto,
    required this.estadoPago,
    required this.estadoColor,
    required this.fechaEmision,
    required this.fechaVencimiento,
    required this.onVerFacturaPressed,
    required this.isLoadingFactura,
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
    final accentColor = Colors.green;

    return Card(
      color: backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💰 Monto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monto en Gs.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                formatearNumeroString(monto),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 📊 Estado del pago
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estado del pago',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 6),
                   /* Text(
                      estadoPago,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: mainTextColor,
                        fontWeight: FontWeight.bold,
                        backgroundColor: estadoPago == 'Pagado'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),*/
                    Container(
                      padding: const EdgeInsets.all(8.0), // Relleno interior
                      decoration: BoxDecoration(
                        color:  estadoPago == 'Pagado'
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ), // Bordes redondeados
                      ),
                      child:  Text(
                        estadoPago,
                          style: theme.textTheme.bodyMedium?.copyWith(
                        color: mainTextColor,
                        fontWeight: FontWeight.bold,
                        //backgroundColor: estadoPago == 'Pagado'
                          //  ? Colors.green
                            //: Colors.orange,
                      ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🗓️ Fecha de emisión
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emisión',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                 formatearFecha( fecha: fechaEmision,formatoSalida: '/'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: mainTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ⏰ Fecha de vencimiento
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vencimiento',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                   formatearFecha( fecha: fechaVencimiento,formatoSalida: '/'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: mainTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

           
            // 🔘 Botón Ver factura
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoadingFactura ? null : onVerFacturaPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoadingFactura
                    ? Row(
                      children: [
                        Text("Cargando..."),
                        const SizedBox(width: 8),
                         CustomLoaderButton(),
                      ],
                    )
                    : Text('Ver factura'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
