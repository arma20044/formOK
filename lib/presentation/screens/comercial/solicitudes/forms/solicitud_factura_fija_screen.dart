import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/comercial/solicitudes/factura_fija_repository_impl.dart';
import 'package:form/utils/utils.dart';

import '../../../../../infrastructure/infrastructure.dart';

class SolicitudFacturaFijaScreen extends StatefulWidget {
  const SolicitudFacturaFijaScreen({super.key});

  @override
  State<SolicitudFacturaFijaScreen> createState() =>
      _SolicitudFacturaFijaScreenState();
}

class _SolicitudFacturaFijaScreenState
    extends State<SolicitudFacturaFijaScreen> {
  int selectedIndex = 0;

  final nisController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoadingSolicitud = false;

  ResultadoFacturaFija? resultadoFacturaFija;

  final List<Color> buttonColors = [Colors.green, Colors.blue, Colors.orange];

  @override
  void dispose() {
    nisController.dispose();
    super.dispose();
  }

  Future<FacturaFijaResponse> _fetchFacturaFija(String nis) async {
    final repo = FacturaFijaRepositoryImpl(
      FacturaFijaDatasourceImp(MiAndeApi()),
    );
    return await repo.getFacturaFija(nis);
  }

  void enviarFormulario() async {
    if (_isLoadingSolicitud) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoadingSolicitud = true);

    try {
      final result = await _fetchFacturaFija(nisController.text);

      if (result.error!) {
        DialogHelper.showMessage(
          context,
          MessageType.error,
          'Error',
          result.errorValList?.first ?? 'Error desconocido',
        );
        return;
      }

      setState(() {
        resultadoFacturaFija = result.resultado;
      });

      /*DialogHelper.showMessage(
        context,
        MessageType.success,
        'Éxito',
        result.resultado!.consumoPromedio.toString(),
      );*/
      CustomSnackbar.show(context, message: "Simulacion Correcta.",type: MessageType.success);

    } catch (e) {
      DialogHelper.showMessage(
        context,
        MessageType.error,
        'Error',
        'Ocurrió un error inesperado',
      );
    } finally {
      setState(() => _isLoadingSolicitud = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Factura Fija")),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: _buildTabButton(0, "Simular")),
                const SizedBox(width: 6),
                Expanded(child: _buildTabButton(1, "Ventajas")),
                const SizedBox(width: 6),
                Expanded(child: _buildTabButton(2, "Condiciones")),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final bool isActive = selectedIndex == index;
    final Color baseColor = buttonColors[index];

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? baseColor : baseColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(6),
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.black : Colors.grey.shade700,
              width: isActive ? 3 : 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _simularContent();
      case 1:
        return _ventajasContent();
      case 2:
        return _condicionesContent();
      default:
        return const SizedBox();
    }
  }

  Widget _simularContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "QUE ES FACTURA FIJA DE LA ANDE",
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                "Es un servicio que se pone a disposición de todos los clientes conectados en Baja Tensión...",
                overflow: TextOverflow.clip,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 24),

              // FORMULARIO
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nisController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'NIS'),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Ingrese NIS'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoadingSolicitud
                            ? null
                            : () => enviarFormulario(),
                        child: _isLoadingSolicitud
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Simular"),
                      ),
                    ),
                  ],
                ),
              ),
              if (resultadoFacturaFija != null) ...[
                const SizedBox(height: 24),
                _resultadoBox(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _ventajasContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CustomText(
            "VENTAJAS",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 6),
          CustomText(
            "1. Es un servicio optativo y sin costo con el que el Cliente conocerá el importe que estará pagando cada uno de los meses durante un año.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),

          CustomText(
            "2. La adhesión al servicio podrá ser realizada a través de la página web de la ANDE, la aplicación Mi ANDE para teléfonos inteligentes o en cualquier Oficina de Atención al Cliente en todo el país.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          CustomText(
            "3. La renovación será automática, en cuyo caso se realizará un nuevo cálculo del importe a pagar, en base al nuevo promedio de consumos.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          CustomText(
            "4. La diferencia de importes resultante entre lo abonado a través de las facturas fijas y lo realmente consumido, será distribuida proporcionalmente mediante créditos o débitos, según corresponda, en los siguientes 12 meses.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          CustomText(
            "5. La cancelación podrá ser realizada cuando el Cliente lo desee, en cuyo caso la diferencia de importes entre lo abonado a través de las facturas fijas y lo realmente consumido hasta ese mes, será ingresado en la siguiente factura.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _condicionesContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CustomText(
            "CONDICIONES PARA LA SUSCRIPCION AL SERVICIO DE FACTURA FIJA",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 6),
          CustomText(
            "1. El suministro debe estar con Contrato activo, en Baja Tensión y no pertenecer a la Tarifa Social.\n2. No debe poseer facturas pendientes de pago.\n3. Debe tener como mínimo de 3 (tres) meses de facturación con lectura de medidor valida.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 6),

          CustomText(
            "LA ANDE PODRA CANCELAR EL SERVICIO EN LOS SIGUIENTES CASOS:",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          CustomText(
            "1. Falta de pago de 3 (tres) facturas fijas.\n2. Consumos de energía muy superiores al establecido para el cálculo de la Factura Fija.\n3. Irregularidad constatada en las instalaciones eléctricas del suministro.\n4. Incorrección de datos consignados en la Solicitud de Servicio.\n5. El cambio de las condiciones en el contrato de suministro: variación de la potencia o de la tarifa contratada.\n6. El cambio de Titularidad del Contrato\n7. La baja del Contrato.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 6),

          CustomText(
            "En todos los casos, la diferencia de importes entre lo abonado a través de las facturas fijas y lo realmente consumido hasta ese mes, será ingresado en la siguiente factura",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 6),

          RichText(
            text: TextSpan(
              style: TextStyle(
                // color: Colors.black,
              ), // Estilo por defecto para todo el texto
              children: <TextSpan>[
                // TextSpan(text: 'Este es texto normal, '),
                TextSpan(
                  text: 'Observación:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: CustomText(
                    'La Factura, además del importe fijo por consumo de energía, podrá incluir cuotas e intereses de acuerdos a plazos, alumbrado público u otros cargos eventuales.',
                    textAlign: TextAlign.justify,
                  ).text,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultadoBox() {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: BoxBorder.all(color: isDark ? Colors.green : Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mostramos los datos
              CustomText(
                '${resultadoFacturaFija!.nombre!} ${resultadoFacturaFija!.apellido!}',
                fontWeight: FontWeight.bold,
              ),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
                width: double.infinity,
                child: CustomText("Cálculo del Consumo Fijo"),
              ),

              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(
                        resultadoFacturaFija!.consumoRedondeado.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Consumo en base a histórico de consumo kWh',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(
                        resultadoFacturaFija!.precioTarifa.toString(),
                      ),
                      textAlign: TextAlign.right,
                      underline: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Tarifa Gs.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(
                        resultadoFacturaFija!.importeConsumo.toString(),
                      ),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        // color: Colors.black,
                      ), // Estilo por defecto para todo el texto
                      children: <TextSpan>[
                        // TextSpan(text: 'Este es texto normal, '),
                        TextSpan(
                          text: 'Importe del Consumo Fijo en Gs.\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '(Consumo multiplicado por Tarifa)'),
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
                width: double.infinity,
                child: CustomText("Importe Total del Consumo Fijo"),
              ),

              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(
                        resultadoFacturaFija!.importeConsumo.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Importe del Consumo Fijo en Gs.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(
                        resultadoFacturaFija!.importeAlumbrado.toString(),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Importe Alumbrado en Gs.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(resultadoFacturaFija!.iva.toString()),
                      textAlign: TextAlign.right,
                      underline: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'IVA en Gs.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      formatNumero(
                        resultadoFacturaFija!.importeConsumo! +
                            resultadoFacturaFija!.importeAlumbrado! +
                            resultadoFacturaFija!.iva!,
                      ),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        //color: Colors.black,
                      ), // Estilo por defecto para todo el texto
                      children: <TextSpan>[
                        // TextSpan(text: 'Este es texto normal, '),
                        TextSpan(
                          text: '* Importe Total Gs.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' (Consumo Fijo + \nAlumbrado Público + IVA)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        CustomText(
          "¿Cómo Acceder a la Factura Fija de ANDE?",
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          "El cliente Titular del Contrato o la persona autorizada por éste, puede suscribirse al servicio de las siguientes maneras:\n\n1) En forma presencial en cualquier Oficina de Atención al Cliente de la ANDE.\n\n2) Vía remota (WEB), ingresando el NIS en el simulador que se encuentra a la izquierda y completando el siguiente formulario:",
          overflow: TextOverflow.clip,
        ),
        const SizedBox(height: 16),

        resultadoFacturaFija!.habilitarFormulario == 'S'
            ? SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoadingSolicitud
                      ? null
                      : () => _enviarFormulario(),
                  child: _isLoadingSolicitud
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Completar Formulario"),
                ),
              )
            : CustomCard(
                borderWidth: 2,
                borderColor: Colors.red,
                child: CustomText(
                  "Suministro con deuda pendiente o situación de contrato incorrecto.",
                  overflow: TextOverflow.clip,
                ),
              ),
        const SizedBox(height: 16),
      ],
    );
  }
}

Widget filasNumerosLetras(List<num?> numeros, List<String> letras) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: numeros.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: CustomText(
                formatNumero(numeros[index]!.toString()),
                textAlign: TextAlign.right,
                underline: letras[index].contains("Tarifa Gs") ? true : false,
                fontWeight:
                    letras[index].contains(
                      "Importe del Consumo Fijo en Gs. (Consumo multiplicado por Tarifa)",
                    )
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                letras[index],
                overflow: TextOverflow.clip,
                fontWeight:
                    letras[index].contains(
                      "Importe del Consumo Fijo en Gs. (Consumo multiplicado por Tarifa)",
                    )
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _enviarFormulario() async {}
