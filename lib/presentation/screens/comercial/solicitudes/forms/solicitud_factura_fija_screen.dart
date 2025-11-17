import 'package:flutter/material.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

class SolicitudFacturaFijaScreen extends StatefulWidget {
  const SolicitudFacturaFijaScreen({super.key});

  @override
  State<SolicitudFacturaFijaScreen> createState() =>
      BotonesColoresPantallaState();
}

class BotonesColoresPantallaState extends State<SolicitudFacturaFijaScreen> {
  int selectedIndex = 0;

  final List<Color> buttonColors = [Colors.green, Colors.blue, Colors.orange];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Botones con espacio")),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: _buildTabButton(0, "Simular")),
                const SizedBox(width: 6), // <-- ESPACIO
                Expanded(child: _buildTabButton(1, "Ventajas")),
                const SizedBox(width: 6), // <-- ESPACIO
                Expanded(child: _buildTabButton(2, "Condiciones")),
              ],
            ),
          ),

          Expanded(child: _buildContent(selectedIndex)),
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
          borderRadius: BorderRadius.circular(6), // opcional: bordes suaves
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

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return _contentBox("Contenido del botón 1", Colors.blue.shade50, 1);
      case 1:
        return _contentBox("Contenido del botón 2", Colors.green.shade50, 2);
      case 2:
        return _contentBox("Contenido del botón 3", Colors.orange.shade50, 3);
      default:
        return const SizedBox();
    }
  }

  Widget _contentBox(String text, Color color, num posicion) {
    final nisController = TextEditingController();

    bool _isLoadingSolicitud = false;
    final _formKey = GlobalKey<FormState>();

    void enviarFormulario() async {
      if (_isLoadingSolicitud) return;

      if (!_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingrese los campos obligatorios')),
        );
        return;
      }

      setState(() => _isLoadingSolicitud = true);
    }

    if (posicion == 1) {
      return Container(
        width: double.infinity,
        // color: color,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "QUE ES FACTURA FIJA DE LA ANDE",
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              "Es un servicio que se pone a disposición de todos los clientes conectados en Baja Tensión, que permite abonar un importe fijo mensual, durante todo un año (12 meses). Este importe es calculado en base al histórico de consumos que registro en los 12 meses anteriores. El cliente va a seguir recibiendo normalmente su factura, ya que su medidor seguirá siendo leído y también se le mantendrá informado a través de mensajes de texto a un numero de celular que el cliente informará a la ANDE.",
              overflow: TextOverflow.clip,
              textAlign: TextAlign.justify,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: nisController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'NIS'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese NIS';
                      }

                      return null;
                    },
                    //enabled: !isLoading,
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Simular"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (posicion == 2) {
      return Container(child: Text("ventajas"));
    }

    return Container(child: Text("condiciones"));
  }
}
