import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/datos_card.dart';
import 'package:form/presentation/components/common/factura_scroll_horizontal.dart';
import 'package:form/presentation/components/common/info_card.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../../repositories/repositories.dart';

class ConsultaFacturasScreen extends ConsumerStatefulWidget {
  const ConsultaFacturasScreen({super.key});

  @override
  ConsumerState<ConsultaFacturasScreen> createState() =>
      _ConsultaFacturasScreenState();
}

class _ConsultaFacturasScreenState
    extends ConsumerState<ConsultaFacturasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nisController = TextEditingController();

  List<Lista?>? facturas; // <-- aquí guardamos los resultados
  DatosCliente? datosCliente;

  bool isLoading = false;

  Future<void> _consultar() async {
    if (!_formKey.currentState!.validate()) return;

    final nis = _nisController.text;
    final authState = ref.read(authProvider);
    final token = authState.value?.user?.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Su sesión ha expirado, debe volver a logearse'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final repoConsultaFacturas = ConsultaFacturasRepositoryImpl(
        ConsultaFacturasDatasourceImpl(MiAndeApi()),
      );

      final consultaFacturasResponse = await repoConsultaFacturas
          .getConsultaFacturas(nis, '15', token);

      if (consultaFacturasResponse.error == true) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Favor intente nuevamente la consulta"),
          ),
        );*/
        CustomSnackbar.show(
          context,
          message: "Ocurrió un error, Favor intente nuevamente la consulta",
          type: MessageType.error,
        );

        setState(() {
          facturas = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        facturas = consultaFacturasResponse.resultado?.lista;
        datosCliente = consultaFacturasResponse.resultado?.datosCliente;
        isLoading = false;
      });

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultando NIS: $nis')),
      );*/
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generar cards de InfoCard a partir de facturas
    final List<InfoCard> cards = facturas != null
        ? facturas!
              .asMap()
              .entries
              .map(
                (entry) => InfoCard(
                  title: 'Factura ${entry.key + 1}',
                  subtitle: 'Importe: ${entry.value?.importeCuenta ?? 0}',
                  buttonText: 'Ver',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Presionaste la factura ${entry.key + 1}',
                        ),
                      ),
                    );
                  },
                ),
              )
              .toList()
        : [];

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(title: const Text('Consulta de Facturas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 8, // 80% del espacio
                      child: TextFormField(
                        controller: _nisController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'NIS',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un NIS';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Solo números permitidos';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8), // separación entre input y botón
                    Expanded(
                      flex: 2, // 20% del espacio
                      child: Container(
                        height:
                            60, // opcional: para igualar altura del TextFormField
                        decoration: BoxDecoration(
                          //color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.star_border_sharp,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _consultar,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Consultar'),
                ),
                const SizedBox(height: 20),
                if (facturas != null && facturas!.isNotEmpty) ...[
                  DatosCard(
                    datosCliente: datosCliente,
                    nis: _nisController.text,
                  ),
                  FacturaScrollHorizontal(
                    facturas: facturas,
                    nis: _nisController,
                  ),
                  const SizedBox(height: 16),
                  //InfoCardHorizontalList(cards: cards),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
